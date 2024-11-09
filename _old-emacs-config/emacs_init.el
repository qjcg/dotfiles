;;;  ________                                                _______                 __                            __
;;; /        |                                              /       \               /  |                          /  |
;;; $$$$$$$$/ _____  ____   ______   _______  _______       $$$$$$$  | ______   ____$$ | ______   ______   _______$$ |   __
;;; $$ |__   /     \/    \ /      \ /       |/       |      $$ |__$$ |/      \ /    $$ |/      \ /      \ /       $$ |  /  |
;;; $$    |  $$$$$$ $$$$  |$$$$$$  /$$$$$$$//$$$$$$$/       $$    $$</$$$$$$  /$$$$$$$ /$$$$$$  /$$$$$$  /$$$$$$$/$$ |_/$$/
;;; $$$$$/   $$ | $$ | $$ |/    $$ $$ |     $$      \       $$$$$$$  $$    $$ $$ |  $$ $$ |  $$/$$ |  $$ $$ |     $$   $$<
;;; $$ |_____$$ | $$ | $$ /$$$$$$$ $$ \_____ $$$$$$  |      $$ |__$$ $$$$$$$$/$$ \__$$ $$ |     $$ \__$$ $$ \_____$$$$$$  \
;;; $$       $$ | $$ | $$ $$    $$ $$       /     $$/       $$    $$/$$       $$    $$ $$ |     $$    $$/$$       $$ | $$  |
;;; $$$$$$$$/$$/  $$/  $$/ $$$$$$$/ $$$$$$$/$$$$$$$/        $$$$$$$/  $$$$$$$/ $$$$$$$/$$/       $$$$$$/  $$$$$$$/$$/   $$/

;;; Minimal init.el

;;; Contents:
;;;
;;;  - Basic settings
;;;  - Discovery aids
;;;  - Minibuffer/completion settings
;;;  - Interface enhancements/defaults
;;;  - Tab-bar configuration
;;;  - Theme
;;;  - Optional extras
;;;  - Built-in customization framework

;;; Guardrail

(when (< emacs-major-version 29)
  (error "Emacs Bedrock only works with Emacs 29 and newer; you have version %s" emacs-major-version))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;
;;;   Basic settings
;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; Package initialization
;;
;; We'll stick to the built-in GNU and non-GNU ELPAs (Emacs Lisp Package
;; Archive) for the base install, but there are some other ELPAs you could look
;; at if you want more packages. MELPA in particular is very popular. See
;; instructions at:
;;
;;    https://melpa.org/#/getting-started
;;
;; You can simply uncomment the following if you'd like to get started with
;; MELPA packages quickly:
;;
;; (with-eval-after-load 'package
;;   (add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/") t))

;; If you want to turn off the welcome screen, uncomment this
(setopt inhibit-splash-screen t)

(setopt initial-major-mode 'fundamental-mode)  ; default mode for the *scratch* buffer
(setopt display-time-default-load-average nil) ; this information is useless for most

;; Automatically reread from disk if the underlying file changes
(setopt auto-revert-avoid-polling t)
;; Some systems don't do file notifications well; see
;; https://todo.sr.ht/~ashton314/emacs-bedrock/11
(setopt auto-revert-interval 5)
(setopt auto-revert-check-vc-info t)
(global-auto-revert-mode)

;; Save history of minibuffer
(savehist-mode)

;; Move through windows with Ctrl-<arrow keys>
(windmove-default-keybindings 'control) ; You can use other modifiers here

;; Fix archaic defaults
(setopt sentence-end-double-space nil)

;; Make right-click do something sensible
(when (display-graphic-p)
  (context-menu-mode))

;; Don't litter file system with *~ backup files; put them all inside
;; ~/.emacs.d/backup or wherever
(defun bedrock--backup-file-name (fpath)
  "Return a new file path of a given file path.
If the new path's directories does not exist, create them."
  (let* ((backupRootDir (concat user-emacs-directory "emacs-backup/"))
         (filePath (replace-regexp-in-string "[A-Za-z]:" "" fpath )) ; remove Windows driver letter in path
         (backupFilePath (replace-regexp-in-string "//" "/" (concat backupRootDir filePath "~") )))
    (make-directory (file-name-directory backupFilePath) (file-name-directory backupFilePath))
    backupFilePath))
(setopt make-backup-file-name-function 'bedrock--backup-file-name)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;
;;;   Discovery aids
;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; Show the help buffer after startup
(add-hook 'after-init-hook 'help-quick)

;; which-key: shows a popup of available keybindings when typing a long key
;; sequence (e.g. C-x ...)
(use-package which-key
  :ensure t
  :config
  (which-key-mode))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;
;;;   Minibuffer/completion settings
;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; For help, see: https://www.masteringemacs.org/article/understanding-minibuffer-completion

(setopt enable-recursive-minibuffers t)                ; Use the minibuffer whilst in the minibuffer
(setopt completion-cycle-threshold 1)                  ; TAB cycles candidates
(setopt completions-detailed t)                        ; Show annotations
(setopt tab-always-indent 'complete)                   ; When I hit TAB, try to complete, otherwise, indent
(setopt completion-styles '(basic initials substring)) ; Different styles to match input to candidates

(setopt completion-auto-help 'always)                  ; Open completion always; `lazy' another option
(setopt completions-max-height 20)                     ; This is arbitrary
(setopt completions-detailed t)
(setopt completions-format 'one-column)
(setopt completions-group t)
(setopt completion-auto-select 'second-tab)            ; Much more eager
;(setopt completion-auto-select t)                     ; See `C-h v completion-auto-select' for more possible values

(keymap-set minibuffer-mode-map "TAB" 'minibuffer-complete) ; TAB acts more like how it does in the shell

;; For a fancier built-in completion option, try ido-mode,
;; icomplete-vertical, or fido-mode. See also the file extras/base.el

;(icomplete-vertical-mode)
;(fido-vertical-mode)
;(setopt icomplete-delay-completions-threshold 4000)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;
;;;   Interface enhancements/defaults
;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; Mode line information
(setopt line-number-mode t)                        ; Show current line in modeline
(setopt column-number-mode t)                      ; Show column as well

(setopt x-underline-at-descent-line nil)           ; Prettier underlines
(setopt switch-to-buffer-obey-display-actions t)   ; Make switching buffers more consistent

(setopt show-trailing-whitespace nil)      ; By default, don't underline trailing spaces
(setopt indicate-buffer-boundaries 'left)  ; Show buffer top and bottom in the margin

;; Enable horizontal scrolling
(setopt mouse-wheel-tilt-scroll t)
(setopt mouse-wheel-flip-direction t)

;; We won't set these, but they're good to know about
;;
;; (setopt indent-tabs-mode nil)
;; (setopt tab-width 4)

;; Misc. UI tweaks
(blink-cursor-mode -1)                                ; Steady cursor
(pixel-scroll-precision-mode)                         ; Smooth scrolling

;; Use common keystrokes by default
;(cua-mode)

;; Display line numbers in programming mode
(add-hook 'prog-mode-hook 'display-line-numbers-mode)
(setopt display-line-numbers-width 3)           ; Set a minimum width

;; Nice line wrapping when working with text
(add-hook 'text-mode-hook 'visual-line-mode)

;; Modes to highlight the current line with
(let ((hl-line-hooks '(text-mode-hook prog-mode-hook)))
  (mapc (lambda (hook) (add-hook hook 'hl-line-mode)) hl-line-hooks))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;
;;;   Tab-bar configuration
;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; Show the tab-bar as soon as tab-bar functions are invoked
(setopt tab-bar-show 1)

;; Add the time to the tab-bar, if visible
(add-to-list 'tab-bar-format 'tab-bar-format-align-right 'append)
(add-to-list 'tab-bar-format 'tab-bar-format-global 'append)
(setopt display-time-format "%a %F %T")
(setopt display-time-interval 1)
(display-time-mode)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;
;;;   Theme
;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(use-package emacs
  :config
  (load-theme 'modus-vivendi))          ; for light theme, use modus-operandi

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;
;;;   Optional extras
;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; Uncomment the (load-file …) lines or copy code from the extras/ elisp files
;; as desired

;; UI/UX enhancements mostly focused on minibuffer and autocompletion interfaces
;; These ones are *strongly* recommended!
(load-file (expand-file-name "extras/base.el" user-emacs-directory))

;; Packages for software development
(load-file (expand-file-name "extras/dev.el" user-emacs-directory))

;; Vim-bindings in Emacs (evil-mode configuration)
;(load-file (expand-file-name "extras/vim-like.el" user-emacs-directory))

;; Org-mode configuration
;; WARNING: need to customize things inside the elisp file before use! See
;; the file extras/org-intro.txt for help.
;(load-file (expand-file-name "extras/org.el" user-emacs-directory))

;; Email configuration in Emacs
;; WARNING: needs the `mu' program installed; see the elisp file for more
;; details.
;(load-file (expand-file-name "extras/email.el" user-emacs-directory))

;; Tools for academic researchers
;(load-file (expand-file-name "extras/researcher.el" user-emacs-directory))

(load-file (expand-file-name "extras/jg_custom.el" user-emacs-directory))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;
;;;   Built-in customization framework
;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(cue-eval-command '("cue" "eval" "-c"))
 '(custom-enabled-themes '(ef-dark))
 '(custom-safe-themes
   '("b93039071f490613499b76c237c2624ae67a9aafbc717da9b4d81f456344e56e" "e410458d3e769c33e0865971deb6e8422457fad02bf51f7862fa180ccc42c032" "0f76f9e0af168197f4798aba5c5ef18e07c926f4e7676b95f2a13771355ce850" "861f45e25a39046c882b473fa39544d834fd5d1f514176782cca146c67cbdb19" "1781e8bccbd8869472c09b744899ff4174d23e4f7517b8a6c721100288311fa5" "a68624bd5c4bec879ee59cd3039531b6229766a8b8ed0e79eef2642f14dbda32" "58c996beb973f7e988ee4fd21c367b7a5bbdb0622ddfbbd112672a7b4e3d3b81" "afeb7b07dbc1a4cfadb24f3ef6c8cf5e63051bf76411779f03a0fe3aadc07768" "263e3a9286c7ab0c4f57f5d537033c8a5943e69d142e747723181ab9b12a5855" default))
 '(dashboard-agenda-item-icon 🗓️)
 '(dashboard-items
   '((projects . 5)
     (recents . 5)
     (bookmarks . 5)
     (agenda . 5)))
 '(dashboard-projects-backend 'project-el)
 '(dashboard-projects-item-format "%-30s  %s")
 '(dashboard-projects-show-base t)
 '(dired-listing-switches "-alh")
 '(emms-player-list '(emms-player-mpv))
 '(emms-player-mpv-update-metadata t)
 '(emms-playlist-mode-center-when-go t)
 '(emms-source-file-default-directory "~/.emacs.d/emms/")
 '(exec-path
   '("/home/jgosset/go/bin" "/home/jgosset/.nix-profile/bin" "/usr/local/sbin" "/usr/local/bin" "/usr/sbin" "/usr/bin" "/sbin" "/bin" "/usr/games" "/usr/local/games" "/snap/bin" "/snap/bin" "/snap/emacs/current/usr/bin" "/snap/emacs/current/usr/libexec/emacs/29.4/x86_64-pc-linux-gnu"))
 '(fontaine-presets
   '((regular :default-height 100)
     (large :default-weight semilight :default-height 140 :bold-weight extrabold)
     (t :default-family "Monospace" :default-weight regular :default-slant normal :default-height 100 :fixed-pitch-weight nil :fixed-pitch-slant nil :fixed-pitch-height 1.0 :fixed-pitch-serif-weight nil :fixed-pitch-serif-slant nil :fixed-pitch-serif-height 1.0 :variable-pitch-family "Sans" :variable-pitch-weight nil :variable-pitch-slant nil :variable-pitch-height 1.0 :mode-line-active-weight nil :mode-line-active-slant nil :mode-line-active-height 1.0 :mode-line-inactive-weight nil :mode-line-inactive-slant nil :mode-line-inactive-height 1.0 :header-line-weight nil :header-line-slant nil :header-line-height 1.0 :line-number-weight nil :line-number-slant nil :line-number-height 1.0 :tab-bar-weight nil :tab-bar-slant nil :tab-bar-height 1.0 :tab-line-weight nil :tab-line-slant nil :tab-line-height 1.0 :bold-weight bold :bold-slant nil :bold-height 1.0 :italic-weight nil :italic-slant italic :italic-height 1.0 :line-spacing nil :fixed-pitch-family nil :fixed-pitch-serif-family nil :mode-line-active-family nil :mode-line-inactive-family nil :header-line-family nil :line-number-family nil :tab-bar-family nil :tab-line-family nil :bold-family nil :italic-family nil)
     (gomono :default-family "GoMono Nerd Font" :default-height 140)
     (FiraCode :default-family "FiraCode Nerd Font" :default-weight regular :default-height 140)
     (Iosevka :default-family "Iosevka Nerd Font" :default-height 140)
     (iosevka-term :default-family "IosevkaTerm Nerd Font" :default-height 140)
     (victormono :default-family "VictorMono Nerd Font")
     (JetBrainsMono :default-family "JetBrainsMono Nerd Font")
     (ComicShannsMono :default-family "ComicShannsMono Nerd Font")
     (IosevkaTerm-Large :default-family "IosevkaTerm Nerd Font" :default-height 240)))
 '(global-org-modern-mode t)
 '(gptel-default-mode 'org-mode)
 '(menu-bar-mode nil)
 '(package-archives
   '(("gnu" . "https://elpa.gnu.org/packages/")
     ("nongnu" . "https://elpa.nongnu.org/nongnu/")
     ("melpa-stable" . "https://stable.melpa.org/packages/")
     ("melpa" . "https://melpa.org/packages/")))
 '(package-pinned-packages
   '((acme-theme . "melpa-stable")
     (avy . "gnu")
     (cape . "gnu")
     (casual-suite . "melpa-stable")
     (consult . "gnu")
     (corfu . "gnu")
     (cue-mode . "melpa-stable")
     (d2-mode . "melpa-stable")
     (dash . "gnu")
     (denote . "gnu")
     (editorconfig . "nongnu")
     (ef-themes . "gnu")
     (embark . "gnu")
     (embark-consult . "gnu")
     (emms . "gnu")
     (fontaine . "gnu")
     (go-mode . "gnu")
     (gptel . "nongnu")
     (json-mode . "gnu")
     (magit . "gnu")
     (magit-section . "gnu")
     (marginalia . "gnu")
     (markdown-mode . "gnu")
     (markdown-toc . "melpa-stable")
     (modus-themes . "gnu")
     (moe-theme . "gnu")
     (no-littering . "melpa-stable")
     (olivetti . "melpa-stable")
     (orderless . "gnu")
     (org-modern . "gnu")
     (org-modern . "gnu")
     (rainbow-delimiters . "melpa-stable")
     (transient . "gnu")
     (vertico . "gnu")
     (wgrep . "gnu")
     (which-key . "gnu")
     (with-editor . "gnu")
     (yaml-mode . "gnu")
     (zoxide . "melpa-stable")))
 '(package-selected-packages
   '(magit geiser geiser-guile figlet dashboard rainbow-delimiters zoxide with-editor org json-mode vterm cue-mode olivetti no-littering markdown-toc d2-mode casual-suite acme-theme editorconfig gptel emms modus-themes moe-theme nano-theme starlit-theme earthfile-mode markdown-mode org-modern denote fontaine go-mode ef-themes eglot go-impl which-key cape consult corfu eat embark marginalia orderless vertico yaml-mode))
 '(require-final-newline t)
 '(safe-local-variable-values
   '((markdown-toc-user-toc-structure-manipulation-fn lambda
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
							processed-list))
     (markdown-toc-header-toc-title . "## Contents")
     (markdown-toc-indentation-space . 2)))
 '(truncate-lines t))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
