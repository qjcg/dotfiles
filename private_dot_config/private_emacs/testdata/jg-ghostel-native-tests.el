;;; jg-ghostel-native-tests.el --- Native terminal integration -*- lexical-binding: t; -*-

;; These tests require the installed Ghostel native module and a graphical
;; frame.  `task test-ghostel-gui' runs them on an isolated Xvfb display.

(require 'ert)
(require 'jg-ghostel)

(defconst jg-ghostel-native--shell-modules-dir
  (expand-file-name "../../../dot_bash_profile.d/"
                    (file-name-directory load-file-name)))

(defun jg-ghostel-native--wait-for (buffer predicate)
  "Wait for PREDICATE while processing native output in BUFFER."
  (let ((deadline (+ (float-time) 5)))
    (while (and (< (float-time) deadline) (not (funcall predicate)))
      (accept-process-output nil 0.05)
      (with-current-buffer buffer (ghostel-force-redraw)))
    (ert-info ((format "Native terminal output:\n%s"
                       (with-current-buffer buffer
                         (buffer-substring-no-properties (point-min) (point-max)))))
      (should (funcall predicate)))))

(ert-deftest jg-ghostel-native-shell-survives-hide-expand-and-switch ()
  (skip-unless (display-graphic-p))
  (let ((ghostel-shell "/bin/sh")
        (ghostel-query-before-killing nil)
        (buffers nil)
        (original-view (frame-parameter nil 'jg-ghostel-view)))
    (unwind-protect
        (save-window-excursion
          (delete-other-windows)
          (set-frame-parameter nil 'jg-ghostel-view nil)
          (jg-ghostel-global-new)
          (push (current-buffer) buffers)
          (let* ((first (current-buffer))
                 (process (get-buffer-process first)))
            (should (process-live-p process))
            (ghostel-send-string "printf '\\nJG_GHOSTEL_SMOKE_OK\\n'\n")
            (let ((deadline (+ (float-time) 5)))
              (while (and (< (float-time) deadline)
                          (not (string-match-p
                                "^JG_GHOSTEL_SMOKE_OK[ \t]*$"
                                (buffer-substring-no-properties
                                 (point-min) (point-max)))))
                (accept-process-output nil 0.05)
                (ghostel-force-redraw)))
            (should (string-match-p "^JG_GHOSTEL_SMOKE_OK[ \t]*$"
                                    (buffer-substring-no-properties
                                     (point-min) (point-max))))
            (jg-ghostel-global)
            (should (process-live-p process))
            (jg-ghostel-global)
            (should (eq (current-buffer) first))
            (jg-ghostel-toggle-size)
            (should (= (length (window-list)) 1))
            (dotimes (_ 3)
              (jg-ghostel-global)
              (should (process-live-p process))
              (jg-ghostel-global)
              (should (eq (current-buffer) first))
              (should (eq (get-buffer-process first) process))
              (should (= (length (window-list)) 1)))
            (jg-ghostel-global-new)
            (push (current-buffer) buffers)
            (should (process-live-p (get-buffer-process (current-buffer))))
            (should (eq (window-parameter (selected-window) 'window-side) 'top))
            (should (= (length (window-list)) 2))
            (jg-ghostel-previous)
            (should (eq (current-buffer) first))
            (should (= (length (window-list)) 1))
            (should (eq (get-buffer-process first) process))
            (jg-ghostel-next)
            (should (eq (window-parameter (selected-window) 'window-side) 'top))
            (jg-ghostel-previous)
            (should (eq (current-buffer) first))
            (should (= (length (window-list)) 1))
            (jg-ghostel-toggle-size)
            (should (eq (window-parameter (selected-window) 'window-side) 'top))
            (jg-ghostel-global)
            (jg-ghostel-global)
            (should (eq (current-buffer) first))
            (should (eq (window-parameter (selected-window) 'window-side) 'top))
            (should (process-live-p process))))
      (set-frame-parameter nil 'jg-ghostel-view nil)
      (dolist (buffer buffers)
        (when (buffer-live-p buffer) (kill-buffer buffer)))
      (set-frame-parameter nil 'jg-ghostel-view original-view))))

(ert-deftest jg-ghostel-native-all-input-modes-retain-terminal-controls ()
  (skip-unless (display-graphic-p))
  (let ((ghostel-shell "/bin/sh")
        (ghostel-query-before-killing nil)
        (terminal nil)
        (original-view (frame-parameter nil 'jg-ghostel-view)))
    (unwind-protect
        (save-window-excursion
          (delete-other-windows)
          (set-frame-parameter nil 'jg-ghostel-view nil)
          (jg-ghostel-global-new)
          (setq terminal (current-buffer))
          (let ((deadline (+ (float-time) 5)))
            (while (and (< (float-time) deadline)
                        (not (ghostel-input-start-point)))
              (accept-process-output nil 0.05)
              (ghostel-force-redraw)))
          (should (ghostel-input-start-point))
          (dolist (mode '(ghostel-semi-char-mode ghostel-char-mode
                         ghostel-copy-mode ghostel-emacs-mode ghostel-line-mode))
            ;; Force line mode even before the shell has reported a prompt.
            (if (eq mode 'ghostel-line-mode) (ghostel-line-mode t)
              (funcall mode))
            (should (eq (key-binding (kbd "C-`")) #'jg-ghostel-toggle))
            (should (eq (key-binding (kbd "C-c t n")) #'jg-ghostel-new))
            (should (eq (key-binding (kbd "C-c t N")) #'jg-ghostel-new-fullscreen))
            (should (eq (key-binding (kbd "C-c t t")) #'jg-ghostel-switch-all))
            (should-not (key-binding (kbd "C-c t B")))
            (should (eq (key-binding (kbd "C-c t f")) #'jg-ghostel-toggle-size))
            (call-interactively (key-binding (kbd "C-`")))
            (should (= (length (window-list)) 1))
            (jg-ghostel-global)
            (should (eq (current-buffer) terminal))))
      (set-frame-parameter nil 'jg-ghostel-view nil)
      (when (buffer-live-p terminal) (kill-buffer terminal))
      (set-frame-parameter nil 'jg-ghostel-view original-view))))

(ert-deftest jg-ghostel-native-new-fullscreen-is-sized-before-spawning ()
  (skip-unless (display-graphic-p))
  (let ((ghostel-shell "/bin/sh")
        (ghostel-query-before-killing nil)
        (buffers nil)
        (spawn-observed nil)
        (original-view (frame-parameter nil 'jg-ghostel-view)))
    (unwind-protect
        (save-window-excursion
          (delete-other-windows)
          (set-frame-parameter nil 'jg-ghostel-view nil)
          (jg-ghostel-global-new)
          (push (current-buffer) buffers)
          (let ((ghostel-pre-spawn-hook
                 (list (lambda ()
                         (setq spawn-observed t)
                         (should (= (length (window-list)) 1))
                         (should-not (window-parameter (selected-window)
                                                       'window-side))))))
            (call-interactively (key-binding (kbd "C-c t N"))))
          (push (current-buffer) buffers)
          (let* ((terminal (current-buffer))
                 (process (get-buffer-process terminal)))
            (should spawn-observed)
            (should (process-live-p process))
            (should (equal (alist-get 'name ghostel-identity) "*ghostel: global*"))
            (jg-ghostel-global)
            (jg-ghostel-global)
            (should (eq (current-buffer) terminal))
            (should (= (length (window-list)) 1))
            (should (eq (get-buffer-process terminal) process))
            (jg-ghostel-previous)
            (should (eq (window-parameter (selected-window) 'window-side) 'top))
            (jg-ghostel-next)
            (should (eq (current-buffer) terminal))
            (should (= (length (window-list)) 1))))
      (set-frame-parameter nil 'jg-ghostel-view nil)
      (dolist (buffer buffers)
        (when (buffer-live-p buffer) (kill-buffer buffer)))
      (set-frame-parameter nil 'jg-ghostel-view original-view))))

(ert-deftest jg-ghostel-native-shell-aliases-survive-bash-restart ()
  (skip-unless (display-graphic-p))
  (let* ((home (make-temp-file "jg-ghostel-shell-" t))
         (default-directory (file-name-as-directory home))
         (ghostel-shell '("/bin/bash" "--noprofile" "-i"))
         (ghostel-shell-integration t)
         (ghostel-environment (list (concat "HOME=" home) "HISTFILE=/dev/null"))
         (ghostel-query-before-killing nil)
         (terminal nil)
         (process nil)
         (file (expand-file-name "file with 'quotes' \"double\" \\name" home))
         (directory (expand-file-name "directory with 'quotes'" home))
         (original-view (frame-parameter nil 'jg-ghostel-view)))
    (unwind-protect
        (save-window-excursion
          (with-temp-file (expand-file-name ".bashrc" home)
            (insert "PS1='JG_BRIDGE> '\n")
            (dolist (module '("99-emacs-ghostel.sh" "99-emacs-vterm.sh"))
              (insert "source " (shell-quote-argument
                                  (expand-file-name module
                                                    jg-ghostel-native--shell-modules-dir))
                      "\n")))
          (with-temp-file file (insert "Shell bridge fixture.\n"))
          (make-directory directory)
          (delete-other-windows)
          (set-frame-parameter nil 'jg-ghostel-view nil)
          (jg-ghostel-global-new)
          (setq terminal (current-buffer)
                process (get-buffer-process terminal))
          ;; The initial shell receives the upstream auto-injection.
          (ghostel-send-string (concat "f " (shell-quote-argument file) "\n"))
          (jg-ghostel-native--wait-for terminal (lambda () (get-file-buffer file)))
          (kill-buffer (get-file-buffer file))
          ;; exec inherits the resource path, but not Bash functions or the
          ;; one-shot injection environment.  Exercise real OSC -> Emacs calls.
          (with-current-buffer terminal
            (ghostel-send-string "exec /bin/bash --noprofile -i\n")
            (ghostel-send-string (concat "f " (shell-quote-argument file) "\n")))
          (jg-ghostel-native--wait-for terminal (lambda () (get-file-buffer file)))
          (with-current-buffer terminal
            (ghostel-send-string (concat "d " (shell-quote-argument directory) "\n")))
          (jg-ghostel-native--wait-for
           terminal
           (lambda ()
             (seq-find (lambda (buffer)
                         (with-current-buffer buffer
                           (and (derived-mode-p 'dired-mode)
                                (equal default-directory
                                       (file-name-as-directory directory)))))
                       (buffer-list))))
          (should (process-live-p (get-buffer-process terminal))))
      (set-frame-parameter nil 'jg-ghostel-view nil)
      (when (buffer-live-p terminal) (kill-buffer terminal))
      (let ((deadline (+ (float-time) 5)))
        (while (and (process-live-p process) (< (float-time) deadline))
          (accept-process-output nil 0.05)))
      (dolist (buffer (buffer-list))
        (with-current-buffer buffer
          (when (or (equal buffer-file-name file)
                    (equal default-directory (file-name-as-directory directory)))
            (kill-buffer buffer))))
      (set-frame-parameter nil 'jg-ghostel-view original-view)
      (delete-directory home t))))

(provide 'jg-ghostel-native-tests)
;;; jg-ghostel-native-tests.el ends here
