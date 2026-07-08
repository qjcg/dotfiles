;;; jg-programming.el --- Programming config -*- lexical-binding: t; -*-

(use-package magit :ensure :pin nongnu)
(use-package magit-section :ensure :pin melpa-stable)
(use-package with-editor :ensure :pin melpa-stable)
(use-package d2-mode :ensure :pin melpa-stable)

(use-package cue-mode
  :ensure :pin melpa-stable
  :config
  (setopt cue-eval-command '("cue" "eval" "-c")))

(use-package go-mode :ensure :pin melpa-stable)
(use-package gotest :ensure :pin melpa-stable)

(use-package treesit
  :config
  (setq treesit-extra-load-path `(,(expand-file-name "var/tree-sitter" user-emacs-directory)))
  (setq treesit-language-source-alist
	'((bash "https://github.com/tree-sitter/tree-sitter-bash")
	  (cmake "https://github.com/uyha/tree-sitter-cmake")
	  (css "https://github.com/tree-sitter/tree-sitter-css")
	  (dockerfile "https://github.com/camdencheek/tree-sitter-dockerfile")
	  (elisp "https://github.com/Wilfred/tree-sitter-elisp")
	  (go "https://github.com/tree-sitter/tree-sitter-go")
	  (gomod "https://github.com/camdencheek/tree-sitter-go-mod")
	  (html "https://github.com/tree-sitter/tree-sitter-html")
	  (javascript "https://github.com/tree-sitter/tree-sitter-javascript" "master" "src")
	  (json "https://github.com/tree-sitter/tree-sitter-json")
	  (ledger "https://github.com/cbarrete/tree-sitter-ledger")
	  (make "https://github.com/alemuller/tree-sitter-make")
	  (markdown "https://github.com/ikatyang/tree-sitter-markdown")
	  (python "https://github.com/tree-sitter/tree-sitter-python")
	  (toml "https://github.com/tree-sitter/tree-sitter-toml")
	  (tsx "https://github.com/tree-sitter/tree-sitter-typescript" "master" "tsx/src")
	  (typescript "https://github.com/tree-sitter/tree-sitter-typescript" "master" "typescript/src")
	  (typst "https://github.com/uben0/tree-sitter-typst")
	  (yaml "https://github.com/ikatyang/tree-sitter-yaml")))
  (defun jg-treesit-install-all-language-grammars (install-dir)
    "Install all tree-sitter language grammars in treesit-language-source-alist."
    (interactive
     (list (read-string "Install dir? "
			(expand-file-name "var/tree-sitter" user-emacs-directory))))
    (dolist (lang (mapcar #'car treesit-language-source-alist))
      (treesit-install-language-grammar lang install-dir))))

(use-package dockerfile-ts-mode
  :mode (("Dockerfile\\'" . dockerfile-ts-mode)
         ("Dockerfile\\..*\\'" . dockerfile-ts-mode)
         ("\\.dockerfile\\'" . dockerfile-ts-mode))
  :hook
  (dockerfile-ts-mode . (lambda () (setq-local tab-width 2)))
  :config
  (when (fboundp #'treesit-available-p)
    (when (and (fboundp #'treesit-ready-p) (treesit-ready-p 'dockerfile))
      (add-to-list 'major-mode-remap-alist '(dockerfile-mode . dockerfile-ts-mode)))))

(use-package eglot
  :hook ((go-mode go-ts-mode) . eglot-ensure)
  :config
  (add-to-list 'eglot-server-programs '(cue-mode . ("cue" "lsp"))))

(use-package flymake
  :ensure :pin gnu
  :bind (("M-n" . flymake-goto-next-error)
         ("M-p" . flymake-goto-prev-error)))

(use-package flymake-golangci
  :ensure
  :hook ((eglot-managed-mode . (lambda ()
                                 (when (derived-mode-p '(go-mode go-ts-mode))
                                   (flymake-golangci-load))))
         (go-mode . flymake-golangci-load)
	 (go-ts-mode . flymake-golangci-load)))

(use-package editorconfig
  :ensure :pin melpa-stable
  :config (setopt editorconfig-mode t))

(use-package yaml-ts-mode :mode "\\.ya?ml\\'")
(use-package earthfile-mode)
(use-package systemd :ensure :pin nongnu)
(use-package templ-ts-mode :ensure :pin melpa-stable)
(use-package zig-mode :ensure :pin nongnu)
(use-package kdl-mode :ensure)
(use-package buttercup :ensure :pin nongnu)
(use-package bats-mode :ensure)
(use-package drakon-mode)
(use-package gherkin-mode)
(use-package txtar-mode)
(use-package utils :after buttercup)

(provide 'jg-programming)
;;; jg-programming.el ends here
