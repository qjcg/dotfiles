;;; jg-emacs.el --- Core Emacs config -*- lexical-binding: t; -*-

(use-package emacs
  :demand
  :init
  (setenv "LC_COLLATE" "C")
  (add-to-list 'load-path (expand-file-name "lisp" user-emacs-directory))
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

(use-package esup :ensure :pin melpa-stable)
(use-package with-editor :ensure :pin melpa-stable)
(use-package gherkin-mode)
(use-package txtar-mode)
(use-package utils :after buttercup)

(provide 'jg-emacs)
;;; jg-emacs.el ends here
