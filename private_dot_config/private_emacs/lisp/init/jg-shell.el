;;; jg-shell.el --- Shell, terminal, navigation -*- lexical-binding: t; -*-

(use-package dired
  :config (setopt dired-listing-switches "-alh"))

(use-package docker :ensure :pin melpa-stable)

(use-package eat
  :ensure :config (setopt eat-term-name "linux"))

(use-package eshell
  :config (setopt eshell-scroll-show-maximum-output nil))

(use-package outshine
  :ensure :pin melpa-stable :hook prog-mode
  :bind (:map outshine-mode-map
	      ("C-c '" . outorg-edit-as-org)
	      ("C-x n s" . outshine-narrow-to-subtree)))

(use-package outorg
  :ensure :pin melpa-stable
  :bind (:map outorg-edit-minor-mode-map
	      ("C-c C-c" . outorg-copy-edits-and-exit)
 	      ("C-c C-k" . (lambda () (interactive)
			     "Exit in my preferred style."
			     (progn (kill-buffer) (delete-window))))))

(use-package which-key
  :config
  (setopt which-key-idle-delay 0.5)
  (setopt which-key-mode t))

(use-package zoxide
  :ensure :pin melpa-stable
  :bind (("C-c z a" . zoxide-add)
         ("C-c z c" . zoxide-cd)
         ("C-c z r" . zoxide-remove)
         ("C-c z f" . zoxide-find-file)
         ("C-c z z" . zoxide-travel)))

(use-package substitute
  :ensure
  :bind-keymap ("C-c s" . substitute-prefix-map))

(use-package transient :ensure :pin gnu)

(use-package vterm
  :ensure
  :bind (:map vterm-mode-map
	      ("C-l" . vterm-clear))
  :config
  (add-to-list 'vterm-eval-cmds '("update-pwd" (lambda (path) (setq default-directory path))))
  (add-to-list 'vterm-eval-cmds '("dired" dired)))

(use-package ghostel
  :ensure :pin melpa-stable
  :config
  (add-to-list 'ghostel-eval-cmds '("update-pwd" (lambda (path) (setq default-directory path)))))

(provide 'jg-shell)
;;; jg-shell.el ends here
