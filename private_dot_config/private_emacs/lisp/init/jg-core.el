;;; jg-core.el --- Core Emacs config -*- lexical-binding: t; -*-

(use-package emacs
  :demand
  :init
  (setenv "LC_COLLATE" "C")

  :config
  (setopt inhibit-splash-screen t)
  (setopt menu-bar-mode nil)
  (setopt scroll-bar-mode nil)
  (setopt tool-bar-mode nil)
  (setopt truncate-lines t)
  (setopt inhibit-startup-echo-area-message user-login-name)
  (setopt recentf-mode t)
  (setopt project-switch-commands '((project-find-file "Find file")
				    (project-find-regexp "Find regexp")
				    (project-find-dir "Find directory")
				    (ghostel-project "Ghostel" ?t)
				    (magit "Magit" ?m)
				    (magit-log-all-branches "Magit Log (all branches)" ?l)
				    (agent-shell-anthropic-start-claude-code "Agent Shell (Claude)" ?c)
				    (project-any-command "Other")))
  (setopt custom-file (expand-file-name "var/custom.el" user-emacs-directory))
  (if (file-exists-p custom-file)
      (load custom-file)))

(use-package no-littering
  :ensure :pin melpa-stable :demand
  :config
  (cl-letf (((symbol-function 'etc) #'no-littering-expand-etc-file-name)
	    ((symbol-function 'var) #'no-littering-expand-var-file-name))
    (setopt custom-theme-directory (etc "themes"))
    (setopt emms-source-file-default-directory (etc "emms/"))
    (setq rmh-elfeed-org-files (list (etc "elfeed/rmh-elfeed.org")))
    (setq tempel-path (list (etc "tempel/templates.el")))
    (setopt backup-directory-alist `(("." . ,(var "backups"))))
    (setq elfeed-score-rule-stats-file (var "elfeed/score/stats.el"))))

(use-package age
  :ensure :pin melpa-stable :demand t
  :config
  (setopt age-default-identity "~/.config/chezmoi/id.txt")
  (setopt age-default-recipient '("age1zyudjx9v6z07k5d76s3zw2576fcme3nhq2wtvurlxnvznwht39zqagfa7n"))
  (age-file-enable))

(use-package time
  :config
  (setopt display-time-mode t)
  (setopt display-time-format "%a %b %-e %-l:%M%p %Z")
  (setopt world-clock-time-format "%A %B %e %l:%M %p %Z")
  (setopt world-clock-list '(("America/Vancouver" "Vancouver")
			     ("America/Chicago" "Chicago")
			     ("America/Montreal" "Montreal")
			     ("Europe/London" "London")
			     ("Asia/Singapore" "Singapore"))))

(use-package alert
  :ensure :pin melpa-stable
  :init (setq alert-default-style 'notifications)
  :commands (alert))

(use-package esup :ensure :pin melpa-stable)

(provide 'jg-core)
;;; jg-core.el ends here
