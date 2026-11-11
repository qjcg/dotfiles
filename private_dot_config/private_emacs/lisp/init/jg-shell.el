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

(use-package ghostel
  :ensure :pin melpa-stable :demand t
  :config
  (require 'jg-ghostel)
  (add-to-list 'ghostel-eval-cmds '("update-pwd" (lambda (path) (setq default-directory path)))))

(use-package consult-ghostel
  :ensure
  :pin melpa-stable
  :after (ghostel consult)
  :demand t
  :config (consult-ghostel-mode)
  :bind (("C-x m" . consult-ghostel)
         :map project-prefix-map
         ("m" . consult-ghostel-project)
         :map ghostel-semi-char-mode-map
         ("C-c h" . consult-ghostel-history)))

(provide 'jg-shell)
;;; jg-shell.el ends here
