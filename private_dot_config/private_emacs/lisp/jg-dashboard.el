;;; jg-dashboard.el --- A personal daily dashboard -*- lexical-binding: t; -*-

;;; Commentary:
;; A dependency-free home buffer: weekly meals, today's weather, a daily quote.
;; See `jg-dashboard-menu-function' for the future menu data-source contract.
;; Weather is opt-in: configuring a location sends it to https://wttr.in.
;; Network requests are asynchronous, bounded, and cached for this session.

;;; Code:

(require 'button)
(require 'calendar)
(require 'cl-lib)
(require 'json)
(require 'subr-x)
(require 'url)
(require 'url-http)

;; url-http creates these buffer-local variables dynamically in responses.
(defvar url-http-response-status)
(defvar url-http-end-of-headers)

(defgroup jg-dashboard nil
  "A personal daily dashboard."
  :group 'applications)

(defcustom jg-dashboard-menu-function #'jg-dashboard-placeholder-menu
  "Function returning meals for the week beginning on its ISO-date argument.
The argument is a Monday, for example \"2026-11-02\".  Return an alist of
ISO dates to plists with :breakfast and :lunch strings, for example:
  ((\"2026-11-02\" . (:breakfast \"Porridge\" :lunch \"Soup\")))
Missing meals display as \"To be confirmed\".  The function runs locally
on refresh; use a local cache if your eventual source needs network I/O."
  :type 'function)

(defcustom jg-dashboard-weather-location nil
  "Location sent to wttr.in, such as \"Paris,France\" or \"51.50,-0.12\".
Nil or an empty string disables weather requests.  No location is inferred.
Setting this opts into sending the location and your IP address to wttr.in."
  :type '(choice (const :tag "Not configured" nil) string))

(defcustom jg-dashboard-weather-units 'celsius
  "Temperature units shown on the dashboard."
  :type '(choice (const celsius) (const fahrenheit)))

(defcustom jg-dashboard-weather-cache-seconds 1800
  "Seconds before cached weather is refreshed when the dashboard is visible."
  :type 'natnum)

(defcustom jg-dashboard-weather-timeout 10
  "Maximum seconds to wait for a weather request."
  :type 'number)

(defcustom jg-dashboard-quotes
  '(("Nothing great was ever achieved without enthusiasm." . "Ralph Waldo Emerson")
    ("If there is no struggle, there is no progress." . "Frederick Douglass")
    ("Nothing in life is to be feared, it is only to be understood." . "Marie Curie"))
  "Local (QUOTE . AUTHOR) pairs, rotated deterministically each day.
No quote service is contacted.  Add your own quotes here."
  :type '(repeat (cons (string :tag "Quote") (string :tag "Author"))))

(defface jg-dashboard-title
  '((t :inherit font-lock-keyword-face :weight bold :height 1.5))
  "Face for the dashboard title.")

(defface jg-dashboard-heading
  '((t :inherit font-lock-function-name-face :weight bold))
  "Face for dashboard section headings.")

(defface jg-dashboard-today
  '((t :inherit success :weight bold))
  "Face marking today in the weekly menu.")

(defconst jg-dashboard--buffer-name "*Dashboard*")
(defvar jg-dashboard--timer nil)
(defvar jg-dashboard--weather-cache nil
  "Plist containing :key, :time, and normalized :data for the last success.")
(defvar jg-dashboard--weather-error nil
  "Cons of the request key and the last error message.")
(defvar jg-dashboard--weather-request nil)
(cl-defstruct (jg-dashboard--request (:constructor jg-dashboard--make-request))
  key buffer timer)

(defun jg-dashboard--today ()
  "Return today's local Gregorian date."
  (calendar-current-date))

(defun jg-dashboard--iso-date (date)
  "Return Gregorian DATE as an ISO date."
  (format "%04d-%02d-%02d" (nth 2 date) (car date) (cadr date)))

(defun jg-dashboard--date-time (date)
  "Return local noon on Gregorian DATE, avoiding DST midnight transitions."
  (encode-time 0 0 12 (cadr date) (car date) (nth 2 date)))

(defun jg-dashboard--week (date)
  "Return Monday through Sunday Gregorian dates for DATE's week."
  (let ((monday (- (calendar-absolute-from-gregorian date)
                   (mod (1- (calendar-day-of-week date)) 7))))
    (cl-loop for offset below 7
             collect (calendar-gregorian-from-absolute (+ monday offset)))))

(defun jg-dashboard-placeholder-menu (_week-start)
  "Return an empty menu for _WEEK-START, causing every meal to be a placeholder."
  nil)

(defun jg-dashboard--text (value)
  "Normalize VALUE for display without embedded control characters."
  (replace-regexp-in-string "[[:cntrl:]]" " "
                            (substring-no-properties (format "%s" value))))

(defun jg-dashboard--meal (meals kind)
  "Return the meal of KIND from MEALS, or a placeholder."
  (let ((value (plist-get meals kind)))
    (if (and (stringp value) (not (string-empty-p (string-trim value))))
        (jg-dashboard--text value)
      "To be confirmed")))

(defun jg-dashboard--wrap (text width)
  "Return TEXT wrapped into a list of lines of approximately WIDTH columns."
  (with-temp-buffer
    (insert (jg-dashboard--text text))
    (let ((fill-column width))
      (fill-region (point-min) (point-max)))
    (split-string (buffer-string) "\n")))

(defun jg-dashboard--heading (text)
  "Insert a section heading containing TEXT."
  (insert (propertize text 'face 'jg-dashboard-heading) "\n\n"))

(defun jg-dashboard--insert-menu (today width)
  "Insert the week containing TODAY, fitting approximately WIDTH columns."
  (let* ((week (jg-dashboard--week today))
         (start (jg-dashboard--iso-date (car week)))
         (menu (condition-case err
                   (funcall jg-dashboard-menu-function start)
                 (error
                  (insert (propertize
                           (format "Menu unavailable: %s\n\n" (error-message-string err))
                           'face 'warning))
                  nil))))
    (insert (propertize (format "Week of %s\n\n" start) 'face 'shadow))
    (if (>= width 64)
        (let ((column-width (/ (- width 18) 2)))
          (insert (format (format "%%-12s  %%-%ds  %%s\n" column-width)
                          "Day" "Breakfast" "Lunch"))
          (insert (make-string width ?─) "\n")
          (dolist (date week)
            (let* ((meals (alist-get (jg-dashboard--iso-date date) menu nil nil #'equal))
                   (breakfast (jg-dashboard--wrap (jg-dashboard--meal meals :breakfast) column-width))
                   (lunch (jg-dashboard--wrap (jg-dashboard--meal meals :lunch) column-width))
                   (label (format-time-string "%a %d %b" (jg-dashboard--date-time date))))
              (cl-loop for row below (max (length breakfast) (length lunch)) do
                       (insert
                        (if (= row 0)
                            (propertize (format "%-12s" label)
                                        'face (if (equal date today) 'jg-dashboard-today 'default))
                          (make-string 12 ?\s))
                        (format (format "  %%-%ds  %%s\n" column-width)
                                (or (nth row breakfast) "") (or (nth row lunch) "")))))))
      (dolist (date week)
        (let ((meals (alist-get (jg-dashboard--iso-date date) menu nil nil #'equal)))
          (insert (propertize
                   (format-time-string "%A %d %b" (jg-dashboard--date-time date))
                   'face (if (equal date today) 'jg-dashboard-today 'bold)) "\n")
          (dolist (kind '(:breakfast :lunch))
            (let ((label (if (eq kind :breakfast) "Breakfast" "Lunch")))
              (insert "  " label ": "
                      (string-join (jg-dashboard--wrap (jg-dashboard--meal meals kind)
                                                       (- width 13))
                                   (concat "\n" (make-string (+ 4 (length label)) ?\s)))
                      "\n")))
          (insert "\n"))))
    (insert "\n")))

(defun jg-dashboard--weather-key ()
  "Return the current location, units, and date key, or nil if disabled."
  (when (and (stringp jg-dashboard-weather-location)
             (not (string-empty-p (string-trim jg-dashboard-weather-location))))
    (list (string-trim jg-dashboard-weather-location)
          jg-dashboard-weather-units
          (jg-dashboard--iso-date (jg-dashboard--today)))))

(defun jg-dashboard--cached-weather (key)
  "Return cached weather only when its location, units, and date match KEY."
  (when (and key (equal key (plist-get jg-dashboard--weather-cache :key)))
    (plist-get jg-dashboard--weather-cache :data)))

(defun jg-dashboard--insert-weather ()
  "Insert cached weather or a useful setup/loading/error message."
  (let* ((key (jg-dashboard--weather-key))
         (data (jg-dashboard--cached-weather key))
         (error-text (and key (equal key (car jg-dashboard--weather-error))
                          (cdr jg-dashboard--weather-error))))
    (cond
     ((null key)
      (insert "Set jg-dashboard-weather-location to enable local weather.\n"))
     (data
      (insert (format "%s · %s\n" (jg-dashboard--text (car key)) (plist-get data :summary)))
      (insert (format "%s · Feels like %s · Low %s / High %s\n"
                      (plist-get data :temperature) (plist-get data :feels-like)
                      (plist-get data :low) (plist-get data :high)))
      (insert (propertize
               (format "wttr.in · Forecast %s · Updated %s%s\n"
                       (plist-get data :date)
                       (format-time-string "%H:%M" (plist-get jg-dashboard--weather-cache :time))
                       (if jg-dashboard--weather-request " · Refreshing…" ""))
               'face 'shadow)))
     ((and jg-dashboard--weather-request
           (equal key (jg-dashboard--request-key jg-dashboard--weather-request)))
      (insert "Loading weather…\n"))
     ((not error-text) (insert "Weather not loaded yet.  Press g to refresh.\n")))
    (when error-text
      (insert (propertize (concat "Weather unavailable: " error-text
                                  (if data " (showing cached weather)" "") "\n")
                          'face 'warning)))
    (insert "\n")))

(defun jg-dashboard--insert-quote (today width)
  "Insert TODAY's locally selected quote, wrapped to WIDTH columns."
  (if (null jg-dashboard-quotes)
      (insert "Add a favourite to jg-dashboard-quotes.\n\n")
    (let* ((index (mod (calendar-absolute-from-gregorian today) (length jg-dashboard-quotes)))
           (quote (nth index jg-dashboard-quotes)))
      (insert (string-join (jg-dashboard--wrap (concat "“" (car quote) "”") width) "\n")
              "\n" (propertize (concat "— " (jg-dashboard--text (cdr quote))) 'face 'shadow)
              "\n\n"))))

(defun jg-dashboard--render ()
  "Redraw the dashboard without changing the user's selected buffer/window."
  (when-let* ((buffer (get-buffer jg-dashboard--buffer-name)))
    (with-current-buffer buffer
      (let* ((inhibit-read-only t)
             (old-point (point))
             (today (jg-dashboard--today))
             (window (or (get-buffer-window buffer t) (selected-window)))
             (width (max 28 (min 86 (- (window-body-width window) 4)))))
        (erase-buffer)
        (insert (propertize "A little perspective" 'face 'jg-dashboard-title) "\n")
        (insert (propertize (format-time-string "%A, %d %B %Y" (jg-dashboard--date-time today))
                            'face 'shadow) "\n\n")
        (jg-dashboard--heading "Today's weather")
        (jg-dashboard--insert-weather)
        (jg-dashboard--heading "Weekly menu")
        (jg-dashboard--insert-menu today width)
        (jg-dashboard--heading "A thought for today")
        (jg-dashboard--insert-quote today width)
        (dolist (action '(("Refresh" . jg-dashboard-refresh)
                          ("Customize" . jg-dashboard-customize)
                          ("Close" . quit-window)))
          (insert-text-button (car action) 'follow-link t
                              'action (lambda (_button) (call-interactively (cdr action))))
          (insert "   "))
        (insert (propertize "\n\ng refresh · c customize · q close" 'face 'shadow) "\n")
        (goto-char (min old-point (point-max)))
        (set-buffer-modified-p nil)))))

(defun jg-dashboard--parse-weather (key)
  "Parse the current HTTP response buffer into weather for KEY.
Signal an error on HTTP failure, malformed JSON, or missing current data."
  (unless (eq url-http-response-status 200)
    (error "HTTP %s" (or url-http-response-status "response missing")))
  (unless url-http-end-of-headers
    (error "Missing HTTP headers"))
  (goto-char url-http-end-of-headers)
  (let* ((json (json-parse-buffer :object-type 'alist :array-type 'list
                                 :null-object nil :false-object nil))
         (current (car (alist-get 'current_condition json)))
         (forecast (car (alist-get 'weather json)))
         (celsius (eq (nth 1 key) 'celsius))
         (suffix (if celsius "°C" "°F"))
         (temperature (alist-get (if celsius 'temp_C 'temp_F) current))
         (summary (alist-get 'value (car (alist-get 'weatherDesc current)))))
    (unless (and (stringp temperature) (not (string-empty-p temperature))
                 (stringp summary) (not (string-empty-p summary)))
      (error "Missing current weather"))
    (cl-labels ((degrees (value)
                  (if (and (stringp value) (not (string-empty-p value)))
                      (concat (jg-dashboard--text value) suffix)
                    "—")))
      (list :summary (jg-dashboard--text summary)
            :temperature (degrees temperature)
            :feels-like (degrees (alist-get (if celsius 'FeelsLikeC 'FeelsLikeF) current))
            :low (degrees (alist-get (if celsius 'mintempC 'mintempF) forecast))
            :high (degrees (alist-get (if celsius 'maxtempC 'maxtempF) forecast))
            :date (jg-dashboard--text (or (alist-get 'date forecast) "unknown"))))))

(defun jg-dashboard--cancel-request ()
  "Cancel any in-flight weather request and its timeout timer."
  (when-let* ((request jg-dashboard--weather-request))
    ;; Detach before killing: process sentinels can invoke a late callback.
    (setq jg-dashboard--weather-request nil)
    (when (timerp (jg-dashboard--request-timer request))
      (cancel-timer (jg-dashboard--request-timer request)))
    (when-let* ((buffer (jg-dashboard--request-buffer request))
                ((buffer-live-p buffer)))
      (when-let* ((process (get-buffer-process buffer)))
        (delete-process process))
      (kill-buffer buffer))))

(defun jg-dashboard--weather-callback (status request)
  "Handle URL STATUS for REQUEST, ignoring cancelled or superseded requests."
  (unwind-protect
      (when (eq request jg-dashboard--weather-request)
        (let ((key (jg-dashboard--request-key request)))
          (condition-case err
              (progn
                (when (plist-get status :error)
                  (error "Network request failed"))
                (setq jg-dashboard--weather-cache
                      (list :key key :time (current-time) :data (jg-dashboard--parse-weather key))
                      jg-dashboard--weather-error nil))
            (error (setq jg-dashboard--weather-error (cons key (error-message-string err)))))
          (when (timerp (jg-dashboard--request-timer request))
            (cancel-timer (jg-dashboard--request-timer request)))
          (setq jg-dashboard--weather-request nil)
          (jg-dashboard--render)))
    (kill-buffer (current-buffer))))

(defun jg-dashboard--weather-timeout (request)
  "Stop REQUEST if it is still pending, retaining any cached weather."
  (when (eq request jg-dashboard--weather-request)
    (setq jg-dashboard--weather-error
          (cons (jg-dashboard--request-key request) "Request timed out"))
    (jg-dashboard--cancel-request)
    (jg-dashboard--render)))

(defun jg-dashboard--fetch-weather (key)
  "Start one asynchronous weather request for KEY."
  (let ((request (jg-dashboard--make-request :key key))
        (url-request-extra-headers '(("Accept" . "application/json")))
        (url-show-status nil))
    (setq jg-dashboard--weather-request request
          jg-dashboard--weather-error nil)
    (condition-case err
        (let ((buffer (url-retrieve
                       (format "https://wttr.in/%s?format=j1" (url-hexify-string (car key)))
                       #'jg-dashboard--weather-callback (list request) t t)))
          ;; Some URL backends can finish synchronously during url-retrieve.
          (when (eq request jg-dashboard--weather-request)
            (unless (buffer-live-p buffer) (error "Could not start weather request"))
            (setf (jg-dashboard--request-buffer request) buffer
                  (jg-dashboard--request-timer request)
                  (run-at-time jg-dashboard-weather-timeout nil
                               #'jg-dashboard--weather-timeout request))))
      (error
       (jg-dashboard--cancel-request)
       (setq jg-dashboard--weather-error (cons key (error-message-string err)))))))

(defun jg-dashboard-refresh (&optional force)
  "Refresh the menu and quote; request weather if stale.
Interactively, or with FORCE non-nil, bypass the weather cache.  A refresh
never duplicates an in-flight request for the same location, units, and day."
  (interactive (list t))
  (let ((key (jg-dashboard--weather-key)))
    (when (and jg-dashboard--weather-request
               (not (equal key (jg-dashboard--request-key jg-dashboard--weather-request))))
      (jg-dashboard--cancel-request))
    (when (and key (not jg-dashboard--weather-request)
               (or force (not (jg-dashboard--cached-weather key))
                   (>= (float-time (time-subtract (current-time)
                                                 (plist-get jg-dashboard--weather-cache :time)))
                       jg-dashboard-weather-cache-seconds)))
      (jg-dashboard--fetch-weather key)))
  (jg-dashboard--render))

(defun jg-dashboard--tick ()
  "Update dates and stale weather while the dashboard is visible."
  (when (get-buffer-window jg-dashboard--buffer-name t)
    (jg-dashboard-refresh)))

(defun jg-dashboard--cleanup ()
  "Release dashboard timers and network requests on buffer deletion."
  (when (timerp jg-dashboard--timer) (cancel-timer jg-dashboard--timer))
  (setq jg-dashboard--timer nil)
  (jg-dashboard--cancel-request))

(defvar jg-dashboard-mode-map
  (let ((map (make-sparse-keymap)))
    (set-keymap-parent map special-mode-map)
    (define-key map (kbd "g") #'jg-dashboard-refresh)
    (define-key map (kbd "c") #'jg-dashboard-customize)
    (define-key map (kbd "TAB") #'forward-button)
    (define-key map (kbd "<backtab>") #'backward-button)
    map))

(define-derived-mode jg-dashboard-mode special-mode "Dashboard"
  "Read-only daily dashboard.  Press g to refresh, c to configure, q to close."
  (setq-local cursor-type nil
              truncate-lines nil
              display-line-numbers nil)
  (add-hook 'kill-buffer-hook #'jg-dashboard--cleanup nil t)
  (unless (timerp jg-dashboard--timer)
    (setq jg-dashboard--timer (run-at-time 60 60 #'jg-dashboard--tick))))

(defun jg-dashboard-buffer ()
  "Return the populated dashboard buffer, suitable for `initial-buffer-choice'."
  (let ((buffer (get-buffer-create jg-dashboard--buffer-name)))
    (with-current-buffer buffer
      (unless (derived-mode-p 'jg-dashboard-mode) (jg-dashboard-mode)))
    (jg-dashboard-refresh)
    buffer))

(defun jg-dashboard-open ()
  "Show the personal dashboard without deleting other windows."
  (interactive)
  (pop-to-buffer (jg-dashboard-buffer))
  (jg-dashboard--render))

(defun jg-dashboard-customize ()
  "Configure the menu source, weather location and units, or daily quotes."
  (interactive)
  (customize-group 'jg-dashboard))

(provide 'jg-dashboard)
;;; jg-dashboard.el ends here
