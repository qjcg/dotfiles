;;; jg-dashboard-panel-tests.el --- Movable panel tests -*- lexical-binding: t; -*-

;; Loaded after jg-dashboard-tests.el to reuse its isolated, network-free fixture.
(require 'ert)
(require 'jg-dashboard)

(defun jg-dashboard-panel-test--rectangle (id)
  "Read ID's actual rendered rectangle as (X Y WIDTH HEIGHT)."
  (let ((content (jg-dashboard-panels-content id)))
    (save-excursion
      (goto-char (cadr content))
      (list (- (current-column) 2)
            (- (line-number-at-pos) (line-number-at-pos jg-dashboard-panels--start) 1)
            (+ 4 (car content)) (+ 2 (length (cdr content)))))))

(defmacro jg-dashboard-panel-test--wide (&rest body)
  "Run BODY in an isolated dashboard with a 120-column canvas."
  (declare (indent 0))
  `(jg-dashboard-test--with-dashboard
     (cl-letf (((symbol-function 'window-max-chars-per-line) (lambda (&rest _) 124)))
       (with-current-buffer (jg-dashboard-buffer) ,@body))))

(defun jg-dashboard-panel-test--nonoverlapping ()
  "Check that the rectangles inferred from buffer text do not overlap."
  (let ((rectangles (mapcar #'jg-dashboard-panel-test--rectangle '(weather menu quote))))
    (cl-loop for tail on rectangles do
             (pcase-let ((`(,x ,y ,w ,h) (car tail)))
               (dolist (other (cdr tail))
                 (pcase-let ((`(,a ,b ,c ,d) other))
                   (should-not (and (< x (+ a c)) (< a (+ x w))
                                    (< y (+ b d)) (< b (+ y h))))))))))

(ert-deftest jg-dashboard-panel-test-boxes-and-side-by-side-layout ()
  (jg-dashboard-panel-test--wide
    (should (equal (cl-subseq (jg-dashboard-panel-test--rectangle 'weather) 0 2) '(0 0)))
    (should (equal (cl-subseq (jg-dashboard-panel-test--rectangle 'quote) 0 2) '(64 0)))
    (dolist (title '("Today's weather" "Weekly menu" "A thought for today"))
      (goto-char (point-min))
      (search-forward title)
      (let ((position (1- (point))))
        (should (get-text-property position 'jg-dashboard-panel-header))
        (should (eq (lookup-key (get-text-property position 'keymap) [down-mouse-1])
                    #'jg-dashboard-panels-drag))))
    (jg-dashboard-panel-test--nonoverlapping)))

(ert-deftest jg-dashboard-panel-test-moves-snap-in-both-dimensions ()
  (jg-dashboard-panel-test--wide
    (jg-dashboard-panels-move 'weather 11 3)
    (should (equal (cl-subseq (jg-dashboard-panel-test--rectangle 'weather) 0 2) '(12 4)))
    (should (equal (plist-get (alist-get 'weather jg-dashboard-panel-layout) :x) 12))
    (jg-dashboard-panel-test--nonoverlapping)
    (should-not jobs)))

(ert-deftest jg-dashboard-panel-test-table-column-padding-is-preserved ()
  (jg-dashboard-panel-test--wide
    (save-excursion
      (goto-char (cadr (jg-dashboard-panels-content 'menu)))
      (search-forward "Breakfast")
      (should (= 16 (- (current-column) 9)))
      (search-forward "Lunch")
      (should (= 51 (- (current-column) 5)))
      (search-forward "To be confirmed")
      (should (= 16 (- (current-column) 15)))
      (search-forward "To be confirmed")
      (should (= 51 (- (current-column) 15))))))

(ert-deftest jg-dashboard-panel-test-negative-and-out-of-bounds-drops ()
  (jg-dashboard-panel-test--wide
    (jg-dashboard-panels-move 'weather 10000 0)
    (should (equal (cl-subseq (jg-dashboard-panel-test--rectangle 'weather) 0 2) '(60 0)))
    (jg-dashboard-panels-move 'weather -20 -9)
    (should (equal (cl-subseq (jg-dashboard-panel-test--rectangle 'weather) 0 2) '(0 0)))
    (jg-dashboard-panel-test--nonoverlapping)))

(ert-deftest jg-dashboard-panel-test-collisions-move-other-panels-not-the-dropped-panel ()
  (jg-dashboard-panel-test--wide
    (jg-dashboard-panels-move 'weather 60 0)
    (should (equal (cl-subseq (jg-dashboard-panel-test--rectangle 'weather) 0 2) '(60 0)))
    (should (> (cadr (jg-dashboard-panel-test--rectangle 'quote)) 0))
    (jg-dashboard-panel-test--nonoverlapping)
    (let ((positions (jg-dashboard-panels--positions)))
      (jg-dashboard-refresh)
      (should (equal positions (jg-dashboard-panels--positions))))))

(ert-deftest jg-dashboard-panel-test-keyboard-movement-and-bindings ()
  (jg-dashboard-panel-test--wide
    (goto-char (cadr (jg-dashboard-panels-content 'weather)))
    (call-interactively (lookup-key jg-dashboard-mode-map (kbd "M-<right>")))
    (call-interactively (lookup-key jg-dashboard-mode-map (kbd "M-<down>")))
    (should (equal (cl-subseq (jg-dashboard-panel-test--rectangle 'weather) 0 2) '(4 2)))
    (call-interactively #'jg-dashboard-panels-left)
    (call-interactively #'jg-dashboard-panels-up)
    (should (equal (cl-subseq (jg-dashboard-panel-test--rectangle 'weather) 0 2) '(0 0)))
    (should (eq (lookup-key jg-dashboard-mode-map (kbd "S")) #'jg-dashboard-panels-save))
    (should (eq (lookup-key jg-dashboard-mode-map (kbd "R")) #'jg-dashboard-panels-reset))))

(ert-deftest jg-dashboard-panel-test-resize-reflows-without-overwriting-preferences ()
  (jg-dashboard-panel-test--wide
    (jg-dashboard-panels-move 'quote 72 0)
    (let ((saved (copy-tree jg-dashboard-panel-layout)))
      (cl-letf (((symbol-function 'window-max-chars-per-line) (lambda (&rest _) 44)))
        (jg-dashboard--render)
        (should (equal saved jg-dashboard-panel-layout))
        (jg-dashboard-panel-test--nonoverlapping)
        (dolist (id '(weather menu quote))
          (should (<= (nth 2 (jg-dashboard-panel-test--rectangle id)) 40))))
      (jg-dashboard--render)
      (should (equal (cl-subseq (jg-dashboard-panel-test--rectangle 'quote) 0 2) '(72 0))))))

(ert-deftest jg-dashboard-panel-test-unicode-text-does-not-break-column-placement ()
  (jg-dashboard-panel-test--wide
    (setq jg-dashboard-menu-function
          (lambda (_) '(("2026-11-04" . (:breakfast "水果和粥" :lunch "Crème brûlée")))))
    (jg-dashboard--render)
    (should (string-match-p "水果和粥" (buffer-string)))
    (should (string-match-p "Crème brûlée" (buffer-string)))
    (save-excursion
      (goto-char jg-dashboard-panels--start)
      (dotimes (_ jg-dashboard-panels--height)
        (should (= 120 (string-width (buffer-substring (line-beginning-position) (line-end-position)))))
        (forward-line 1)))))

(ert-deftest jg-dashboard-panel-test-reset-restores-auto-layout ()
  (jg-dashboard-panel-test--wide
    (jg-dashboard-panels-move 'weather 20 18)
    (call-interactively #'jg-dashboard-panels-reset)
    (should-not jg-dashboard-panel-layout)
    (should (equal (cl-subseq (jg-dashboard-panel-test--rectangle 'weather) 0 2) '(0 0)))
    (should (equal (cl-subseq (jg-dashboard-panel-test--rectangle 'quote) 0 2) '(64 0)))))

(ert-deftest jg-dashboard-panel-test-saving-reset-keeps-automatic-reflow ()
  (jg-dashboard-panel-test--wide
    (jg-dashboard-panels-move 'weather 8 16)
    (jg-dashboard-panels-reset)
    (let ((init-file-user user-login-name) saved)
      (cl-letf (((symbol-function 'customize-save-variable)
                 (lambda (variable value &rest _) (setq saved (list variable value)))))
        (jg-dashboard-panels-save))
      (should (equal saved '(jg-dashboard-panel-layout nil))))))

(ert-deftest jg-dashboard-panel-test-save-layout-and-reopen ()
  (jg-dashboard-panel-test--wide
    (let* ((custom-file (make-temp-file "dashboard-layout-"))
           (user-init-file custom-file)
           (init-file-user user-login-name)
           (old-default (default-value 'jg-dashboard-panel-layout)))
      (unwind-protect
          (progn
            (jg-dashboard-panels-move 'weather 8 16)
            (call-interactively #'jg-dashboard-panels-save)
            (with-temp-buffer
              (insert-file-contents custom-file)
              (should (search-forward "jg-dashboard-panel-layout" nil t)))
            (kill-buffer (current-buffer))
            (load custom-file nil t)
            (with-current-buffer (jg-dashboard-buffer)
              (should (equal (cl-subseq (jg-dashboard-panel-test--rectangle 'weather) 0 2) '(8 16)))))
        (set-default 'jg-dashboard-panel-layout old-default)
        (delete-file custom-file)))))

(ert-deftest jg-dashboard-panel-test-animations-stay-inside-the-moved-panel ()
  (jg-dashboard-panel-test--wide
    (jg-dashboard-toggle-snow)
    (jg-dashboard-panels-move 'effects 8 20)
    (let ((rectangle (jg-dashboard-panel-test--rectangle 'effects)))
      (should (equal (cl-subseq rectangle 0 2) '(8 20)))
      (should (= 84 jg-dashboard--effect-width))
      (save-window-excursion
        (switch-to-buffer (current-buffer))
        (jg-dashboard--sync-effect)
        (let ((text (buffer-string)))
          (jg-dashboard--effect-tick (current-buffer))
          (should (equal text (buffer-string)))
          (dolist (overlay jg-dashboard--effect-overlays)
            (should (= 84 (- (overlay-end overlay) (overlay-start overlay))))
            (should (= 84 (string-width (overlay-get overlay 'display)))))))
      (jg-dashboard-toggle-snow)
      (should-not (jg-dashboard-panels-content 'effects))
      (jg-dashboard-toggle-snow)
      (should (equal rectangle (jg-dashboard-panel-test--rectangle 'effects))))))

(defun jg-dashboard-panel-test--point (x y)
  "Return the buffer point at canvas column X and row Y."
  (save-excursion
    (goto-char jg-dashboard-panels--start)
    (forward-line y)
    (move-to-column x)
    (point)))

(ert-deftest jg-dashboard-panel-test-drag-command-snaps-release-event ()
  (jg-dashboard-panel-test--wide
    (save-window-excursion
      (switch-to-buffer (current-buffer))
      (let* ((window (selected-window))
             (start (list window (jg-dashboard-panel-test--point 5 0) '(50 . 50) 0))
             (end (list window (jg-dashboard-panel-test--point 16 3) '(160 . 90) 0))
             (events (list (list 'mouse-movement end) (list 'drag-mouse-1 start end))))
        (cl-letf (((symbol-function 'read-event) (lambda (&rest _) (pop events))))
          (jg-dashboard-panels-drag (list 'down-mouse-1 start)))
        (should (equal (cl-subseq (jg-dashboard-panel-test--rectangle 'weather) 0 2) '(12 4)))
        (should-not jg-dashboard-panels-dragging)
        (should-not jobs)))))

(ert-deftest jg-dashboard-panel-test-cancelled-and-outside-drags-do-not-move ()
  (jg-dashboard-panel-test--wide
    (save-window-excursion
      (switch-to-buffer (current-buffer))
      (let* ((window (selected-window))
             (start (list window (jg-dashboard-panel-test--point 5 0) '(50 . 50) 0))
             (outside (list window (point-min) '(0 . 0) 0)))
        (dolist (next (list 'escape (list 'mouse-1 outside)))
          (cl-letf (((symbol-function 'read-event) (lambda (&rest _) next)))
            (jg-dashboard-panels-drag (list 'down-mouse-1 start)))
          (should (equal (cl-subseq (jg-dashboard-panel-test--rectangle 'weather) 0 2) '(0 0)))
          (should-not jg-dashboard-panels-dragging))))))

(ert-deftest jg-dashboard-panel-test-drag-from-body-does-not-move-panel ()
  (jg-dashboard-panel-test--wide
    (save-window-excursion
      (switch-to-buffer (current-buffer))
      (let ((start (list (selected-window) (cadr (jg-dashboard-panels-content 'weather)) '(0 . 0) 0)))
        (jg-dashboard-panels-drag (list 'down-mouse-1 start))
        (should (equal (cl-subseq (jg-dashboard-panel-test--rectangle 'weather) 0 2) '(0 0)))))))

(ert-deftest jg-dashboard-panel-test-grid-can-be-customized ()
  (jg-dashboard-panel-test--wide
    (setq jg-dashboard-panel-grid '(8 . 3))
    (jg-dashboard-panels-move 'weather 13 4)
    (should (equal (cl-subseq (jg-dashboard-panel-test--rectangle 'weather) 0 2) '(16 3)))
    (jg-dashboard-panel-test--nonoverlapping)))

(ert-deftest jg-dashboard-panel-test-title-click-focuses-without-changing-layout ()
  (jg-dashboard-panel-test--wide
    (save-window-excursion
      (switch-to-buffer (current-buffer))
      (let ((start (list (selected-window) (jg-dashboard-panel-test--point 5 0) '(50 . 50) 0)))
        (cl-letf (((symbol-function 'read-event) (lambda (&rest _) (list 'mouse-1 start))))
          (jg-dashboard-panels-drag (list 'down-mouse-1 start)))
        (should-not jg-dashboard-panel-layout)
        (should (eq (get-text-property (point) 'jg-dashboard-panel) 'weather))))))

(ert-deftest jg-dashboard-panel-test-quit-during-drag-cleans-up-and-keeps-layout ()
  (jg-dashboard-panel-test--wide
    (save-window-excursion
      (switch-to-buffer (current-buffer))
      (let ((start (list (selected-window) (jg-dashboard-panel-test--point 5 0) '(50 . 50) 0))
            cancelled)
        (cl-letf (((symbol-function 'read-event) (lambda (&rest _) (signal 'quit nil))))
          (condition-case nil
              (jg-dashboard-panels-drag (list 'down-mouse-1 start))
            (quit (setq cancelled t))))
        (should cancelled)
        (should-not jg-dashboard-panels-dragging)
        (should-not jg-dashboard-panel-layout)
        (should (equal (cl-subseq (jg-dashboard-panel-test--rectangle 'weather) 0 2) '(0 0)))))))

(ert-deftest jg-dashboard-panel-test-weather-update-during-drag-defers-redraw ()
  (jg-dashboard-panel-test--wide
    (setq jg-dashboard-weather-location "Test")
    (jg-dashboard-refresh)
    (let ((text (buffer-string)))
      (setq jg-dashboard-panels-dragging t)
      (unwind-protect
          (progn
            (jg-dashboard-test--respond (car jobs))
            (should (equal text (buffer-string))))
        (setq jg-dashboard-panels-dragging nil))
      (jg-dashboard--render)
      (should (string-match-p "18°C" (buffer-string))))))

(ert-deftest jg-dashboard-panel-test-save-under-q-does-not-falsely-claim-persistence ()
  (jg-dashboard-panel-test--wide
    (let ((init-file-user nil))
      (should-error (jg-dashboard-panels-save) :type 'user-error))))

(defun jg-dashboard-panel-test--screen-pixel (point window)
  "Return the root-window pixel coordinates for POINT in WINDOW."
  (let* ((position (posn-at-point point window))
         (xy (posn-x-y position))
         (edges (window-inside-pixel-edges window))
         (frame (frame-position (window-frame window)))
         (geometry (frame-geometry (window-frame window)))
         (menu (if (alist-get 'menu-bar-external geometry)
                   (cdr (alist-get 'menu-bar-size geometry)) 0))
         (toolbar (if (and (alist-get 'tool-bar-external geometry)
                           (eq (alist-get 'tool-bar-position geometry) 'top))
                      (cdr (alist-get 'tool-bar-size geometry)) 0)))
    (list (+ (car frame) (nth 0 edges) (car xy) 2)
          (+ (cdr frame) menu toolbar (nth 1 edges) (cdr xy) 2))))

(ert-deftest jg-dashboard-panel-test-table-columns-align-in-real-pixels ()
  (skip-unless (display-graphic-p))
  (jg-dashboard-test--with-dashboard
    (save-window-excursion
      (switch-to-buffer (jg-dashboard-buffer))
      (goto-char (cadr (jg-dashboard-panels-content 'menu)))
      (search-forward "To be confirmed")
      (let ((first (- (point) 15)))
        (search-forward "To be confirmed")
        (search-forward "To be confirmed")
        (let ((second (- (point) 15)))
          (redisplay t)
          (should (= (car (posn-x-y (posn-at-point first)))
                     (car (posn-x-y (posn-at-point second))))))))))

(ert-deftest jg-dashboard-panel-test-real-x11-mouse-drag ()
  ;; Never inject mouse events into a user's ordinary graphical Emacs session.
  (skip-unless (equal (getenv "JG_DASHBOARD_TEST_X11") "1"))
  (skip-unless (display-graphic-p))
  (skip-unless (executable-find "python3"))
  (jg-dashboard-test--with-dashboard
    (let ((noninteractive nil)
          (script (expand-file-name "send-panel-drag.py"
                                    (file-name-directory
                                     (symbol-file 'jg-dashboard-panel-test--rectangle 'defun)))))
      (save-window-excursion
        ;; Leave room for the requested drop, independent of the X font's width.
        (set-frame-width (selected-frame) 124)
        (switch-to-buffer (jg-dashboard-buffer))
        (sit-for 0.05)
        (redisplay t)
        (let* ((window (selected-window))
               (point (jg-dashboard-panel-test--point 5 0))
               (source (jg-dashboard-panel-test--screen-pixel point window))
               (target (jg-dashboard-panel-test--screen-pixel
                        (jg-dashboard-panel-test--point 16 3) window))
               (process (apply #'start-process "dashboard-mouse-drag" nil "python3" script
                               (mapcar #'number-to-string (append source target)))))
          (unwind-protect
              (let ((deadline (+ (float-time) 2)) event)
                (while (and (< (float-time) deadline)
                            (not (and (consp event) (eq (car event) 'down-mouse-1))))
                  (setq event (read-event nil nil 0.2)))
                (should (eq (car-safe event) 'down-mouse-1))
                (should (get-text-property (posn-point (event-start event)) 'jg-dashboard-panel-header))
                ;; Dispatch the real X11 event through the rendered title's binding.
                (funcall (lookup-key (get-text-property point 'keymap) [down-mouse-1]) event)
                (jg-dashboard-test--wait-for (lambda () (not (process-live-p process))))
                (should (= 0 (process-exit-status process)))
                (should (equal (cl-subseq (jg-dashboard-panel-test--rectangle 'weather) 0 2) '(12 4))))
            (when (process-live-p process) (delete-process process))))))))

;;; jg-dashboard-panel-tests.el ends here
