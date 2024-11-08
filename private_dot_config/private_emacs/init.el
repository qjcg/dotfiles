;;; Emacs

(use-package emacs
  :init
  (setenv "LC_COLLATE" "C")
  (add-to-list 'exec-path "~/go/bin")

  :config
  (let ((backupdir (concat user-emacs-directory "backups")))
    (mkdir backupdir t)
    (setopt backup-directory-alist `(("." . ,backupdir))))

  (setopt package-archives '(("gnu" . "https://elpa.gnu.org/packages/")
			     ("nongnu" . "https://elpa.nongnu.org/nongnu/")
			     ("melpa" . "https://melpa.org/packages/")
			     ("melpa-stable" . "https://stable.melpa.org/packages/")))

  ;; Disable annoyances.
  (setopt inhibit-splash-screen t)
  (setopt menu-bar-mode nil)
  (setopt scroll-bar-mode nil)
  (setopt tool-bar-mode nil)
  )

;;; Programming

;;;; magit
(use-package magit :ensure)

;;;; d2-mode
(use-package d2-mode :ensure)

;;;; cue-mode
(use-package cue-mode
  :ensure
  :config
  (setopt cue-eval-command '("cue" "eval" "-c")))

;;;; go-mode
(use-package go-mode
  :ensure)

;;;; gotest
(use-package gotest
  :ensure
  :pin melpa-stable)

;;;; treesit
(use-package treesit
  :config
  (setq treesit-language-source-alist
	'((bash "https://github.com/tree-sitter/tree-sitter-bash")
	  (cmake "https://github.com/uyha/tree-sitter-cmake")
	  (css "https://github.com/tree-sitter/tree-sitter-css")
	  (elisp "https://github.com/Wilfred/tree-sitter-elisp")
	  (go "https://github.com/tree-sitter/tree-sitter-go")
	  (html "https://github.com/tree-sitter/tree-sitter-html")
	  (javascript "https://github.com/tree-sitter/tree-sitter-javascript" "master" "src")
	  (json "https://github.com/tree-sitter/tree-sitter-json")
	  (make "https://github.com/alemuller/tree-sitter-make")
	  (markdown "https://github.com/ikatyang/tree-sitter-markdown")
	  (python "https://github.com/tree-sitter/tree-sitter-python")
	  (toml "https://github.com/tree-sitter/tree-sitter-toml")
	  (tsx "https://github.com/tree-sitter/tree-sitter-typescript" "master" "tsx/src")
	  (typescript "https://github.com/tree-sitter/tree-sitter-typescript" "master" "typescript/src")
	  (yaml "https://github.com/ikatyang/tree-sitter-yaml"))))

;;;; eglot
(use-package eglot
  :hook ((go-mode go-ts-mode) . eglot-ensure)
  )

;;; Web, Browsers and Multimedia

;;;; elpher
(use-package elpher
  :ensure
  :pin melpa-stable)

;;;; eww
(use-package eww
  :ensure
  :bind
  (("C-c w" . eww)))

;;;; emms
(use-package emms
  :ensure
  :config
  (setopt emms-player-list '(emms-player-mpv))
  (setopt emms-player-mpv-update-metadata t)
  )

;;;; elfeed
(use-package elfeed
  :ensure)
;;;; time
(use-package time
  :config
  (setopt world-clock-time-format "%A %B %e %l:%M %p %Z")
  (setopt world-clock-list '(("America/Vancouver" "Vancouver")
			     ("America/Chicago" "Chicago")
			     ("America/Montreal" "Montreal")
			     ("Europe/London" "London")
			     ("Asia/Singapore" "Singapore")
			     )))

;;; Minibuffer & Completion

;;;; vertico
(use-package vertico
  :ensure
  :config
  (setopt vertico-count 20) ;; Show more candidates
  (setopt vertico-resize t) ;; Grow and shrink the Vertico minibuffer
  :init
  (vertico-mode))

;;;; consult
(use-package consult
  :ensure
  :bind
  (("C-x b" . consult-buffer)
   ("C-c t t" . consult-theme)
   ("M-s l" . consult-line)
   ("M-s M-o" . consult-outline)
   ("M-s r" . consult-ripgrep)
   ))

;;;; orderless
(use-package orderless
  :ensure
  :config
  (setopt completion-styles '(orderless basic))
  (setopt completion-category-overrides '((file (styles basic partial-completion)))))

;;;; marginalia
(use-package marginalia
  :ensure
  ;; Bind `marginalia-cycle' locally in the minibuffer.  To make the binding
  ;; available in the *Completions* buffer, add it to the
  ;; `completion-list-mode-map'.
  :bind (:map minibuffer-local-map
              ("M-A" . marginalia-cycle))

  ;; The :init section is always executed.
  :init

  ;; Marginalia must be activated in the :init section of use-package such that
  ;; the mode gets enabled right away. Note that this forces loading the
  ;; package.
  (marginalia-mode))

;;;; tempel
(use-package tempel
  :disabled
  :ensure
  :pin gnu
  :hook prog-mode
  :init
  (global-tempel-abbrev-mode)
  )

;;; Creative

;;;; denote                                                               :prot:
(use-package denote
  :ensure
  :bind
  (("C-c n n" . denote-open-or-create))
  ("C-c n j" . denote-journal-extras-new-or-existing-entry))

;;;; consult-denote
(use-package consult-denote
  :ensure
  :after (consult denote)
  )

;;;; gptel
(use-package gptel
  :ensure

  :bind
  (("C-c SPC m" . gptel-menu)
   ("C-c SPC a" . gptel-add)
   ("C-c SPC f" . gptel-add-file)
   ("C-c SPC r" . gptel-rewrite-menu)
   ("C-c SPC t" . gptel-org-set-topic)
   ("C-c SPC s" . gptel-system-prompt)
   ("C-c SPC SPC" . gptel)
   ("C-c RET" . gptel-send)
   )
  
  :config
  (setopt gptel-model "llama3.2:latest")
  (setopt gptel-default-mode 'org-mode)
  (setopt gptel-org-branching-context nil) ;; FIXME: Re-enable once error is fixed.
  (setopt gptel-backend (gptel-make-ollama "Ollama"
			  :host "localhost:11434"
			  :stream t
			  :models '("llama3.2:latest"
				    "dolphin-mistral:latest")))
  )

;;;; org
(use-package org
  :ensure
  :pin gnu)
;;;; markdown-toc
(use-package markdown-toc :ensure)

;;; Appearance & Focus

;;;; display-line-numbers-mode                                         :builtin:
(use-package display-line-numbers-mode
  :hook prog-mode
  :config
  (setopt display-line-numbers-type t)
  )

;;;; show-font                                                            :prot:
(use-package show-font :ensure)

;;;; org-modern
(use-package org-modern
  :ensure
  :config
  (setopt global-org-modern-mode 1))

;;;; fontaine                                                             :prot:
(use-package fontaine
  :ensure

  :bind
  (("C-c f f" . fontaine-set-preset))

  :config
  (setopt fontaine-presets
	  '(
	    (t

	     :default-family "Monospace"
	     :default-weight regular
	     :default-slant normal
	     :default-width normal
	     :default-height 100

	     :fixed-pitch-family nil
	     :fixed-pitch-weight nil
	     :fixed-pitch-slant nil
	     :fixed-pitch-width nil
	     :fixed-pitch-height 1.0

	     :fixed-pitch-serif-family nil
	     :fixed-pitch-serif-weight nil
	     :fixed-pitch-serif-slant nil
	     :fixed-pitch-serif-width nil
	     :fixed-pitch-serif-height 1.0

	     :variable-pitch-family "Sans"
	     :variable-pitch-weight nil
	     :variable-pitch-slant nil
	     :variable-pitch-width nil
	     :variable-pitch-height 1.0

	     :mode-line-active-family nil
	     :mode-line-active-weight nil
	     :mode-line-active-slant nil
	     :mode-line-active-width nil
	     :mode-line-active-height 1.0

	     :mode-line-inactive-family nil
	     :mode-line-inactive-weight nil
	     :mode-line-inactive-slant nil
	     :mode-line-inactive-width nil
	     :mode-line-inactive-height 1.0

	     :header-line-family nil
	     :header-line-weight nil
	     :header-line-slant nil
	     :header-line-width nil
	     :header-line-height 1.0

	     :line-number-family nil
	     :line-number-weight nil
	     :line-number-slant nil
	     :line-number-width nil
	     :line-number-height 1.0

	     :tab-bar-family nil
	     :tab-bar-weight nil
	     :tab-bar-slant nil
	     :tab-bar-width nil
	     :tab-bar-height 1.0

	     :tab-line-family nil
	     :tab-line-weight nil
	     :tab-line-slant nil
	     :tab-line-width nil
	     :tab-line-height 1.0

	     :bold-family nil
	     :bold-weight bold
	     :bold-slant nil
	     :bold-width nil
	     :bold-height 1.0

	     :italic-family nil
	     :italic-weight nil
	     :italic-slant italic
	     :italic-width nil
	     :italic-height 1.0

	     :line-spacing nil)
	    
	    (regular
	     :default-height 100)

	    (large
	     :default-weight semilight
	     :default-height 140
	     :bold-weight extrabold)

	    (Iosevka
	     :default-family "Iosevka Nerd Font"
	     :default-height 110)

	    (Go
	     :default-family "GoMono Nerd Font"
	     :default-height 100
	     :mode-line-active-family "Iosevka Nerd Font")

	    (FiraCode
	     :default-family "FiraCode Nerd Font"
	     :default-height 110)

	    (JetBrainsMono
	     :default-family "JetBrainsMono Nerd Font"
	     :default-height 110)))

  (fontaine-set-preset (or (fontaine-restore-latest-preset) 'Go))
  (setopt fontaine-mode 1)
  )

;;;; ef-themes                                                            :prot:
(use-package ef-themes
  :ensure
  :config
  (setopt ef-themes-to-toggle '(ef-reverie ef-dark))
  (setopt ef-themes-mixed-fonts t)
  (setopt ef-themes-variable-pitch-ui t)

  (load-theme 'ef-dark t)
  )

;;;; cursory                                                              :prot:
(use-package cursory :ensure)

;;;; pulsar                                                               :prot:
(use-package pulsar
  :ensure
  :config
  (setopt pulsar-global-mode t)
  )

;;;; logos                                                                :prot:
(use-package logos :ensure)

;;;; olivetti
(use-package olivetti
  :ensure
  :bind
  (("C-c o" . olivetti-mode)))

;;;; rainbow-delimiters
(use-package rainbow-delimiters
  :ensure
  :hook prog-mode)

;;;; vertico-posframe
(use-package vertico-posframe
  :ensure
  :after vertico
  :config
  (setopt vertico-posframe-mode 1))

;;;; which-key-posframe
(use-package which-key-posframe
  :ensure
  :after which-key
  :config
  (setopt which-key-posframe-mode 1))

;;;; focus
(use-package focus
  :ensure
  )

;;;; spacious-padding                                                     :prot:
(use-package spacious-padding
  :ensure
  :after (ef-themes fontaine)
  :config
  (setopt spacious-padding-mode 1)
  (setopt spacious-padding-subtle-mode-line t)
  )

;;;; lin                                                                  :prot:
(use-package lin
  :ensure
  :config
  (setopt lin-mode 1)
  )

;;;; beframe                                                              :prot:
(use-package beframe
  :ensure)

;;;; vline
(use-package vline
  :ensure
  :hook (yaml-mode python-mode)
  )

;;; Navigation, Shell & Terminal

;;;; dired                                                             :builtin:
(use-package dired
  :config
  (setopt dired-listing-switches "-alh"))

;;;; eat
(use-package eat
  :ensure
  :config
  (setopt eat-term-name "linux"))

;;;; eshell
(use-package eshell
  :config
  (setopt eshell-scroll-show-maximum-output nil))

;;;; outshine
(use-package outshine
  :ensure
  :hook prog-mode
  :bind
  (:map outshine-mode-map
	("C-c @ c" . outshine-toggle-hidden-lines-cookies)
	("C-x n s" . outshine-narrow-to-subtree)
	))

;;;; which-key
(use-package which-key
  :ensure
  :config
  (setopt which-key-idle-delay 0.5)
  (setopt which-key-mode 1))

;;;; zoxide
(use-package zoxide
  :ensure
  :pin melpa-stable
  :bind
  (("C-c z a" . zoxide-add)
   ("C-c z c" . zoxide-cd)
   ("C-c z r" . zoxide-remove)
   ("C-c z f" . zoxide-find-file)
   ("C-c z z" . zoxide-travel)
   ))

;;;; substitute                                                           :prot:
(use-package substitute
  :ensure
  :bind-keymap
  ("C-c s" . substitute-prefix-map)
  )


;;; Customize

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(custom-safe-themes
   '("b93039071f490613499b76c237c2624ae67a9aafbc717da9b4d81f456344e56e" default))
 '(elfeed-feeds
   '("https://world.hey.com/dhh/feed.atom" "https://research.swtch.com/feed.atom" "https://eli.thegreenplace.net/feeds/all.atom.xml" "https://ziglang.org/news/index.xml" "https://blog.rust-lang.org/feed.xml" "https://ici.radio-canada.ca/rss/4201" "https://www.cbc.ca/webfeed/rss/rss-canada-montreal" "https://www.theverge.com/rss/frontpage" "http://feeds.hbr.org/harvardbusiness" "https://techcrunch.com/feed/" "https://rss.art19.com/smartless" "https://www.cbc.ca/webfeed/rss/rss-sports" "https://www.cbc.ca/webfeed/rss/rss-technology" "https://go.dev/blog/feed.atom"))
 '(lin-global-mode 1 nil nil "Customized with use-package lin")
 '(package-selected-packages
   '(gotest markdown-toc elfeed tempel org backline outline-minor-faces bicycle go-mode vline hl-column beframe lin spacious-padding substitute show-font focus outshine cursory pulsar logos consult-denote fontaine which-key-posframe vertico-posframe d2-mode elpher cue-mode acme-theme zoxide olivetti which-key emms org-modern rainbow-delimiters gptel magit orderless denote ef-themes marginalia vertico consult eat))
 '(safe-local-variable-values
   '((markdown-toc-header-toc-title . "## Contents")
     (markdown-toc-indentation-space . 2)
     (markdown-toc-user-toc-structure-manipulation-fn lambda
						      (markdown-list)
						      (let*
							  ((remaining-list
							    (cdr markdown-list))
							   (processed-list
							    (mapcar
							     (lambda
							       (item)
							       (cons
								(1-
								 (car item))
								(cdr item)))
							     remaining-list)))
							processed-list)))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(fringe ((t :background "#000000")))
 '(header-line ((t :box (:line-width 4 :color "#1a1a1a" :style nil))))
 '(header-line-highlight ((t :box (:color "#d0d0d0"))))
 '(keycast-key ((t)))
 '(line-number ((t :background "#000000")))
 '(mode-line ((t :box (:line-width 6 :color "#2a2a75" :style nil))))
 '(mode-line-active ((t :box (:line-width 6 :color "#2a2a75" :style nil))))
 '(mode-line-highlight ((t :box (:color "#d0d0d0"))))
 '(mode-line-inactive ((t :box (:line-width 6 :color "#2b2b2b" :style nil))))
 '(tab-bar-tab ((t :box (:line-width 4 :color "#000000" :style nil))))
 '(tab-bar-tab-inactive ((t :box (:line-width 4 :color "#4b4b4b" :style nil))))
 '(tab-line-tab ((t)))
 '(tab-line-tab-active ((t)))
 '(tab-line-tab-inactive ((t)))
 '(vertical-border ((t :background "#000000" :foreground "#000000")))
 '(window-divider ((t (:background "#000000" :foreground "#000000"))))
 '(window-divider-first-pixel ((t (:background "#000000" :foreground "#000000"))))
 '(window-divider-last-pixel ((t (:background "#000000" :foreground "#000000")))))
