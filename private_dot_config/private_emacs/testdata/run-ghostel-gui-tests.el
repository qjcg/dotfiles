;;; run-ghostel-gui-tests.el --- Report graphical ERT results -*- lexical-binding: t; -*-

;; Initialize a real graphical frame first, then enable ERT's batch reporting
;; and exit semantics without launching Emacs itself in headless batch mode.
(setq noninteractive t)
(setq standard-output #'external-debugging-output)
(add-hook 'kill-emacs-hook
          (lambda ()
            (when-let* ((buffer (get-buffer "*Messages*")))
              (princ (with-current-buffer buffer (buffer-string))
                     #'external-debugging-output))))
(ert-run-tests-batch-and-exit)

;;; run-ghostel-gui-tests.el ends here
