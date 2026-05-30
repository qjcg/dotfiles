;;; poolrooms-dark-theme.el --- Poolrooms dark theme  -*- lexical-binding: t; -*-

;; Author: John Gosset
;; Version: 1.0
;; Keywords: faces themes

;;; Commentary:
;; A dark Emacs theme inspired by the poolrooms liminal aesthetic —
;; empty institutional swimming pools lit by flickering fluorescent light,
;; still teal water reflecting off cream-coloured ceramic tile.
;;
;; Palette:
;;   Pool Depth   #0B1A1E  — primary background (deep water black-teal)
;;   Pool Shadow  #112830  — secondary background (mode-line, fringe)
;;   Tile Mist    #D8E8E6  — primary foreground (faded tile glare)
;;   Pool Water   #00C4B4  — primary accent (cyan-teal, still water surface)
;;   Water 80%    #33CFB9  — builtins, preprocessors
;;   Water 60%    #66DAC6  — variables, lazy-highlight
;;   Water 40%    #99E6D3  — types
;;   Water 20%    #CCF3E9  — background highlights
;;   Fluorescent  #E8C84A  — cursor, warnings (amber fluorescent tube)
;;   Amber 80%    #EDD372  — constants
;;   Amber 60%    #F2DE9A  — strings (warm fluorescent wash)
;;   Grout        #4A5E5B  — comments, secondary text (damp grout lines)

;;; Code:

(deftheme poolrooms-dark "Poolrooms dark theme — liminal pool depths.")

(custom-theme-set-faces
 'poolrooms-dark

 ;; ───────────────────────────────────────────────────────────────────────────
 ;; 1. BASIC
 ;; ───────────────────────────────────────────────────────────────────────────
 '(default ((((type graphic))
             (:background "#0B1A1E" :foreground "#D8E8E6"
              :slant normal :weight normal :height 160 :width normal
              :family "JuliaMono"))
            (t
             (:background "#0B1A1E" :foreground "#D8E8E6"))))
 '(cursor ((t (:background "#E8C84A"))))
 '(fixed-pitch ((t (:family "Monospace"))))
 '(variable-pitch ((((type w32)) (:foundry "outline" :family "Arial"))
                   (t (:family "Sans Serif"))))

 ;; ───────────────────────────────────────────────────────────────────────────
 ;; 2. UI CHROME
 ;; ───────────────────────────────────────────────────────────────────────────
 '(fringe ((t (:background "#112830" :foreground "#4A5E5B"))))
 '(header-line ((t (:background "#112830" :foreground "#D8E8E6"
                    :box (:line-width 1 :color "#00C4B4")))))
 '(tooltip ((((class color))
             (:inherit variable-pitch
              :background "#112830" :foreground "#D8E8E6"))
            (t (:inherit variable-pitch))))
 '(mode-line ((t (:background "#112830" :foreground "#66DAC6"
                  :box (:line-width 1 :color "#00C4B4" :style nil)))))
 '(mode-line-buffer-id ((t (:foreground "#D8E8E6" :weight bold))))
 '(mode-line-emphasis ((t (:foreground "#00C4B4" :weight bold))))
 '(mode-line-highlight ((((class color) (min-colors 88))
                         (:box (:line-width 2 :color "#00C4B4" :style released-button)))
                        (t (:inherit highlight))))
 '(mode-line-inactive ((t (:background "#112830" :foreground "#4A5E5B"
                            :box (:line-width 1 :color "#112830" :style nil)))))
 '(tab-bar ((t (:background "#112830" :foreground "#4A5E5B"))))
 '(tab-bar-tab ((t (:background "#0B1A1E" :foreground "#00C4B4"
                    :box (:line-width 2 :color "#00C4B4" :style nil)))))
 '(tab-bar-tab-inactive ((t (:background "#112830" :foreground "#4A5E5B"
                              :box (:line-width 2 :color "#112830" :style nil)))))

 ;; ───────────────────────────────────────────────────────────────────────────
 ;; 3. MINIBUFFER
 ;; ───────────────────────────────────────────────────────────────────────────
 '(minibuffer-prompt ((t (:foreground "#00C4B4" :weight bold))))

 ;; ───────────────────────────────────────────────────────────────────────────
 ;; 4. SELECTION / HIGHLIGHTING
 ;; ───────────────────────────────────────────────────────────────────────────
 '(highlight ((t (:background "#112830" :foreground "#D8E8E6" :extend t))))
 '(region ((t (:background "#163A40" :foreground "#D8E8E6" :extend t))))
 '(secondary-selection
   ((((class color) (min-colors 88) (background dark))
     (:background "#1C4A52" :extend t))
    (((class color) (min-colors 8) (background dark))
     (:foreground "#D8E8E6" :background "#112830" :extend t))
    (t (:inverse-video t))))
 '(shadow ((((class color grayscale) (min-colors 88) (background dark))
            (:foreground "#4A5E5B"))
           (((class color) (min-colors 8) (background dark))
            (:foreground "#4A5E5B"))
           (t (:foreground "grey70"))))
 '(hl-line ((t (:background "#112830" :extend t))))

 ;; ───────────────────────────────────────────────────────────────────────────
 ;; 5. SEARCH
 ;; ───────────────────────────────────────────────────────────────────────────
 '(isearch ((t (:background "#00C4B4" :foreground "#0B1A1E" :weight bold))))
 '(isearch-fail ((((class color) (min-colors 88) (background dark))
                  (:background "#5C2A00" :foreground "#D8E8E6"))
                 (((class color) (min-colors 8))
                  (:background "red" :foreground "white"))
                 (t (:inverse-video t))))
 '(lazy-highlight ((t (:background "#112830" :foreground "#66DAC6"
                        :underline (:color "#66DAC6" :style line)))))
 '(match ((((class color) (min-colors 88) (background dark))
           (:background "#1C4A52" :foreground "#D8E8E6"))
          (((class color) (min-colors 8) (background dark))
           (:background "#112830" :foreground "#D8E8E6"))
          (t (:inverse-video t))))
 '(query-replace ((t (:inherit isearch))))

 ;; ───────────────────────────────────────────────────────────────────────────
 ;; 6. LINKS
 ;; ───────────────────────────────────────────────────────────────────────────
 '(button ((t (:foreground "#00C4B4" :underline (:color "#00C4B4" :style line)))))
 '(link ((t (:foreground "#00C4B4" :underline (:color "#00C4B4" :style line)))))
 '(link-visited ((default (:inherit link))
                 (((class color) (background dark))
                  (:foreground "#66DAC6"
                   :underline (:color "#66DAC6" :style line)))))

 ;; ───────────────────────────────────────────────────────────────────────────
 ;; 7. TEXT GLYPHS
 ;; ───────────────────────────────────────────────────────────────────────────
 '(trailing-whitespace ((t (:background "#E8C84A"))))
 '(escape-glyph ((((background dark)) (:foreground "#66DAC6"))
                 (((type pc)) (:foreground "#EDD372"))
                 (t (:foreground "#00A898"))))
 '(homoglyph ((((background dark)) (:foreground "#66DAC6"))
              (((type pc)) (:foreground "#EDD372"))
              (t (:foreground "#00A898"))))

 ;; ───────────────────────────────────────────────────────────────────────────
 ;; 8. NAVIGATION / COMPILATION
 ;; ───────────────────────────────────────────────────────────────────────────
 '(next-error ((t (:inherit region))))
 '(compilation-error ((t (:foreground "#E8C84A" :weight bold))))
 '(compilation-warning ((t (:foreground "#EDD372" :weight bold))))
 '(compilation-info ((t (:foreground "#00C4B4"))))
 '(compilation-line-number ((t (:foreground "#4A5E5B"))))
 '(compilation-column-number ((t (:foreground "#4A5E5B"))))
 '(compilation-mode-line-exit ((t (:foreground "#00C4B4" :weight bold))))
 '(compilation-mode-line-fail ((t (:foreground "#E8C84A" :weight bold))))
 '(compilation-mode-line-run ((t (:foreground "#EDD372"))))

 ;; ───────────────────────────────────────────────────────────────────────────
 ;; 9. FONT-LOCK (SYNTAX)
 ;; ───────────────────────────────────────────────────────────────────────────
 '(font-lock-builtin-face ((t (:foreground "#33CFB9"))))
 '(font-lock-comment-delimiter-face ((t (:foreground "#4A5E5B" :slant italic))))
 '(font-lock-comment-face ((t (:foreground "#4A5E5B" :slant italic))))
 '(font-lock-constant-face ((((class color) (min-colors 88) (background dark))
                              (:foreground "#EDD372"))
                             (t (:foreground "#EDD372" :weight bold))))
 '(font-lock-doc-face ((t (:foreground "#7A9E9A"))))
 '(font-lock-doc-markup-face ((t (:foreground "#66DAC6"))))
 '(font-lock-function-name-face ((t (:foreground "#00C4B4"))))
 '(font-lock-keyword-face ((t (:foreground "#00C4B4" :weight bold))))
 '(font-lock-negation-char-face ((t (:foreground "#E8C84A" :weight bold))))
 '(font-lock-preprocessor-face ((t (:foreground "#33CFB9" :slant italic))))
 '(font-lock-regexp-grouping-backslash ((t (:inherit bold))))
 '(font-lock-regexp-grouping-construct ((t (:inherit bold))))
 '(font-lock-string-face ((t (:foreground "#F2DE9A"))))
 '(font-lock-type-face ((t (:foreground "#99E6D3" :weight bold))))
 '(font-lock-variable-name-face ((t (:foreground "#66DAC6"))))
 '(font-lock-warning-face ((t (:foreground "#E8C84A" :weight bold))))
 ;; Emacs 29+ additional font-lock faces
 '(font-lock-bracket-face ((t (:foreground "#4A5E5B"))))
 '(font-lock-delimiter-face ((t (:foreground "#4A5E5B"))))
 '(font-lock-misc-punctuation-face ((t (:foreground "#4A5E5B"))))
 '(font-lock-number-face ((t (:foreground "#F2DE9A"))))
 '(font-lock-operator-face ((t (:foreground "#D8E8E6"))))
 '(font-lock-property-name-face ((t (:foreground "#66DAC6"))))
 '(font-lock-property-use-face ((t (:foreground "#66DAC6"))))
 '(font-lock-punctuation-face ((t (:foreground "#4A5E5B"))))

 ;; ───────────────────────────────────────────────────────────────────────────
 ;; 10. ORG-MODE
 ;; ───────────────────────────────────────────────────────────────────────────
 '(org-document-title ((t (:foreground "#00C4B4" :weight bold :height 1.4))))
 '(org-document-info ((t (:foreground "#66DAC6" :slant italic))))
 '(org-document-info-keyword ((t (:foreground "#4A5E5B"))))
 '(org-level-1 ((t (:foreground "#00C4B4" :weight bold :height 1.3))))
 '(org-level-2 ((t (:foreground "#E8C84A" :weight bold :height 1.2))))
 '(org-level-3 ((t (:foreground "#66DAC6" :weight bold :height 1.1))))
 '(org-level-4 ((t (:foreground "#EDD372" :weight bold))))
 '(org-level-5 ((t (:foreground "#33CFB9"))))
 '(org-level-6 ((t (:foreground "#F2DE9A"))))
 '(org-level-7 ((t (:foreground "#99E6D3"))))
 '(org-level-8 ((t (:foreground "#CCF3E9"))))
 '(org-block ((t (:background "#071012" :extend t))))
 '(org-block-begin-line ((t (:background "#112830" :foreground "#4A5E5B"
                              :slant italic :extend t))))
 '(org-block-end-line ((t (:background "#112830" :foreground "#4A5E5B"
                            :slant italic :extend t))))
 '(org-code ((t (:foreground "#66DAC6" :background "#071012"))))
 '(org-verbatim ((t (:foreground "#99E6D3"))))
 '(org-table ((t (:foreground "#D8E8E6"))))
 '(org-link ((t (:foreground "#00C4B4" :underline (:color "#00C4B4" :style line)))))
 '(org-todo ((t (:foreground "#E8C84A" :weight bold))))
 '(org-done ((t (:foreground "#00C4B4" :weight bold))))
 '(org-headline-done ((t (:foreground "#4A5E5B" :strike-through t))))
 '(org-date ((t (:foreground "#66DAC6" :underline t))))
 '(org-warning ((t (:foreground "#E8C84A" :weight bold))))
 '(org-special-keyword ((t (:foreground "#4A5E5B"))))
 '(org-tag ((t (:foreground "#4A5E5B" :weight bold))))
 '(org-checkbox ((t (:foreground "#EDD372" :weight bold))))
 '(org-formula ((t (:foreground "#F2DE9A"))))

 ;; ───────────────────────────────────────────────────────────────────────────
 ;; 11. DIFF / MAGIT
 ;; ───────────────────────────────────────────────────────────────────────────
 '(diff-added ((t (:background "#071F1C" :foreground "#66DAC6" :extend t))))
 '(diff-removed ((t (:background "#2A2000" :foreground "#EDD372" :extend t))))
 '(diff-changed ((t (:background "#112830" :foreground "#D8E8E6" :extend t))))
 '(diff-header ((t (:background "#112830" :foreground "#4A5E5B" :weight bold))))
 '(diff-file-header ((t (:background "#112830" :foreground "#D8E8E6" :weight bold))))
 '(diff-hunk-header ((t (:background "#071012" :foreground "#66DAC6"))))
 '(diff-context ((t (:foreground "#4A5E5B"))))
 '(magit-section-heading ((t (:foreground "#00C4B4" :weight bold))))
 '(magit-section-highlight ((t (:background "#112830"))))
 '(magit-branch-local ((t (:foreground "#E8C84A" :weight bold))))
 '(magit-branch-remote ((t (:foreground "#EDD372"))))
 '(magit-branch-current ((t (:foreground "#E8C84A" :weight bold
                              :box (:line-width 1 :color "#E8C84A")))))
 '(magit-tag ((t (:foreground "#F2DE9A"))))
 '(magit-hash ((t (:foreground "#4A5E5B"))))
 '(magit-diff-added ((t (:background "#071F1C" :foreground "#66DAC6" :extend t))))
 '(magit-diff-removed ((t (:background "#2A2000" :foreground "#EDD372" :extend t))))
 '(magit-diff-added-highlight ((t (:background "#0D302A" :foreground "#66DAC6" :extend t))))
 '(magit-diff-removed-highlight ((t (:background "#3A3000" :foreground "#EDD372" :extend t))))
 '(magit-diff-context ((t (:foreground "#4A5E5B" :extend t))))
 '(magit-diff-context-highlight ((t (:background "#112830" :foreground "#D8E8E6" :extend t))))
 '(magit-diff-hunk-heading ((t (:background "#112830" :foreground "#4A5E5B"))))
 '(magit-diff-hunk-heading-highlight ((t (:background "#112830" :foreground "#66DAC6" :weight bold))))
 '(magit-process-ok ((t (:foreground "#00C4B4" :weight bold))))
 '(magit-process-ng ((t (:foreground "#E8C84A" :weight bold))))

 ;; ───────────────────────────────────────────────────────────────────────────
 ;; 12. LINE NUMBERS
 ;; ───────────────────────────────────────────────────────────────────────────
 '(line-number ((t (:background "#0B1A1E" :foreground "#4A5E5B"))))
 '(line-number-current-line ((t (:background "#112830" :foreground "#D8E8E6" :weight bold))))
 '(line-number-major-tick ((t (:background "#0B1A1E" :foreground "#33CFB9"))))
 '(line-number-minor-tick ((t (:background "#0B1A1E" :foreground "#4A5E5B"))))

 ;; ───────────────────────────────────────────────────────────────────────────
 ;; 13. COMPLETION (CORFU)
 ;; ───────────────────────────────────────────────────────────────────────────
 '(completions-common-part ((t (:foreground "#00C4B4" :weight bold))))
 '(completions-first-difference ((t (:foreground "#E8C84A" :weight bold))))
 '(completions-annotations ((t (:foreground "#4A5E5B" :slant italic))))
 '(corfu-default ((t (:background "#112830" :foreground "#D8E8E6"))))
 '(corfu-current ((t (:background "#00C4B4" :foreground "#0B1A1E" :weight bold))))
 '(corfu-bar ((t (:background "#00C4B4"))))
 '(corfu-border ((t (:background "#33CFB9"))))
 '(corfu-annotations ((t (:foreground "#4A5E5B"))))
 '(corfu-deprecated ((t (:foreground "#4A5E5B" :strike-through t))))

 ;; ───────────────────────────────────────────────────────────────────────────
 ;; 14. VERTICO / CONSULT / ORDERLESS
 ;; ───────────────────────────────────────────────────────────────────────────
 '(vertico-current ((t (:background "#112830" :foreground "#D8E8E6" :extend t))))
 '(vertico-group-title ((t (:foreground "#4A5E5B" :slant italic))))
 '(vertico-group-separator ((t (:foreground "#4A5E5B" :strike-through t))))
 '(consult-file ((t (:foreground "#66DAC6"))))
 '(consult-buffer ((t (:foreground "#D8E8E6"))))
 '(consult-grep-context ((t (:foreground "#4A5E5B"))))
 '(consult-highlight-match ((t (:foreground "#00C4B4" :weight bold))))
 '(orderless-match-face-0 ((t (:foreground "#00C4B4" :weight bold))))
 '(orderless-match-face-1 ((t (:foreground "#E8C84A" :weight bold))))
 '(orderless-match-face-2 ((t (:foreground "#66DAC6" :weight bold))))
 '(orderless-match-face-3 ((t (:foreground "#EDD372" :weight bold))))

 ;; ───────────────────────────────────────────────────────────────────────────
 ;; 15. RAINBOW DELIMITERS
 ;; Alternating pool-water teal / fluorescent amber; grout as neutral depth-9
 ;; ───────────────────────────────────────────────────────────────────────────
 '(rainbow-delimiters-base-face ((t (:inherit nil))))
 '(rainbow-delimiters-depth-1-face ((t (:inherit rainbow-delimiters-base-face
                                         :foreground "#00C4B4"))))
 '(rainbow-delimiters-depth-2-face ((t (:inherit rainbow-delimiters-base-face
                                         :foreground "#E8C84A"))))
 '(rainbow-delimiters-depth-3-face ((t (:inherit rainbow-delimiters-base-face
                                         :foreground "#66DAC6"))))
 '(rainbow-delimiters-depth-4-face ((t (:inherit rainbow-delimiters-base-face
                                         :foreground "#EDD372"))))
 '(rainbow-delimiters-depth-5-face ((t (:inherit rainbow-delimiters-base-face
                                         :foreground "#33CFB9"))))
 '(rainbow-delimiters-depth-6-face ((t (:inherit rainbow-delimiters-base-face
                                         :foreground "#F2DE9A"))))
 '(rainbow-delimiters-depth-7-face ((t (:inherit rainbow-delimiters-base-face
                                         :foreground "#99E6D3"))))
 '(rainbow-delimiters-depth-8-face ((t (:inherit rainbow-delimiters-base-face
                                         :foreground "#CCF3E9"))))
 '(rainbow-delimiters-depth-9-face ((t (:inherit rainbow-delimiters-base-face
                                         :foreground "#4A5E5B"))))
 '(rainbow-delimiters-unmatched-face ((t (:foreground "#0B1A1E"
                                           :background "#E8C84A" :weight bold))))
 '(rainbow-delimiters-mismatched-face ((t (:foreground "#0B1A1E"
                                            :background "#E8C84A" :weight bold
                                            :underline t))))

 ;; ───────────────────────────────────────────────────────────────────────────
 ;; 16. ADDITIONAL PACKAGES
 ;; ───────────────────────────────────────────────────────────────────────────
 ;; which-key
 '(which-key-key-face ((t (:foreground "#00C4B4" :weight bold))))
 '(which-key-separator-face ((t (:foreground "#4A5E5B"))))
 '(which-key-description-face ((t (:foreground "#D8E8E6"))))
 '(which-key-group-description-face ((t (:foreground "#EDD372"))))
 '(which-key-command-description-face ((t (:foreground "#D8E8E6"))))
 ;; treemacs
 '(treemacs-root-face ((t (:foreground "#00C4B4" :weight bold :height 1.1))))
 '(treemacs-directory-face ((t (:foreground "#66DAC6"))))
 '(treemacs-file-face ((t (:foreground "#D8E8E6"))))
 '(treemacs-git-modified-face ((t (:foreground "#EDD372"))))
 '(treemacs-git-added-face ((t (:foreground "#66DAC6"))))
 '(treemacs-git-renamed-face ((t (:foreground "#F2DE9A"))))
 '(treemacs-git-untracked-face ((t (:foreground "#4A5E5B"))))
 ;; flycheck / flymake
 '(flycheck-error ((t (:underline (:color "#E8C84A" :style wave)))))
 '(flycheck-warning ((t (:underline (:color "#EDD372" :style wave)))))
 '(flycheck-info ((t (:underline (:color "#00C4B4" :style wave)))))
 '(flymake-error ((t (:underline (:color "#E8C84A" :style wave)))))
 '(flymake-warning ((t (:underline (:color "#EDD372" :style wave)))))
 '(flymake-note ((t (:underline (:color "#00C4B4" :style wave)))))
 ;; eglot
 '(eglot-highlight-symbol-face ((t (:background "#112830" :weight bold))))
 '(eglot-diagnostic-tag-deprecated-face ((t (:strike-through t :foreground "#4A5E5B"))))
 '(eglot-diagnostic-tag-unnecessary-face ((t (:foreground "#4A5E5B"))))
 ;; show-paren
 '(show-paren-match ((t (:background "#00C4B4" :foreground "#0B1A1E" :weight bold))))
 '(show-paren-mismatch ((t (:background "#E8C84A" :foreground "#0B1A1E" :weight bold))))
 ;; eldoc
 '(eldoc-highlight-function-argument ((t (:foreground "#EDD372" :weight bold))))
 ;; dired
 '(dired-directory ((t (:foreground "#00C4B4" :weight bold))))
 '(dired-symlink ((t (:foreground "#66DAC6" :slant italic))))
 '(dired-flagged ((t (:foreground "#0B1A1E" :background "#E8C84A"))))
 '(dired-marked ((t (:foreground "#0B1A1E" :background "#EDD372"))))
 '(dired-header ((t (:foreground "#00C4B4" :weight bold))))
 ;; eshell
 '(eshell-prompt ((t (:foreground "#00C4B4" :weight bold))))
 '(eshell-ls-directory ((t (:foreground "#66DAC6" :weight bold))))
 '(eshell-ls-executable ((t (:foreground "#EDD372" :weight bold))))
 '(eshell-ls-symlink ((t (:foreground "#33CFB9" :slant italic))))
 '(eshell-ls-unreadable ((t (:foreground "#E8C84A"))))
 )

(provide-theme 'poolrooms-dark)

;;; poolrooms-dark-theme.el ends here
