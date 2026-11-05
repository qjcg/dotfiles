;;; jg-dashboard-tests.el --- Dashboard regression tests -*- lexical-binding: t; -*-

(require 'ert)
(require 'jg-dashboard)

(defconst jg-dashboard-test--json
  "{\"current_condition\":[{\"temp_C\":\"18\",\"temp_F\":\"64\",\"FeelsLikeC\":\"17\",\"FeelsLikeF\":\"63\",\"weatherDesc\":[{\"value\":\"Partly cloudy\"}]}],\"weather\":[{\"date\":\"2026-11-04\",\"mintempC\":\"10\",\"maxtempC\":\"20\",\"mintempF\":\"50\",\"maxtempF\":\"68\"}]}")

(defmacro jg-dashboard-test--with-dashboard (&rest body)
  "Run BODY with isolated buffers, a fixed date, and a fake URL transport."
  (declare (indent 0) (debug t))
  `(let ((jg-dashboard--buffer-name " *jg-dashboard-test*")
         (jg-dashboard--weather-cache nil)
         (jg-dashboard--weather-error nil)
         (jg-dashboard--weather-request nil)
         (jg-dashboard--timer nil)
         (jg-dashboard-effect nil)
         (jg-dashboard-panel-layout nil)
         (jg-dashboard-panel-grid '(4 . 2))
         (jg-dashboard-effect-interval 0.15)
         (jg-dashboard-effect-height 5)
         (jg-dashboard-effect-particles 24)
         (jg-dashboard-weather-location nil)
         (jg-dashboard-weather-units 'celsius)
         (jg-dashboard-weather-cache-seconds 1800)
         (jg-dashboard-weather-timeout 10)
         (jg-dashboard-menu-function #'jg-dashboard-placeholder-menu)
         (jg-dashboard-quotes '(("Keep going." . "One") ("Begin again." . "Two")))
         (today '(11 4 2026))
         jobs)
     (cl-letf (((symbol-function 'jg-dashboard--today) (lambda () today))
               ((symbol-function 'url-retrieve)
                (lambda (url callback args &rest _)
                  (let ((buffer (generate-new-buffer " *weather-test*")))
                    (push (list :url url :callback callback :args args :buffer buffer) jobs)
                    buffer))))
       (unwind-protect (progn ,@body)
         (when-let* ((buffer (get-buffer jg-dashboard--buffer-name)))
           (kill-buffer buffer))
         (jg-dashboard--cleanup)
         (dolist (job jobs)
           (when (buffer-live-p (plist-get job :buffer))
             (kill-buffer (plist-get job :buffer))))))))

(defun jg-dashboard-test--body ()
  "Return the rendered dashboard text."
  (with-current-buffer (get-buffer jg-dashboard--buffer-name) (buffer-string)))

(defun jg-dashboard-test--respond (job &optional json http-status status)
  "Deliver JSON, HTTP-STATUS and URL STATUS to the fake transport JOB."
  (with-current-buffer (plist-get job :buffer)
    (erase-buffer)
    (insert "HTTP/1.1 200 OK\r\nContent-Type: application/json\r\n\r\n")
    (setq-local url-http-response-status (or http-status 200)
                url-http-end-of-headers (point-marker))
    (insert (or json jg-dashboard-test--json))
    (apply (plist-get job :callback) status (plist-get job :args))))

(ert-deftest jg-dashboard-test-default-week-and-placeholders ()
  (jg-dashboard-test--with-dashboard
    (jg-dashboard-buffer)
    (let ((text (jg-dashboard-test--body)))
      (should (string-match-p "Wednesday, 04 November 2026" text))
      (should (string-match-p "Week of 2026-11-02" text))
      (dolist (date '("Mon 02 Nov" "Tue 03 Nov" "Wed 04 Nov" "Thu 05 Nov"
                      "Fri 06 Nov" "Sat 07 Nov" "Sun 08 Nov"))
        (should (string-match-p date text)))
      (should (= 14 (with-temp-buffer
                      (insert text)
                      (how-many "To be confirmed" (point-min) (point-max)))))
      (should (string-match-p "A thought for today" text)))
    (should-not jobs)))

(ert-deftest jg-dashboard-test-week-boundaries ()
  (jg-dashboard-test--with-dashboard
    (dolist (example '(((11 1 2026) "2026-10-26" "Sun 01 Nov")
                       ((1 1 2027) "2026-12-28" "Sun 03 Jan")
                       ((2 29 2028) "2028-02-28" "Sun 05 Mar")))
      (setq today (car example))
      (jg-dashboard-buffer)
      (should (string-match-p (nth 1 example) (jg-dashboard-test--body)))
      (should (string-match-p (nth 2 example) (jg-dashboard-test--body))))))

(ert-deftest jg-dashboard-test-menu-source-and-missing-meals ()
  (jg-dashboard-test--with-dashboard
    (let (received)
      (setq jg-dashboard-menu-function
            (lambda (start)
              (setq received start)
              '(("2026-11-04" . (:breakfast "Porridge" :lunch "Vegetable soup"))
                ("2026-11-05" . (:breakfast "  " :lunch "Pasta")))))
      (jg-dashboard-buffer)
      (should (equal received "2026-11-02"))
      (dolist (meal '("Porridge" "Vegetable soup" "Pasta" "To be confirmed"))
        (should (string-match-p meal (jg-dashboard-test--body)))))))

(ert-deftest jg-dashboard-test-menu-failure-is-not-fatal ()
  (jg-dashboard-test--with-dashboard
    (setq jg-dashboard-menu-function (lambda (_) (error "Source offline")))
    (jg-dashboard-buffer)
    (should (string-match-p "Menu unavailable: Source offline" (jg-dashboard-test--body)))
    (should (string-match-p "A thought for today" (jg-dashboard-test--body)))))

(ert-deftest jg-dashboard-test-narrow-layout-and-wrapping ()
  (jg-dashboard-test--with-dashboard
    (setq jg-dashboard-menu-function
          (lambda (_)
            '(("2026-11-04" . (:breakfast "Fruit toast and a cup of tea with honey" :lunch "Soup")))))
    (cl-letf (((symbol-function 'window-max-chars-per-line) (lambda (&rest _) 44)))
      (jg-dashboard-buffer)
      (let ((text (jg-dashboard-test--body)))
        (should (string-match-p "Wednesday 04 Nov" text))
        (should (string-match-p "Breakfast: Fruit toast and a cup" text))
        (should (string-match-p "of tea with honey" text))
        (should (string-match-p "Lunch: Soup" text))))))

(ert-deftest jg-dashboard-test-buffer-is-read-only-and-does-not-steal-focus ()
  (jg-dashboard-test--with-dashboard
    (let ((original (current-buffer))
          (window (selected-window))
          (buffer (jg-dashboard-buffer)))
      (should (eq original (current-buffer)))
      (should (eq window (selected-window)))
      (with-current-buffer buffer
        (should (derived-mode-p 'jg-dashboard-mode))
        (should buffer-read-only)
        (should-not (buffer-modified-p))
        (should (eq (lookup-key jg-dashboard-mode-map (kbd "g")) #'jg-dashboard-refresh))
        (goto-char (point-min))
        (search-forward "Wed 04 Nov")
        (should (memq 'jg-dashboard-today (get-text-property (1- (point)) 'face)))))))

(ert-deftest jg-dashboard-test-quote-stable-per-day-and-rotates ()
  (jg-dashboard-test--with-dashboard
    (jg-dashboard-buffer)
    (let ((first (jg-dashboard-test--body)))
      (jg-dashboard-refresh)
      (should (equal first (jg-dashboard-test--body)))
      (setq today '(11 5 2026))
      (jg-dashboard-refresh)
      (should-not (equal (not (null (string-match-p "Keep going" first)))
                         (not (null (string-match-p "Keep going" (jg-dashboard-test--body)))))))))

(ert-deftest jg-dashboard-test-empty-quotes ()
  (jg-dashboard-test--with-dashboard
    (setq jg-dashboard-quotes nil)
    (jg-dashboard-buffer)
    (should (string-match-p "Add a favourite" (jg-dashboard-test--body)))))

(ert-deftest jg-dashboard-test-buttons-invoke-their-own-commands ()
  (jg-dashboard-test--with-dashboard
    (jg-dashboard-buffer)
    (let (invoked)
      (cl-letf (((symbol-function 'call-interactively) (lambda (command &rest _) (push command invoked))))
        (with-current-buffer (get-buffer jg-dashboard--buffer-name)
          (goto-char (point-min))
          (dolist (name '("Refresh" "Customize" "Close"))
            (search-forward name)
            (button-activate (button-at (1- (point)))))))
      (should (equal (reverse invoked)
                     '(jg-dashboard-refresh jg-dashboard-customize quit-window))))))

(ert-deftest jg-dashboard-test-blank-location-disables-network ()
  (jg-dashboard-test--with-dashboard
    (setq jg-dashboard-weather-location "  ")
    (jg-dashboard-buffer)
    (jg-dashboard-refresh t)
    (should-not jobs)
    (should (string-match-p "Set jg-dashboard-weather-location" (jg-dashboard-test--body)))))

(ert-deftest jg-dashboard-test-celsius-response-and-cache ()
  (jg-dashboard-test--with-dashboard
    (setq jg-dashboard-weather-location "New York,US")
    (jg-dashboard-buffer)
    (should (equal (plist-get (car jobs) :url) "https://wttr.in/New%20York%2CUS?format=j1"))
    (should (string-match-p "Loading weather" (jg-dashboard-test--body)))
    (jg-dashboard-refresh t)
    (should (= 1 (length jobs)))
    (jg-dashboard-test--respond (car jobs))
    (dolist (text '("Partly cloudy" "18°C" "Feels like 17°C" "Low 10°C / High 20°C"))
      (should (string-match-p text (jg-dashboard-test--body))))
    (should-not (buffer-live-p (plist-get (car jobs) :buffer)))
    (should-not jg-dashboard--weather-request)
    (jg-dashboard-refresh)
    (should (= 1 (length jobs)))
    (jg-dashboard-refresh t)
    (should (= 2 (length jobs)))
    (should (string-match-p "Refreshing" (jg-dashboard-test--body)))))

(ert-deftest jg-dashboard-test-fahrenheit ()
  (jg-dashboard-test--with-dashboard
    (setq jg-dashboard-weather-location "Test" jg-dashboard-weather-units 'fahrenheit)
    (jg-dashboard-buffer)
    (jg-dashboard-test--respond (car jobs))
    (should (string-match-p "64°F" (jg-dashboard-test--body)))
    (should (string-match-p "Low 50°F / High 68°F" (jg-dashboard-test--body)))
    (should-not (string-match-p "°C" (jg-dashboard-test--body)))))

(ert-deftest jg-dashboard-test-expired-cache-refreshes ()
  (jg-dashboard-test--with-dashboard
    (setq jg-dashboard-weather-location "Test")
    (jg-dashboard-buffer)
    (jg-dashboard-test--respond (car jobs))
    (setf (plist-get jg-dashboard--weather-cache :time) (seconds-to-time 0))
    (jg-dashboard-refresh)
    (should (= 2 (length jobs)))))

(ert-deftest jg-dashboard-test-http-json-and-network-failures ()
  (jg-dashboard-test--with-dashboard
    (setq jg-dashboard-weather-location "Test")
    (dolist (example '((nil 503 nil "HTTP 503")
                       ("not json" 200 nil "Weather unavailable")
                       ("{}" 200 nil "Missing current weather")
                       (nil 200 (:error (error connection-failed)) "Network request failed")))
      (jg-dashboard-buffer)
      (jg-dashboard-test--respond (car jobs) (nth 0 example) (nth 1 example) (nth 2 example))
      (should (string-match-p (nth 3 example) (jg-dashboard-test--body)))
      (should (string-match-p "Weekly menu" (jg-dashboard-test--body)))
      (should-not jg-dashboard--weather-request))))

(ert-deftest jg-dashboard-test-refresh-failure-retains-cached-weather ()
  (jg-dashboard-test--with-dashboard
    (setq jg-dashboard-weather-location "Test")
    (jg-dashboard-buffer)
    (jg-dashboard-test--respond (car jobs))
    (jg-dashboard-refresh t)
    (jg-dashboard-test--respond (car jobs) nil 503)
    (should (string-match-p "18°C" (jg-dashboard-test--body)))
    (should (string-match-p "showing cached weather" (jg-dashboard-test--body)))))

(ert-deftest jg-dashboard-test-timeout-and-late-callback ()
  (jg-dashboard-test--with-dashboard
    (setq jg-dashboard-weather-location "Test")
    (jg-dashboard-buffer)
    (let* ((job (car jobs))
           (request jg-dashboard--weather-request)
           (timer (jg-dashboard--request-timer request)))
      (jg-dashboard--weather-timeout request)
      (should-not jg-dashboard--weather-request)
      (should-not (memq timer timer-list))
      (should-not (buffer-live-p (plist-get job :buffer)))
      (should (string-match-p "Request timed out" (jg-dashboard-test--body)))
      ;; Simulate a sentinel delivering an old response after cancellation.
      (setf (plist-get job :buffer) (generate-new-buffer " *weather-late*"))
      (jg-dashboard-test--respond job)
      (should-not jg-dashboard--weather-cache)
      (should (string-match-p "Request timed out" (jg-dashboard-test--body))))))

(ert-deftest jg-dashboard-test-location-units-and-date-isolate-cache ()
  (jg-dashboard-test--with-dashboard
    (setq jg-dashboard-weather-location "First")
    (jg-dashboard-buffer)
    (jg-dashboard-test--respond (car jobs))
    (setq jg-dashboard-weather-location "Second")
    (jg-dashboard-refresh)
    (should-not (string-match-p "18°C" (jg-dashboard-test--body)))
    (jg-dashboard-test--respond (car jobs))
    (setq jg-dashboard-weather-units 'fahrenheit)
    (jg-dashboard-refresh)
    (should-not (string-match-p "18°C" (jg-dashboard-test--body)))
    (jg-dashboard-test--respond (car jobs))
    (setq today '(11 5 2026))
    (jg-dashboard-refresh)
    (should-not (string-match-p "64°F" (jg-dashboard-test--body)))
    (should (= 4 (length jobs)))))

(ert-deftest jg-dashboard-test-superseded-request-cannot-overwrite ()
  (jg-dashboard-test--with-dashboard
    (setq jg-dashboard-weather-location "First")
    (jg-dashboard-buffer)
    (let ((old (car jobs)))
      (setq jg-dashboard-weather-location "Second")
      (jg-dashboard-refresh)
      (should-not (buffer-live-p (plist-get old :buffer)))
      (jg-dashboard-test--respond (car jobs))
      (setf (plist-get old :buffer) (generate-new-buffer " *weather-late*"))
      (jg-dashboard-test--respond old)
      (should (string-match-p "Second · Partly cloudy" (jg-dashboard-test--body)))
      (should (equal (car (plist-get jg-dashboard--weather-cache :key)) "Second")))))

(ert-deftest jg-dashboard-test-disabling-weather-cancels-request ()
  (jg-dashboard-test--with-dashboard
    (setq jg-dashboard-weather-location "Test")
    (jg-dashboard-buffer)
    (setq jg-dashboard-weather-location nil)
    (jg-dashboard-refresh)
    (should-not jg-dashboard--weather-request)
    (should-not (buffer-live-p (plist-get (car jobs) :buffer)))
    (should (string-match-p "Set jg-dashboard-weather-location" (jg-dashboard-test--body)))))

(ert-deftest jg-dashboard-test-buffer-kill-cleans-up-timers-and-request ()
  (jg-dashboard-test--with-dashboard
    (setq jg-dashboard-weather-location "Test")
    (jg-dashboard-buffer)
    (let ((tick jg-dashboard--timer)
          (timeout (jg-dashboard--request-timer jg-dashboard--weather-request)))
      (kill-buffer (get-buffer jg-dashboard--buffer-name))
      (should-not jg-dashboard--weather-request)
      (should-not jg-dashboard--timer)
      (should-not (memq tick timer-list))
      (should-not (memq timeout timer-list))
      (should-not (buffer-live-p (plist-get (car jobs) :buffer))))))

(ert-deftest jg-dashboard-test-hidden-buffer-does-not-poll ()
  (jg-dashboard-test--with-dashboard
    (setq jg-dashboard-weather-location "Test")
    (jg-dashboard-buffer)
    (jg-dashboard-test--respond (car jobs))
    (setq jg-dashboard-weather-cache-seconds 0)
    (jg-dashboard--tick)
    (should (= 1 (length jobs)))
    (save-window-excursion
      (switch-to-buffer (get-buffer jg-dashboard--buffer-name))
      (jg-dashboard--tick)
      (should (= 2 (length jobs))))))

(ert-deftest jg-dashboard-test-synchronous-url-backend ()
  (jg-dashboard-test--with-dashboard
    (setq jg-dashboard-weather-location "Test")
    (cl-letf (((symbol-function 'url-retrieve)
               (lambda (_url callback args &rest _)
                 (let* ((buffer (generate-new-buffer " *weather-sync*"))
                        (job (list :buffer buffer :callback callback :args args)))
                   (jg-dashboard-test--respond job)
                   buffer))))
      (jg-dashboard-buffer)
      (should-not jg-dashboard--weather-request)
      (should (string-match-p "18°C" (jg-dashboard-test--body))))))

(ert-deftest jg-dashboard-test-url-start-failure ()
  (jg-dashboard-test--with-dashboard
    (setq jg-dashboard-weather-location "Test")
    (cl-letf (((symbol-function 'url-retrieve) (lambda (&rest _) (error "Transport unavailable"))))
      (jg-dashboard-buffer)
      (should-not jg-dashboard--weather-request)
      (should (string-match-p "Transport unavailable" (jg-dashboard-test--body))))))

(ert-deftest jg-dashboard-test-startup-and-keybinding-integration ()
  (jg-dashboard-test--with-dashboard
    (require 'use-package)
    (let ((initial-buffer-choice nil)
          (original-map (current-global-map))
          (appearance (expand-file-name "../lisp/init/jg-appearance.el"
                                        (file-name-directory
                                         (or load-file-name
                                             (symbol-file 'jg-dashboard-test--body 'defun))))))
      (unwind-protect
          (progn
            (use-global-map (copy-keymap original-map))
            ;; Evaluate the real wiring, not a duplicate of its settings.
            (with-temp-buffer
              (insert-file-contents appearance)
              (goto-char (point-min))
              (let (form)
                (while (not (and (eq (car-safe form) 'use-package)
                                (eq (cadr form) 'jg-dashboard)))
                  (setq form (read (current-buffer))))
                (eval form t)))
            (should (eq (key-binding (kbd "C-c h")) #'jg-dashboard-open))
            (should (eq initial-buffer-choice #'jg-dashboard-buffer))
            (should (buffer-live-p (funcall initial-buffer-choice))))
        (use-global-map original-map)))))

(ert-deftest jg-dashboard-test-effects-off-by-default ()
  (jg-dashboard-test--with-dashboard
    (with-current-buffer (jg-dashboard-buffer)
      (should-not jg-dashboard-effect)
      (should-not jg-dashboard--effect-timer)
      (should-not jg-dashboard--effect-overlays)
      (should-not jg-dashboard--effect-rows)
      (should (string-match-p "Effects: off" (buffer-string)))
      (should (eq (lookup-key jg-dashboard-mode-map (kbd "s")) #'jg-dashboard-toggle-snow))
      (should (eq (lookup-key jg-dashboard-mode-map (kbd "e")) #'jg-dashboard-select-effect)))))

(ert-deftest jg-dashboard-test-snow-animates-without-editing-or-fetching ()
  (jg-dashboard-test--with-dashboard
    (save-window-excursion
      (switch-to-buffer (jg-dashboard-buffer))
      (jg-dashboard-toggle-snow)
      (should (eq jg-dashboard-effect 'snow))
      (should (timerp jg-dashboard--effect-timer))
      (should (= 5 (length jg-dashboard--effect-overlays)))
      (should (string-match-p "Effects: snow" (buffer-string)))
      (let ((text (buffer-string))
            (position (point))
            (window (selected-window))
            (pictures (mapcar (lambda (overlay) (overlay-get overlay 'display))
                              jg-dashboard--effect-overlays)))
        (jg-dashboard--effect-tick (current-buffer))
        (should (equal text (buffer-string)))
        (should (= position (point)))
        (should (eq window (selected-window)))
        (should buffer-read-only)
        (should-not (buffer-modified-p))
        (should-not (equal pictures
                           (mapcar (lambda (overlay) (overlay-get overlay 'display))
                                   jg-dashboard--effect-overlays)))
        (should-not jobs)))))

(ert-deftest jg-dashboard-test-snow-toggle-removes-owned-effects ()
  (jg-dashboard-test--with-dashboard
    (save-window-excursion
      (switch-to-buffer (jg-dashboard-buffer))
      (let ((other-overlay (make-overlay (point-min) (1+ (point-min)))))
        (unwind-protect
            (progn
              (jg-dashboard-toggle-snow)
              (let ((timer jg-dashboard--effect-timer)
                    (overlays jg-dashboard--effect-overlays))
                (jg-dashboard-toggle-snow)
                (should-not jg-dashboard-effect)
                (should-not jg-dashboard--effect-timer)
                (should-not (memq timer timer-list))
                (should-not jg-dashboard--effect-rows)
                (should-not jg-dashboard--effect-overlays)
                (should (cl-every (lambda (overlay) (null (overlay-buffer overlay))) overlays))
                (should (overlay-buffer other-overlay))
                (should (string-match-p "Weekly menu" (buffer-string)))))
          (delete-overlay other-overlay))))))

(ert-deftest jg-dashboard-test-select-rain-stars-and-off ()
  (jg-dashboard-test--with-dashboard
    (save-window-excursion
      (switch-to-buffer (jg-dashboard-buffer))
      (dolist (effect '(rain stars snow))
        (jg-dashboard-select-effect effect)
        (should (eq jg-dashboard-effect effect))
        (should (timerp jg-dashboard--effect-timer))
        (should (= 5 (length jg-dashboard--effect-overlays)))
        (jg-dashboard--effect-tick (current-buffer)))
      (jg-dashboard-select-effect nil)
      (should-not jg-dashboard--effect-overlays)
      (should-not jg-dashboard--effect-timer)
      (should-error (jg-dashboard-select-effect 'unknown) :type 'user-error)
      (should-not jg-dashboard-effect))))

(ert-deftest jg-dashboard-test-effect-picker-and-button ()
  (jg-dashboard-test--with-dashboard
    (with-current-buffer (jg-dashboard-buffer)
      (cl-letf (((symbol-function 'completing-read) (lambda (&rest _) "snow")))
        (goto-char (point-min))
        (search-forward "Effects: off")
        (button-activate (button-at (1- (point)))))
      (should (eq jg-dashboard-effect 'snow))
      (cl-letf (((symbol-function 'completing-read) (lambda (&rest _) "off")))
        (call-interactively #'jg-dashboard-select-effect))
      (should-not jg-dashboard-effect))))

(ert-deftest jg-dashboard-test-effect-default-and-local-choice ()
  (jg-dashboard-test--with-dashboard
    (setq jg-dashboard-effect 'rain)
    (with-current-buffer (jg-dashboard-buffer)
      (should (eq jg-dashboard-effect 'rain))
      (should-not jg-dashboard--effect-timer)
      (jg-dashboard-toggle-snow)
      (should (eq jg-dashboard-effect 'snow))
      (should (local-variable-p 'jg-dashboard-effect)))
    (should (eq jg-dashboard-effect 'rain))
    (kill-buffer (get-buffer jg-dashboard--buffer-name))
    (with-current-buffer (jg-dashboard-buffer)
      (should (eq jg-dashboard-effect 'rain)))))

(ert-deftest jg-dashboard-test-hidden-effects-pause-and-resume ()
  (jg-dashboard-test--with-dashboard
    (save-window-excursion
      (let ((dashboard (jg-dashboard-buffer))
            (editor (current-buffer)))
        (switch-to-buffer dashboard)
        (jg-dashboard-toggle-snow)
        (let ((timer jg-dashboard--effect-timer)
              (frame jg-dashboard--effect-frame))
          (switch-to-buffer editor)
          (jg-dashboard--effect-tick dashboard)
          (with-current-buffer dashboard
            (should-not jg-dashboard--effect-timer)
            (should-not (memq timer timer-list))
            (should-not jg-dashboard--effect-overlays)
            (should (= frame jg-dashboard--effect-frame))
            (should (eq jg-dashboard-effect 'snow)))
          (switch-to-buffer dashboard)
          ;; Batch Emacs has no redisplay loop to dispatch the window hook.
          (run-hook-with-args 'window-buffer-change-functions (selected-window))
          (should (timerp jg-dashboard--effect-timer))
          (should (= 5 (length jg-dashboard--effect-overlays)))
          (jg-dashboard--effect-tick dashboard)
          (should (> jg-dashboard--effect-frame frame)))))))

(ert-deftest jg-dashboard-test-effect-refresh-rebuilds-anchors-without-timer-leak ()
  (jg-dashboard-test--with-dashboard
    (save-window-excursion
      (switch-to-buffer (jg-dashboard-buffer))
      (jg-dashboard-toggle-snow)
      (let ((timer jg-dashboard--effect-timer)
            (overlays jg-dashboard--effect-overlays))
        (jg-dashboard-refresh)
        (should (eq timer jg-dashboard--effect-timer))
        (should (cl-every (lambda (overlay) (null (overlay-buffer overlay))) overlays))
        (should (= 5 (length jg-dashboard--effect-overlays)))
        (dolist (marker jg-dashboard--effect-rows)
          (should (eq (char-after marker) ?\s)))
        (should (string-match-p "To be confirmed" (buffer-string)))))))

(ert-deftest jg-dashboard-test-effect-overlays-are-window-specific ()
  (jg-dashboard-test--with-dashboard
    (save-window-excursion
      (switch-to-buffer (jg-dashboard-buffer))
      (let ((first (selected-window))
            (second (split-window-right)))
        (set-window-buffer second (current-buffer))
        (jg-dashboard-toggle-snow)
        (should (= 10 (length jg-dashboard--effect-overlays)))
        (should (eq first (selected-window)))
        (dolist (window (list first second))
          (let ((overlays (cl-remove-if-not
                           (lambda (overlay) (eq (overlay-get overlay 'window) window))
                           jg-dashboard--effect-overlays)))
            (should (= 5 (length overlays)))
            (dolist (overlay overlays)
              (should (= (string-width (overlay-get overlay 'display))
                         jg-dashboard--effect-width)))))))))

(ert-deftest jg-dashboard-test-effect-kill-and-mode-change-cleanup ()
  (jg-dashboard-test--with-dashboard
    (save-window-excursion
      (dolist (finish '(kill-buffer fundamental-mode))
        (switch-to-buffer (jg-dashboard-buffer))
        (jg-dashboard-toggle-snow)
        (let ((timer jg-dashboard--effect-timer)
              (overlays jg-dashboard--effect-overlays))
          (funcall finish)
          (should-not (memq timer timer-list))
          (should (cl-every (lambda (overlay) (null (overlay-buffer overlay))) overlays)))))))

(ert-deftest jg-dashboard-test-effect-settings-are-bounded ()
  (jg-dashboard-test--with-dashboard
    (setq jg-dashboard-effect-height 100
          jg-dashboard-effect-particles 10000
          jg-dashboard-effect-interval -1)
    (save-window-excursion
      (switch-to-buffer (jg-dashboard-buffer))
      (jg-dashboard-toggle-snow)
      (should (= 10 (length jg-dashboard--effect-rows)))
      (should (= 0.05 jg-dashboard--effect-timer-interval))
      (setq jg-dashboard-effect-particles 0)
      (jg-dashboard--effect-tick (current-buffer))
      (should (cl-every
               (lambda (overlay) (string-match-p "\\` +\\'" (overlay-get overlay 'display)))
               jg-dashboard--effect-overlays)))))

(ert-deftest jg-dashboard-test-effect-commands-require-dashboard ()
  (jg-dashboard-test--with-dashboard
    (should-error (jg-dashboard-toggle-snow) :type 'user-error)
    (should-not (get-buffer jg-dashboard--buffer-name))))

(defun jg-dashboard-test--wait-for (predicate)
  "Wait up to two seconds for PREDICATE while running real GUI redisplay."
  (let ((deadline (+ (float-time) 2)))
    (while (and (not (funcall predicate)) (< (float-time) deadline))
      (redisplay t)
      (sit-for 0.02))
    (should (funcall predicate))))

(ert-deftest jg-dashboard-test-live-animation-and-window-hooks ()
  (skip-unless (display-graphic-p))
  (jg-dashboard-test--with-dashboard
    (let ((noninteractive nil)
          (jg-dashboard-effect-interval 0.05))
      (save-window-excursion
        (let ((dashboard (jg-dashboard-buffer))
              (editor (current-buffer)))
          (switch-to-buffer dashboard)
          (jg-dashboard-toggle-snow)
          (jg-dashboard-test--wait-for (lambda () (> jg-dashboard--effect-frame 1)))
          (should (= 5 (length jg-dashboard--effect-overlays)))
          (switch-to-buffer editor)
          (jg-dashboard-test--wait-for
           (lambda () (null (buffer-local-value 'jg-dashboard--effect-timer dashboard))))
          (let ((frame (buffer-local-value 'jg-dashboard--effect-frame dashboard)))
            (switch-to-buffer dashboard)
            ;; Resumption must come from real redisplay hooks, not a manual sync.
            (jg-dashboard-test--wait-for (lambda () (> jg-dashboard--effect-frame frame)))
            (should (timerp jg-dashboard--effect-timer))
            (should (= 5 (length jg-dashboard--effect-overlays)))))))))

;;; jg-dashboard-tests.el ends here
