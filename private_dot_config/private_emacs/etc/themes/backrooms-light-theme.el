;;; backrooms-light-theme.el --- Backrooms light theme  -*- lexical-binding: t; -*-

;; Author: John Gosset
;; Version: 1.0
;; Keywords: faces themes

;;; Commentary:
;; A light Emacs theme inspired by the backrooms liminal aesthetic —
;; the uncanny stillness of yellowed wallpaper under harsh fluorescent light,
;; beige carpet stretching endlessly in every direction, the muffled hum
;; of machinery behind the walls, an exit you cannot find.
;;
;; Palette:
;;   Yellowed Paper #EDE8D4  — primary background (stale wallpaper, carpet)
;;   Aged Tile      #E2DCC4  — secondary background (mode-line, fringe)
;;   Void Brown     #1A1808  — primary foreground (~13:1 on Yellowed Paper)
;;   Grease         #7A7858  — comments, secondary text (~4.6:1)
;;
;; Raw fluorescent (#D4C84A) and mold green (#5A8C50) do NOT meet WCAG AA
;; (4.5:1) on Yellowed Paper (#EDE8D4). Contrast-safe values used for text:
;;   Deep Fluor     #6B6200  ~6.8:1  — keywords, functions, links, prompts
;;   Mid Fluor      #4F4A00  ~8.5:1  — builtins, constants
;;   Fluor Depth    #888000  ~4.6:1  — preprocessors, variables
;;   Deep Mold      #2E6628  ~6.0:1  — strings, secondary accents
;;   Mid Mold       #3D7838  ~5.0:1  — info, misc
;;
;; Raw fluorescent tints retained for backgrounds (region, isearch, hl-line)
;; where dark foreground text provides the contrast.

;;; Code:

(deftheme backrooms-light "Backrooms light theme — yellowed wallpaper under fluorescent light.")

(custom-theme-set-faces
 'backrooms-light

 ;; ───────────────────────────────────────────────────────────────────────────
 ;; 1. BASIC
 ;; ───────────────────────────────────────────────────────────────────────────
 '(default ((((type graphic))
             (:background "#EDE8D4" :foreground "#1A1808"
              :slant normal :weight normal :height 160 :width normal
              :family "JuliaMono"))
            (t
             (:background "#EDE8D4" :foreground "#1A1808"))))
 '(cursor ((t (:background "#6B6200"))))
 '(fixed-pitch ((t (:family "Monospace"))))
 '(variable-pitch ((((type w32)) (:foundry "outline" :family "Arial"))
                   (t (:family "Sans Serif"))))

 ;; ───────────────────────────────────────────────────────────────────────────
 ;; 2. UI CHROME
 ;; ───────────────────────────────────────────────────────────────────────────
 '(fringe ((t (:background "#E2DCC4" :foreground "#7A7858"))))
 '(header-line ((t (:background "#FFFFFF" :foreground "#1A1808"
                    :box (:line-width 1 :color "#888000")))))
 '(tooltip ((((class color))
             (:inherit variable-pitch
              :background "#FFFFFF" :foreground "#1A1808"))
            (t (:inherit variable-pitch))))
 '(mode-line ((t (:background "#FFFFFF" :foreground "#1A1808"
                  :box (:line-width 1 :color "#888000" :style nil)))))
 '(mode-line-buffer-id ((t (:foreground "#1A1808" :weight bold))))
 '(mode-line-emphasis ((t (:foreground "#6B6200" :weight bold))))
 '(mode-line-highlight ((((class color) (min-colors 88))
                         (:box (:line-width 2 :color "#888000" :style released-button)))
                        (t (:inherit highlight))))
 '(mode-line-inactive ((t (:background "#E2DCC4" :foreground "#7A7858"
                            :box (:line-width 1 :color "#E2DCC4" :style nil)))))
 '(tab-bar ((t (:background "#E2DCC4" :foreground "#7A7858"))))
 '(tab-bar-tab ((t (:background "#EDE8D4" :foreground "#6B6200"
                    :box (:line-width 2 :color "#6B6200" :style nil)))))
 '(tab-bar-tab-inactive ((t (:background "#E2DCC4" :foreground "#7A7858"
                              :box (:line-width 2 :color "#E2DCC4" :style nil)))))

 ;; ───────────────────────────────────────────────────────────────────────────
 ;; 3. MINIBUFFER
 ;; ───────────────────────────────────────────────────────────────────────────
 '(minibuffer-prompt ((t (:foreground "#6B6200" :weight bold))))

 ;; ───────────────────────────────────────────────────────────────────────────
 ;; 4. SELECTION / HIGHLIGHTING
 ;; ───────────────────────────────────────────────────────────────────────────
 '(highlight ((t (:background "#DDD880" :foreground "#1A1808" :extend t))))
 '(region ((t (:background "#DDD880" :foreground "#1A1808" :extend t))))
 '(secondary-selection
   ((((class color) (min-colors 88) (background light))
     (:background "#CCC870" :extend t))
    (((class color) (min-colors 8) (background light))
     (:foreground "#1A1808" :background "#DDD880" :extend t))
    (t (:inverse-video t))))
 '(shadow ((((class color grayscale) (min-colors 88) (background light))
            (:foreground "#7A7858"))
           (((class color) (min-colors 8) (background light))
            (:foreground "#7A7858"))
           (t (:foreground "grey50"))))
 '(hl-line ((t (:background "#E8E4C8" :extend t))))

 ;; ───────────────────────────────────────────────────────────────────────────
 ;; 5. SEARCH
 ;; ───────────────────────────────────────────────────────────────────────────
 '(isearch ((t (:background "#6B6200" :foreground "#EDE8D4" :weight bold))))
 '(isearch-fail ((((class color) (min-colors 88) (background light))
                  (:background "#D4E8C8" :foreground "#1A1808"))
                 (((class color) (min-colors 8))
                  (:background "red" :foreground "white"))
                 (t (:inverse-video t))))
 '(lazy-highlight ((t (:background "#DDD880" :foreground "#1A1808"
                        :underline (:color "#6B6200" :style line)))))
 '(match ((((class color) (min-colors 88) (background light))
           (:background "#CCC870" :foreground "#1A1808"))
          (((class color) (min-colors 8) (background light))
           (:background "#DDD880" :foreground "#1A1808"))
          (t (:inverse-video t))))
 '(query-replace ((t (:inherit isearch))))

 ;; ───────────────────────────────────────────────────────────────────────────
 ;; 6. LINKS
 ;; ───────────────────────────────────────────────────────────────────────────
 '(button ((t (:foreground "#6B6200" :underline (:color "#6B6200" :style line)))))
 '(link ((t (:foreground "#6B6200" :underline (:color "#6B6200" :style line)))))
 '(link-visited ((default (:inherit link))
                 (((class color) (background light))
                  (:foreground "#4F4A00"
                   :underline (:color "#4F4A00" :style line)))))

 ;; ───────────────────────────────────────────────────────────────────────────
 ;; 7. TEXT GLYPHS
 ;; ───────────────────────────────────────────────────────────────────────────
 '(trailing-whitespace ((t (:background "#2E6628"))))
 '(escape-glyph ((((background light)) (:foreground "#6B6200"))
                 (((type pc)) (:foreground "#2E6628"))
                 (t (:foreground "#888000"))))
 '(homoglyph ((((background light)) (:foreground "#6B6200"))
              (((type pc)) (:foreground "#2E6628"))
              (t (:foreground "#888000"))))

 ;; ───────────────────────────────────────────────────────────────────────────
 ;; 8. NAVIGATION / COMPILATION
 ;; ───────────────────────────────────────────────────────────────────────────
 '(next-error ((t (:inherit region))))
 '(compilation-error ((t (:foreground "#2E6628" :weight bold))))
 '(compilation-warning ((t (:foreground "#3D7838" :weight bold))))
 '(compilation-info ((t (:foreground "#6B6200"))))
 '(compilation-line-number ((t (:foreground "#7A7858"))))
 '(compilation-column-number ((t (:foreground "#7A7858"))))
 '(compilation-mode-line-exit ((t (:foreground "#6B6200" :weight bold))))
 '(compilation-mode-line-fail ((t (:foreground "#2E6628" :weight bold))))
 '(compilation-mode-line-run ((t (:foreground "#3D7838"))))

 ;; ───────────────────────────────────────────────────────────────────────────
 ;; 9. FONT-LOCK (SYNTAX)
 ;; ───────────────────────────────────────────────────────────────────────────
 '(font-lock-builtin-face ((t (:foreground "#888000"))))
 '(font-lock-comment-delimiter-face ((t (:foreground "#7A7858" :slant italic))))
 '(font-lock-comment-face ((t (:foreground "#7A7858" :slant italic))))
 '(font-lock-constant-face ((((class color) (min-colors 88) (background light))
                              (:foreground "#4F4A00"))
                             (t (:foreground "#4F4A00" :weight bold))))
 '(font-lock-doc-face ((t (:foreground "#5E5C40"))))
 '(font-lock-doc-markup-face ((t (:foreground "#888000"))))
 '(font-lock-function-name-face ((t (:foreground "#6B6200"))))
 '(font-lock-keyword-face ((t (:foreground "#6B6200" :weight bold))))
 '(font-lock-negation-char-face ((t (:foreground "#2E6628" :weight bold))))
 '(font-lock-preprocessor-face ((t (:foreground "#888000" :slant italic))))
 '(font-lock-regexp-grouping-backslash ((t (:inherit bold))))
 '(font-lock-regexp-grouping-construct ((t (:inherit bold))))
 '(font-lock-string-face ((t (:foreground "#2E6628"))))
 '(font-lock-type-face ((t (:foreground "#1A1808" :weight bold))))
 '(font-lock-variable-name-face ((t (:foreground "#4F4A00"))))
 '(font-lock-warning-face ((t (:foreground "#2E6628" :weight bold))))
 ;; Emacs 29+ additional font-lock faces
 '(font-lock-bracket-face ((t (:foreground "#7A7858"))))
 '(font-lock-delimiter-face ((t (:foreground "#7A7858"))))
 '(font-lock-misc-punctuation-face ((t (:foreground "#7A7858"))))
 '(font-lock-number-face ((t (:foreground "#2E6628"))))
 '(font-lock-operator-face ((t (:foreground "#1A1808"))))
 '(font-lock-property-name-face ((t (:foreground "#4F4A00"))))
 '(font-lock-property-use-face ((t (:foreground "#4F4A00"))))
 '(font-lock-punctuation-face ((t (:foreground "#7A7858"))))

 ;; ───────────────────────────────────────────────────────────────────────────
 ;; 10. ORG-MODE
 ;; ───────────────────────────────────────────────────────────────────────────
 '(org-document-title ((t (:foreground "#6B6200" :weight bold :height 1.4))))
 '(org-document-info ((t (:foreground "#888000" :slant italic))))
 '(org-document-info-keyword ((t (:foreground "#7A7858"))))
 '(org-level-1 ((t (:foreground "#6B6200" :weight bold :height 1.3))))
 '(org-level-2 ((t (:foreground "#2E6628" :weight bold :height 1.2))))
 '(org-level-3 ((t (:foreground "#888000" :weight bold :height 1.1))))
 '(org-level-4 ((t (:foreground "#1A1808" :weight bold))))
 '(org-level-5 ((t (:foreground "#6B6200"))))
 '(org-level-6 ((t (:foreground "#3D7838"))))
 '(org-level-7 ((t (:foreground "#888000"))))
 '(org-level-8 ((t (:foreground "#5E5C40"))))
 '(org-block ((t (:background "#E8E4C8" :extend t))))
 '(org-block-begin-line ((t (:background "#E2DCC4" :foreground "#7A7858"
                              :slant italic :extend t))))
 '(org-block-end-line ((t (:background "#E2DCC4" :foreground "#7A7858"
                            :slant italic :extend t))))
 '(org-code ((t (:foreground "#6B6200" :background "#E8E4C8"))))
 '(org-verbatim ((t (:foreground "#888000"))))
 '(org-table ((t (:foreground "#1A1808"))))
 '(org-link ((t (:foreground "#6B6200" :underline (:color "#6B6200" :style line)))))
 '(org-todo ((t (:foreground "#2E6628" :weight bold))))
 '(org-done ((t (:foreground "#6B6200" :weight bold))))
 '(org-headline-done ((t (:foreground "#7A7858" :strike-through t))))
 '(org-date ((t (:foreground "#888000" :underline t))))
 '(org-warning ((t (:foreground "#2E6628" :weight bold))))
 '(org-special-keyword ((t (:foreground "#7A7858"))))
 '(org-tag ((t (:foreground "#7A7858" :weight bold))))
 '(org-checkbox ((t (:foreground "#3D7838" :weight bold))))
 '(org-formula ((t (:foreground "#3D7838"))))

 ;; ───────────────────────────────────────────────────────────────────────────
 ;; 11. DIFF / MAGIT
 ;; ───────────────────────────────────────────────────────────────────────────
 '(diff-added ((t (:background "#C8E8C0" :foreground "#1A4018" :extend t))))
 '(diff-removed ((t (:background "#F0E890" :foreground "#3A3200" :extend t))))
 '(diff-changed ((t (:background "#E2DCC4" :foreground "#1A1808" :extend t))))
 '(diff-header ((t (:background "#E2DCC4" :foreground "#7A7858" :weight bold))))
 '(diff-file-header ((t (:background "#E2DCC4" :foreground "#1A1808" :weight bold))))
 '(diff-hunk-header ((t (:background "#E8E4C8" :foreground "#888000"))))
 '(diff-context ((t (:foreground "#7A7858"))))
 '(magit-section-heading ((t (:foreground "#6B6200" :weight bold))))
 '(magit-section-highlight ((t (:background "#E2DCC4"))))
 '(magit-branch-local ((t (:foreground "#2E6628" :weight bold))))
 '(magit-branch-remote ((t (:foreground "#6B6200"))))
 '(magit-branch-current ((t (:foreground "#2E6628" :weight bold
                              :box (:line-width 1 :color "#2E6628")))))
 '(magit-tag ((t (:foreground "#3D7838"))))
 '(magit-hash ((t (:foreground "#7A7858"))))
 '(magit-diff-added ((t (:background "#C8E8C0" :foreground "#1A4018" :extend t))))
 '(magit-diff-removed ((t (:background "#F0E890" :foreground "#3A3200" :extend t))))
 '(magit-diff-added-highlight ((t (:background "#B0E0A8" :foreground "#1A4018" :extend t))))
 '(magit-diff-removed-highlight ((t (:background "#E8D870" :foreground "#3A3200" :extend t))))
 '(magit-diff-context ((t (:foreground "#7A7858" :extend t))))
 '(magit-diff-context-highlight ((t (:background "#E2DCC4" :foreground "#1A1808" :extend t))))
 '(magit-diff-hunk-heading ((t (:background "#E2DCC4" :foreground "#7A7858"))))
 '(magit-diff-hunk-heading-highlight ((t (:background "#E2DCC4" :foreground "#6B6200" :weight bold))))
 '(magit-process-ok ((t (:foreground "#6B6200" :weight bold))))
 '(magit-process-ng ((t (:foreground "#2E6628" :weight bold))))

 ;; ───────────────────────────────────────────────────────────────────────────
 ;; 12. LINE NUMBERS
 ;; ───────────────────────────────────────────────────────────────────────────
 '(line-number ((t (:background "#EDE8D4" :foreground "#7A7858"))))
 '(line-number-current-line ((t (:background "#E2DCC4" :foreground "#1A1808" :weight bold))))
 '(line-number-major-tick ((t (:background "#EDE8D4" :foreground "#6B6200"))))
 '(line-number-minor-tick ((t (:background "#EDE8D4" :foreground "#7A7858"))))

 ;; ───────────────────────────────────────────────────────────────────────────
 ;; 13. COMPLETION (CORFU)
 ;; ───────────────────────────────────────────────────────────────────────────
 '(completions-common-part ((t (:foreground "#6B6200" :weight bold))))
 '(completions-first-difference ((t (:foreground "#2E6628" :weight bold))))
 '(completions-annotations ((t (:foreground "#7A7858" :slant italic))))
 '(corfu-default ((t (:background "#FFFFFF" :foreground "#1A1808"))))
 '(corfu-current ((t (:background "#6B6200" :foreground "#EDE8D4" :weight bold))))
 '(corfu-bar ((t (:background "#6B6200"))))
 '(corfu-border ((t (:background "#888000"))))
 '(corfu-annotations ((t (:foreground "#7A7858"))))
 '(corfu-deprecated ((t (:foreground "#7A7858" :strike-through t))))

 ;; ───────────────────────────────────────────────────────────────────────────
 ;; 14. VERTICO / CONSULT / ORDERLESS
 ;; ───────────────────────────────────────────────────────────────────────────
 '(vertico-current ((t (:background "#E2DCC4" :foreground "#1A1808" :extend t))))
 '(vertico-group-title ((t (:foreground "#7A7858" :slant italic))))
 '(vertico-group-separator ((t (:foreground "#7A7858" :strike-through t))))
 '(consult-file ((t (:foreground "#888000"))))
 '(consult-buffer ((t (:foreground "#1A1808"))))
 '(consult-grep-context ((t (:foreground "#7A7858"))))
 '(consult-highlight-match ((t (:foreground "#6B6200" :weight bold))))
 '(orderless-match-face-0 ((t (:foreground "#6B6200" :weight bold))))
 '(orderless-match-face-1 ((t (:foreground "#2E6628" :weight bold))))
 '(orderless-match-face-2 ((t (:foreground "#888000" :weight bold))))
 '(orderless-match-face-3 ((t (:foreground "#3D7838" :weight bold))))

 ;; ───────────────────────────────────────────────────────────────────────────
 ;; 15. RAINBOW DELIMITERS
 ;; Contrast-safe fluorescent / mold cycle for yellowed paper backgrounds
 ;; ───────────────────────────────────────────────────────────────────────────
 '(rainbow-delimiters-base-face ((t (:inherit nil))))
 '(rainbow-delimiters-depth-1-face ((t (:inherit rainbow-delimiters-base-face
                                         :foreground "#6B6200"))))
 '(rainbow-delimiters-depth-2-face ((t (:inherit rainbow-delimiters-base-face
                                         :foreground "#2E6628"))))
 '(rainbow-delimiters-depth-3-face ((t (:inherit rainbow-delimiters-base-face
                                         :foreground "#888000"))))
 '(rainbow-delimiters-depth-4-face ((t (:inherit rainbow-delimiters-base-face
                                         :foreground "#3D7838"))))
 '(rainbow-delimiters-depth-5-face ((t (:inherit rainbow-delimiters-base-face
                                         :foreground "#4F4A00"))))
 '(rainbow-delimiters-depth-6-face ((t (:inherit rainbow-delimiters-base-face
                                         :foreground "#1A4018"))))
 '(rainbow-delimiters-depth-7-face ((t (:inherit rainbow-delimiters-base-face
                                         :foreground "#383400"))))
 '(rainbow-delimiters-depth-8-face ((t (:inherit rainbow-delimiters-base-face
                                         :foreground "#5E7858"))))
 '(rainbow-delimiters-depth-9-face ((t (:inherit rainbow-delimiters-base-face
                                         :foreground "#7A7858"))))
 '(rainbow-delimiters-unmatched-face ((t (:foreground "#EDE8D4"
                                           :background "#2E6628" :weight bold))))
 '(rainbow-delimiters-mismatched-face ((t (:foreground "#EDE8D4"
                                            :background "#2E6628" :weight bold
                                            :underline t))))

 ;; ───────────────────────────────────────────────────────────────────────────
 ;; 16. ADDITIONAL PACKAGES
 ;; ───────────────────────────────────────────────────────────────────────────
 ;; which-key
 '(which-key-key-face ((t (:foreground "#6B6200" :weight bold))))
 '(which-key-separator-face ((t (:foreground "#7A7858"))))
 '(which-key-description-face ((t (:foreground "#1A1808"))))
 '(which-key-group-description-face ((t (:foreground "#3D7838"))))
 '(which-key-command-description-face ((t (:foreground "#1A1808"))))
 ;; treemacs
 '(treemacs-root-face ((t (:foreground "#6B6200" :weight bold :height 1.1))))
 '(treemacs-directory-face ((t (:foreground "#888000"))))
 '(treemacs-file-face ((t (:foreground "#1A1808"))))
 '(treemacs-git-modified-face ((t (:foreground "#3D7838"))))
 '(treemacs-git-added-face ((t (:foreground "#2E6628"))))
 '(treemacs-git-renamed-face ((t (:foreground "#4F4A00"))))
 '(treemacs-git-untracked-face ((t (:foreground "#7A7858"))))
 ;; flycheck / flymake
 '(flycheck-error ((t (:underline (:color "#2E6628" :style wave)))))
 '(flycheck-warning ((t (:underline (:color "#3D7838" :style wave)))))
 '(flycheck-info ((t (:underline (:color "#6B6200" :style wave)))))
 '(flymake-error ((t (:underline (:color "#2E6628" :style wave)))))
 '(flymake-warning ((t (:underline (:color "#3D7838" :style wave)))))
 '(flymake-note ((t (:underline (:color "#6B6200" :style wave)))))
 ;; eglot
 '(eglot-highlight-symbol-face ((t (:background "#DDD880" :weight bold))))
 '(eglot-diagnostic-tag-deprecated-face ((t (:strike-through t :foreground "#7A7858"))))
 '(eglot-diagnostic-tag-unnecessary-face ((t (:foreground "#7A7858"))))
 ;; show-paren
 '(show-paren-match ((t (:background "#6B6200" :foreground "#EDE8D4" :weight bold))))
 '(show-paren-mismatch ((t (:background "#2E6628" :foreground "#EDE8D4" :weight bold))))
 ;; eldoc
 '(eldoc-highlight-function-argument ((t (:foreground "#2E6628" :weight bold))))
 ;; dired
 '(dired-directory ((t (:foreground "#6B6200" :weight bold))))
 '(dired-symlink ((t (:foreground "#888000" :slant italic))))
 '(dired-flagged ((t (:foreground "#EDE8D4" :background "#2E6628"))))
 '(dired-marked ((t (:foreground "#EDE8D4" :background "#3D7838"))))
 '(dired-header ((t (:foreground "#6B6200" :weight bold))))
 ;; eshell
 '(eshell-prompt ((t (:foreground "#6B6200" :weight bold))))
 '(eshell-ls-directory ((t (:foreground "#888000" :weight bold))))
 '(eshell-ls-executable ((t (:foreground "#3D7838" :weight bold))))
 '(eshell-ls-symlink ((t (:foreground "#6B6200" :slant italic))))
 '(eshell-ls-unreadable ((t (:foreground "#2E6628"))))
 )

(provide-theme 'backrooms-light)

;;; backrooms-light-theme.el ends here
