;;; poolrooms-light-theme.el --- Poolrooms light theme  -*- lexical-binding: t; -*-

;; Author: John Gosset
;; Version: 1.0
;; Keywords: faces themes

;;; Commentary:
;; A light Emacs theme inspired by the poolrooms liminal aesthetic —
;; cream ceramic tile bathed in fluorescent light, aqua water visible
;; through a doorway, the uncanny stillness of an empty institutional pool.
;;
;; Palette:
;;   Tile Cream   #EEF0E8  — primary background (cream ceramic tile)
;;   Tile Shadow  #E0E4DC  — secondary background (mode-line, fringe, grout shadow)
;;   Pool Dark    #1A2E30  — primary foreground (deep pool text)
;;   Grout        #7A8C88  — comments, secondary text (wet grout)
;;
;; Raw pool water teal and fluorescent amber do NOT meet WCAG AA (4.5:1)
;; on Tile Cream (#EEF0E8). Contrast-safe values used for text:
;;   Deep Aqua    #006B62  ~6.2:1  — keywords, links, functions, prompts
;;   Mid Aqua     #008F85  ~4.7:1  — builtins, preprocessors
;;   Aqua Depth   #004D46  ~7.8:1  — variables, visited links
;;   Deep Amber   #7A5500  ~6.5:1  — constants, errors (fluorescent shadow)
;;   Mid Amber    #9C6C00  ~5.0:1  — warnings, strings
;;
;; Pool water teal (#00C4B4) and tints retained for backgrounds (region,
;; isearch, hl-line) where dark foreground text provides the contrast.

;;; Code:

(deftheme poolrooms-light "Poolrooms light theme — cream tile under fluorescent light.")

(custom-theme-set-faces
 'poolrooms-light

 ;; ───────────────────────────────────────────────────────────────────────────
 ;; 1. BASIC
 ;; ───────────────────────────────────────────────────────────────────────────
 '(default ((((type graphic))
             (:background "#EEF0E8" :foreground "#1A2E30"
              :slant normal :weight normal :height 160 :width normal
              :family "JuliaMono"))
            (t
             (:background "#EEF0E8" :foreground "#1A2E30"))))
 '(cursor ((t (:background "#9C6C00"))))
 '(fixed-pitch ((t (:family "Monospace"))))
 '(variable-pitch ((((type w32)) (:foundry "outline" :family "Arial"))
                   (t (:family "Sans Serif"))))

 ;; ───────────────────────────────────────────────────────────────────────────
 ;; 2. UI CHROME
 ;; ───────────────────────────────────────────────────────────────────────────
 '(fringe ((t (:background "#E0E4DC" :foreground "#7A8C88"))))
 '(header-line ((t (:background "#FFFFFF" :foreground "#1A2E30"
                    :box (:line-width 1 :color "#008F85")))))
 '(tooltip ((((class color))
             (:inherit variable-pitch
              :background "#FFFFFF" :foreground "#1A2E30"))
            (t (:inherit variable-pitch))))
 '(mode-line ((t (:background "#FFFFFF" :foreground "#1A2E30"
                  :box (:line-width 1 :color "#008F85" :style nil)))))
 '(mode-line-buffer-id ((t (:foreground "#1A2E30" :weight bold))))
 '(mode-line-emphasis ((t (:foreground "#006B62" :weight bold))))
 '(mode-line-highlight ((((class color) (min-colors 88))
                         (:box (:line-width 2 :color "#008F85" :style released-button)))
                        (t (:inherit highlight))))
 '(mode-line-inactive ((t (:background "#E0E4DC" :foreground "#7A8C88"
                            :box (:line-width 1 :color "#E0E4DC" :style nil)))))
 '(tab-bar ((t (:background "#E0E4DC" :foreground "#7A8C88"))))
 '(tab-bar-tab ((t (:background "#EEF0E8" :foreground "#006B62"
                    :box (:line-width 2 :color "#006B62" :style nil)))))
 '(tab-bar-tab-inactive ((t (:background "#E0E4DC" :foreground "#7A8C88"
                              :box (:line-width 2 :color "#E0E4DC" :style nil)))))

 ;; ───────────────────────────────────────────────────────────────────────────
 ;; 3. MINIBUFFER
 ;; ───────────────────────────────────────────────────────────────────────────
 '(minibuffer-prompt ((t (:foreground "#006B62" :weight bold))))

 ;; ───────────────────────────────────────────────────────────────────────────
 ;; 4. SELECTION / HIGHLIGHTING
 ;; ───────────────────────────────────────────────────────────────────────────
 '(highlight ((t (:background "#C8EDE9" :foreground "#1A2E30" :extend t))))
 '(region ((t (:background "#C8EDE9" :foreground "#1A2E30" :extend t))))
 '(secondary-selection
   ((((class color) (min-colors 88) (background light))
     (:background "#A0E0DA" :extend t))
    (((class color) (min-colors 8) (background light))
     (:foreground "#1A2E30" :background "#C8EDE9" :extend t))
    (t (:inverse-video t))))
 '(shadow ((((class color grayscale) (min-colors 88) (background light))
            (:foreground "#7A8C88"))
           (((class color) (min-colors 8) (background light))
            (:foreground "#7A8C88"))
           (t (:foreground "grey50"))))
 '(hl-line ((t (:background "#E5EBE7" :extend t))))

 ;; ───────────────────────────────────────────────────────────────────────────
 ;; 5. SEARCH
 ;; ───────────────────────────────────────────────────────────────────────────
 '(isearch ((t (:background "#006B62" :foreground "#EEF0E8" :weight bold))))
 '(isearch-fail ((((class color) (min-colors 88) (background light))
                  (:background "#F0D8A0" :foreground "#1A2E30"))
                 (((class color) (min-colors 8))
                  (:background "red" :foreground "white"))
                 (t (:inverse-video t))))
 '(lazy-highlight ((t (:background "#C8EDE9" :foreground "#1A2E30"
                        :underline (:color "#006B62" :style line)))))
 '(match ((((class color) (min-colors 88) (background light))
           (:background "#A0E0DA" :foreground "#1A2E30"))
          (((class color) (min-colors 8) (background light))
           (:background "#C8EDE9" :foreground "#1A2E30"))
          (t (:inverse-video t))))
 '(query-replace ((t (:inherit isearch))))

 ;; ───────────────────────────────────────────────────────────────────────────
 ;; 6. LINKS
 ;; ───────────────────────────────────────────────────────────────────────────
 '(button ((t (:foreground "#006B62" :underline (:color "#006B62" :style line)))))
 '(link ((t (:foreground "#006B62" :underline (:color "#006B62" :style line)))))
 '(link-visited ((default (:inherit link))
                 (((class color) (background light))
                  (:foreground "#004D46"
                   :underline (:color "#004D46" :style line)))))

 ;; ───────────────────────────────────────────────────────────────────────────
 ;; 7. TEXT GLYPHS
 ;; ───────────────────────────────────────────────────────────────────────────
 '(trailing-whitespace ((t (:background "#9C6C00"))))
 '(escape-glyph ((((background light)) (:foreground "#006B62"))
                 (((type pc)) (:foreground "#7A5500"))
                 (t (:foreground "#008F85"))))
 '(homoglyph ((((background light)) (:foreground "#006B62"))
              (((type pc)) (:foreground "#7A5500"))
              (t (:foreground "#008F85"))))

 ;; ───────────────────────────────────────────────────────────────────────────
 ;; 8. NAVIGATION / COMPILATION
 ;; ───────────────────────────────────────────────────────────────────────────
 '(next-error ((t (:inherit region))))
 '(compilation-error ((t (:foreground "#7A5500" :weight bold))))
 '(compilation-warning ((t (:foreground "#9C6C00" :weight bold))))
 '(compilation-info ((t (:foreground "#006B62"))))
 '(compilation-line-number ((t (:foreground "#7A8C88"))))
 '(compilation-column-number ((t (:foreground "#7A8C88"))))
 '(compilation-mode-line-exit ((t (:foreground "#006B62" :weight bold))))
 '(compilation-mode-line-fail ((t (:foreground "#7A5500" :weight bold))))
 '(compilation-mode-line-run ((t (:foreground "#9C6C00"))))

 ;; ───────────────────────────────────────────────────────────────────────────
 ;; 9. FONT-LOCK (SYNTAX)
 ;; ───────────────────────────────────────────────────────────────────────────
 '(font-lock-builtin-face ((t (:foreground "#008F85"))))
 '(font-lock-comment-delimiter-face ((t (:foreground "#7A8C88" :slant italic))))
 '(font-lock-comment-face ((t (:foreground "#7A8C88" :slant italic))))
 '(font-lock-constant-face ((((class color) (min-colors 88) (background light))
                              (:foreground "#7A5500"))
                             (t (:foreground "#7A5500" :weight bold))))
 '(font-lock-doc-face ((t (:foreground "#5A706C"))))
 '(font-lock-doc-markup-face ((t (:foreground "#008F85"))))
 '(font-lock-function-name-face ((t (:foreground "#006B62"))))
 '(font-lock-keyword-face ((t (:foreground "#006B62" :weight bold))))
 '(font-lock-negation-char-face ((t (:foreground "#7A5500" :weight bold))))
 '(font-lock-preprocessor-face ((t (:foreground "#008F85" :slant italic))))
 '(font-lock-regexp-grouping-backslash ((t (:inherit bold))))
 '(font-lock-regexp-grouping-construct ((t (:inherit bold))))
 '(font-lock-string-face ((t (:foreground "#9C6C00"))))
 '(font-lock-type-face ((t (:foreground "#1A2E30" :weight bold))))
 '(font-lock-variable-name-face ((t (:foreground "#004D46"))))
 '(font-lock-warning-face ((t (:foreground "#7A5500" :weight bold))))
 ;; Emacs 29+ additional font-lock faces
 '(font-lock-bracket-face ((t (:foreground "#7A8C88"))))
 '(font-lock-delimiter-face ((t (:foreground "#7A8C88"))))
 '(font-lock-misc-punctuation-face ((t (:foreground "#7A8C88"))))
 '(font-lock-number-face ((t (:foreground "#9C6C00"))))
 '(font-lock-operator-face ((t (:foreground "#1A2E30"))))
 '(font-lock-property-name-face ((t (:foreground "#004D46"))))
 '(font-lock-property-use-face ((t (:foreground "#004D46"))))
 '(font-lock-punctuation-face ((t (:foreground "#7A8C88"))))

 ;; ───────────────────────────────────────────────────────────────────────────
 ;; 10. ORG-MODE
 ;; ───────────────────────────────────────────────────────────────────────────
 '(org-document-title ((t (:foreground "#006B62" :weight bold :height 1.4))))
 '(org-document-info ((t (:foreground "#008F85" :slant italic))))
 '(org-document-info-keyword ((t (:foreground "#7A8C88"))))
 '(org-level-1 ((t (:foreground "#006B62" :weight bold :height 1.3))))
 '(org-level-2 ((t (:foreground "#7A5500" :weight bold :height 1.2))))
 '(org-level-3 ((t (:foreground "#008F85" :weight bold :height 1.1))))
 '(org-level-4 ((t (:foreground "#1A2E30" :weight bold))))
 '(org-level-5 ((t (:foreground "#006B62"))))
 '(org-level-6 ((t (:foreground "#9C6C00"))))
 '(org-level-7 ((t (:foreground "#008F85"))))
 '(org-level-8 ((t (:foreground "#5A706C"))))
 '(org-block ((t (:background "#E5EBE3" :extend t))))
 '(org-block-begin-line ((t (:background "#E0E4DC" :foreground "#7A8C88"
                              :slant italic :extend t))))
 '(org-block-end-line ((t (:background "#E0E4DC" :foreground "#7A8C88"
                            :slant italic :extend t))))
 '(org-code ((t (:foreground "#006B62" :background "#E5EBE3"))))
 '(org-verbatim ((t (:foreground "#008F85"))))
 '(org-table ((t (:foreground "#1A2E30"))))
 '(org-link ((t (:foreground "#006B62" :underline (:color "#006B62" :style line)))))
 '(org-todo ((t (:foreground "#7A5500" :weight bold))))
 '(org-done ((t (:foreground "#006B62" :weight bold))))
 '(org-headline-done ((t (:foreground "#7A8C88" :strike-through t))))
 '(org-date ((t (:foreground "#008F85" :underline t))))
 '(org-warning ((t (:foreground "#7A5500" :weight bold))))
 '(org-special-keyword ((t (:foreground "#7A8C88"))))
 '(org-tag ((t (:foreground "#7A8C88" :weight bold))))
 '(org-checkbox ((t (:foreground "#9C6C00" :weight bold))))
 '(org-formula ((t (:foreground "#9C6C00"))))

 ;; ───────────────────────────────────────────────────────────────────────────
 ;; 11. DIFF / MAGIT
 ;; ───────────────────────────────────────────────────────────────────────────
 '(diff-added ((t (:background "#C0EDE6" :foreground "#004D46" :extend t))))
 '(diff-removed ((t (:background "#F0DFA8" :foreground "#5C3D00" :extend t))))
 '(diff-changed ((t (:background "#E0E4DC" :foreground "#1A2E30" :extend t))))
 '(diff-header ((t (:background "#E0E4DC" :foreground "#7A8C88" :weight bold))))
 '(diff-file-header ((t (:background "#E0E4DC" :foreground "#1A2E30" :weight bold))))
 '(diff-hunk-header ((t (:background "#E5EBE3" :foreground "#008F85"))))
 '(diff-context ((t (:foreground "#7A8C88"))))
 '(magit-section-heading ((t (:foreground "#006B62" :weight bold))))
 '(magit-section-highlight ((t (:background "#E0E4DC"))))
 '(magit-branch-local ((t (:foreground "#7A5500" :weight bold))))
 '(magit-branch-remote ((t (:foreground "#006B62"))))
 '(magit-branch-current ((t (:foreground "#7A5500" :weight bold
                              :box (:line-width 1 :color "#7A5500")))))
 '(magit-tag ((t (:foreground "#9C6C00"))))
 '(magit-hash ((t (:foreground "#7A8C88"))))
 '(magit-diff-added ((t (:background "#C0EDE6" :foreground "#004D46" :extend t))))
 '(magit-diff-removed ((t (:background "#F0DFA8" :foreground "#5C3D00" :extend t))))
 '(magit-diff-added-highlight ((t (:background "#A0E5DC" :foreground "#004D46" :extend t))))
 '(magit-diff-removed-highlight ((t (:background "#E8D090" :foreground "#5C3D00" :extend t))))
 '(magit-diff-context ((t (:foreground "#7A8C88" :extend t))))
 '(magit-diff-context-highlight ((t (:background "#E0E4DC" :foreground "#1A2E30" :extend t))))
 '(magit-diff-hunk-heading ((t (:background "#E0E4DC" :foreground "#7A8C88"))))
 '(magit-diff-hunk-heading-highlight ((t (:background "#E0E4DC" :foreground "#006B62" :weight bold))))
 '(magit-process-ok ((t (:foreground "#006B62" :weight bold))))
 '(magit-process-ng ((t (:foreground "#7A5500" :weight bold))))

 ;; ───────────────────────────────────────────────────────────────────────────
 ;; 12. LINE NUMBERS
 ;; ───────────────────────────────────────────────────────────────────────────
 '(line-number ((t (:background "#EEF0E8" :foreground "#7A8C88"))))
 '(line-number-current-line ((t (:background "#E0E4DC" :foreground "#1A2E30" :weight bold))))
 '(line-number-major-tick ((t (:background "#EEF0E8" :foreground "#006B62"))))
 '(line-number-minor-tick ((t (:background "#EEF0E8" :foreground "#7A8C88"))))

 ;; ───────────────────────────────────────────────────────────────────────────
 ;; 13. COMPLETION (CORFU)
 ;; ───────────────────────────────────────────────────────────────────────────
 '(completions-common-part ((t (:foreground "#006B62" :weight bold))))
 '(completions-first-difference ((t (:foreground "#7A5500" :weight bold))))
 '(completions-annotations ((t (:foreground "#7A8C88" :slant italic))))
 '(corfu-default ((t (:background "#FFFFFF" :foreground "#1A2E30"))))
 '(corfu-current ((t (:background "#006B62" :foreground "#EEF0E8" :weight bold))))
 '(corfu-bar ((t (:background "#006B62"))))
 '(corfu-border ((t (:background "#008F85"))))
 '(corfu-annotations ((t (:foreground "#7A8C88"))))
 '(corfu-deprecated ((t (:foreground "#7A8C88" :strike-through t))))

 ;; ───────────────────────────────────────────────────────────────────────────
 ;; 14. VERTICO / CONSULT / ORDERLESS
 ;; ───────────────────────────────────────────────────────────────────────────
 '(vertico-current ((t (:background "#E0E4DC" :foreground "#1A2E30" :extend t))))
 '(vertico-group-title ((t (:foreground "#7A8C88" :slant italic))))
 '(vertico-group-separator ((t (:foreground "#7A8C88" :strike-through t))))
 '(consult-file ((t (:foreground "#008F85"))))
 '(consult-buffer ((t (:foreground "#1A2E30"))))
 '(consult-grep-context ((t (:foreground "#7A8C88"))))
 '(consult-highlight-match ((t (:foreground "#006B62" :weight bold))))
 '(orderless-match-face-0 ((t (:foreground "#006B62" :weight bold))))
 '(orderless-match-face-1 ((t (:foreground "#7A5500" :weight bold))))
 '(orderless-match-face-2 ((t (:foreground "#008F85" :weight bold))))
 '(orderless-match-face-3 ((t (:foreground "#9C6C00" :weight bold))))

 ;; ───────────────────────────────────────────────────────────────────────────
 ;; 15. RAINBOW DELIMITERS
 ;; Contrast-safe aqua / amber cycle for cream tile backgrounds
 ;; ───────────────────────────────────────────────────────────────────────────
 '(rainbow-delimiters-base-face ((t (:inherit nil))))
 '(rainbow-delimiters-depth-1-face ((t (:inherit rainbow-delimiters-base-face
                                         :foreground "#006B62"))))
 '(rainbow-delimiters-depth-2-face ((t (:inherit rainbow-delimiters-base-face
                                         :foreground "#7A5500"))))
 '(rainbow-delimiters-depth-3-face ((t (:inherit rainbow-delimiters-base-face
                                         :foreground "#008F85"))))
 '(rainbow-delimiters-depth-4-face ((t (:inherit rainbow-delimiters-base-face
                                         :foreground "#9C6C00"))))
 '(rainbow-delimiters-depth-5-face ((t (:inherit rainbow-delimiters-base-face
                                         :foreground "#004D46"))))
 '(rainbow-delimiters-depth-6-face ((t (:inherit rainbow-delimiters-base-face
                                         :foreground "#5C3D00"))))
 '(rainbow-delimiters-depth-7-face ((t (:inherit rainbow-delimiters-base-face
                                         :foreground "#003830"))))
 '(rainbow-delimiters-depth-8-face ((t (:inherit rainbow-delimiters-base-face
                                         :foreground "#7A6030"))))
 '(rainbow-delimiters-depth-9-face ((t (:inherit rainbow-delimiters-base-face
                                         :foreground "#7A8C88"))))
 '(rainbow-delimiters-unmatched-face ((t (:foreground "#EEF0E8"
                                           :background "#7A5500" :weight bold))))
 '(rainbow-delimiters-mismatched-face ((t (:foreground "#EEF0E8"
                                            :background "#7A5500" :weight bold
                                            :underline t))))

 ;; ───────────────────────────────────────────────────────────────────────────
 ;; 16. ADDITIONAL PACKAGES
 ;; ───────────────────────────────────────────────────────────────────────────
 ;; which-key
 '(which-key-key-face ((t (:foreground "#006B62" :weight bold))))
 '(which-key-separator-face ((t (:foreground "#7A8C88"))))
 '(which-key-description-face ((t (:foreground "#1A2E30"))))
 '(which-key-group-description-face ((t (:foreground "#9C6C00"))))
 '(which-key-command-description-face ((t (:foreground "#1A2E30"))))
 ;; treemacs
 '(treemacs-root-face ((t (:foreground "#006B62" :weight bold :height 1.1))))
 '(treemacs-directory-face ((t (:foreground "#008F85"))))
 '(treemacs-file-face ((t (:foreground "#1A2E30"))))
 '(treemacs-git-modified-face ((t (:foreground "#9C6C00"))))
 '(treemacs-git-added-face ((t (:foreground "#006B62"))))
 '(treemacs-git-renamed-face ((t (:foreground "#7A5500"))))
 '(treemacs-git-untracked-face ((t (:foreground "#7A8C88"))))
 ;; flycheck / flymake
 '(flycheck-error ((t (:underline (:color "#7A5500" :style wave)))))
 '(flycheck-warning ((t (:underline (:color "#9C6C00" :style wave)))))
 '(flycheck-info ((t (:underline (:color "#006B62" :style wave)))))
 '(flymake-error ((t (:underline (:color "#7A5500" :style wave)))))
 '(flymake-warning ((t (:underline (:color "#9C6C00" :style wave)))))
 '(flymake-note ((t (:underline (:color "#006B62" :style wave)))))
 ;; eglot
 '(eglot-highlight-symbol-face ((t (:background "#C8EDE9" :weight bold))))
 '(eglot-diagnostic-tag-deprecated-face ((t (:strike-through t :foreground "#7A8C88"))))
 '(eglot-diagnostic-tag-unnecessary-face ((t (:foreground "#7A8C88"))))
 ;; show-paren
 '(show-paren-match ((t (:background "#006B62" :foreground "#EEF0E8" :weight bold))))
 '(show-paren-mismatch ((t (:background "#7A5500" :foreground "#EEF0E8" :weight bold))))
 ;; eldoc
 '(eldoc-highlight-function-argument ((t (:foreground "#7A5500" :weight bold))))
 ;; dired
 '(dired-directory ((t (:foreground "#006B62" :weight bold))))
 '(dired-symlink ((t (:foreground "#008F85" :slant italic))))
 '(dired-flagged ((t (:foreground "#EEF0E8" :background "#7A5500"))))
 '(dired-marked ((t (:foreground "#EEF0E8" :background "#9C6C00"))))
 '(dired-header ((t (:foreground "#006B62" :weight bold))))
 ;; eshell
 '(eshell-prompt ((t (:foreground "#006B62" :weight bold))))
 '(eshell-ls-directory ((t (:foreground "#008F85" :weight bold))))
 '(eshell-ls-executable ((t (:foreground "#9C6C00" :weight bold))))
 '(eshell-ls-symlink ((t (:foreground "#006B62" :slant italic))))
 '(eshell-ls-unreadable ((t (:foreground "#7A5500"))))
 )

(provide-theme 'poolrooms-light)

;;; poolrooms-light-theme.el ends here
