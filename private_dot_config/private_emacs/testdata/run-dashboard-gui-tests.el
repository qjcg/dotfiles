;;; run-dashboard-gui-tests.el --- Graphical dashboard ERT runner -*- lexical-binding: t; -*-

;; Keep a real GUI frame while giving ERT batch reporting and exit semantics.
(setq noninteractive t
      standard-output #'external-debugging-output)
(add-hook 'kill-emacs-hook
          (lambda ()
            (when-let* ((buffer (get-buffer "*Messages*")))
              (princ (with-current-buffer buffer (buffer-string))
                     #'external-debugging-output))))
(ert-run-tests-batch-and-exit)

;;; run-dashboard-gui-tests.el ends here
