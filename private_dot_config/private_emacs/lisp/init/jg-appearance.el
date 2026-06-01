;;; jg-appearance.el --- Appearance & focus -*- lexical-binding: t; -*-

(use-package display-line-numbers-mode
  :hook prog-mode
  :config (setopt display-line-numbers-type t))

(use-package show-font :ensure)

(use-package org-modern
  :ensure :pin gnu
  :config (setopt global-org-modern-mode t))

(use-package fontaine
  :ensure :demand
  :bind (("C-c f f" . fontaine-set-preset))
  :config
  (setopt fontaine-presets
	  '((t
	     :default-family "Monospace"
	     :default-weight regular
	     :default-slant normal
	     :default-width normal
	     :default-height 100
	     :variable-pitch-family "Sans"
	     :variable-pitch-height 1.0
	     :bold-weight bold
	     :italic-slant italic
	     :line-spacing nil)
	    (regular :default-height 100)
	    (large :default-weight semilight :default-height 140 :bold-weight extrabold)
	    (Iosevka :default-family "Iosevka Nerd Font" :default-height 110)
	    (Go :default-family "GoMono Nerd Font" :default-height 100
		:mode-line-active-family "Iosevka Nerd Font")
	    (ETBembo :default-family "Iosevka Nerd Font" :default-height 110
		     :fixed-pitch-serif-family "ETBembo" :fixed-pitch-serif-height 140
		     :variable-pitch-family "ETBembo" :variable-pitch-height 140)
	    (FiraCode :default-family "FiraCode Nerd Font" :default-height 110)
	    (MapleMono :default-family "Maple Mono NF CN" :default-height 110)
	    (JetBrainsMono :default-family "JetBrainsMono Nerd Font" :default-height 110)))
  (fontaine-set-preset (or (fontaine-restore-latest-preset) 'Go))
  (setopt fontaine-mode t))

(use-package ef-themes
  :ensure :pin gnu
  :hook (emacs-startup . (lambda () (load-theme 'ef-dark t)))
  :bind (("C-c T" . ef-themes-toggle))
  :config
  (setopt ef-themes-to-toggle '(ef-reverie ef-dark))
  (setopt ef-themes-mixed-fonts t)
  (setopt ef-themes-variable-pitch-ui t))

(use-package modus-themes :ensure :pin gnu)
(use-package doric-themes :ensure :pin gnu)
(use-package cursory :ensure)

(use-package pulsar
  :ensure :config (setopt pulsar-global-mode t))

(use-package logos
  :ensure :after olivetti
  :config
  (setopt logos-outlines-are-pages t)
  (setopt logos-olivetti t)
  (setopt logos-hide-cursor nil)
  (setopt logos-hide-mode-line t)
  (setopt logos-hide-header-line t)
  (setopt logos-hide-buffer-boundaries t)
  (setopt logos-hide-fringe t)
  (setopt logos-variable-pitch t)
  (setopt logos-buffer-read-only nil)
  (setopt logos-scroll-lock nil)
  :bind (:map logos-focus-mode-map
	      ("]" . logos-forward-page-dwim)
	      ("[" . logos-backward-page-dwim)))

(use-package olivetti
  :ensure :pin melpa-stable
  :bind (("C-c o" . olivetti-mode)))

(use-package rainbow-delimiters
  :ensure :pin melpa-stable :hook prog-mode)

(use-package posframe :ensure :pin gnu)

(use-package vertico-posframe
  :ensure :after vertico
  :config (setopt vertico-posframe-mode t))

(use-package which-key-posframe
  :ensure :pin melpa-stable :after which-key
  :config (setopt which-key-posframe-mode t))

(use-package focus :ensure :pin melpa-stable)

(use-package spacious-padding
  :ensure :after (ef-themes fontaine)
  :config
  (setopt spacious-padding-mode t)
  (setopt spacious-padding-subtle-mode-line t))

(use-package lin :ensure :config (setopt lin-mode t))
(use-package beframe :ensure)

(use-package vline
  :ensure :pin melpa-stable
  :hook (yaml-mode python-mode))

(use-package workroom :ensure :pin nongnu)

(provide 'jg-appearance)
;;; jg-appearance.el ends here
