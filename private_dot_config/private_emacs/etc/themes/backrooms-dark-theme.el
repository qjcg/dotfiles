;;; backrooms-dark-theme.el --- Backrooms dark theme  -*- lexical-binding: t; -*-

;; Author: John Gosset
;; Version: 1.0
;; Keywords: faces themes

;;; Commentary:
;; A dark Emacs theme inspired by the backrooms liminal aesthetic —
;; infinite empty office corridors lit by flickering fluorescent tubes,
;; yellowed carpet stretching into the void, moist off-white wallpaper,
;; the hum of hidden machinery, no exits.
;;
;; Palette:
;;   Void Brown   #0D0C08  — primary background (abyss between rooms)
;;   Shadow Beige #1A1910  — secondary background (mode-line, fringe)
;;   Stale White  #E8E4D4  — primary foreground (old paper, dirty ceiling tile)
;;   Fluorescent  #D4C84A  — primary accent (sickly yellow fluorescent hum)
;;   Fluor 80%    #DAD168  — builtins, preprocessors
;;   Fluor 60%    #E0DA86  — variables, lazy-highlight
;;   Fluor 40%    #E8E3A8  — types
;;   Fluor 20%    #F0ECC8  — background highlights
;;   Mold Green   #5A8C50  — secondary accent (damp patch on the wall)
;;   Mold 80%     #6FA364  — strings, constants
;;   Mold 60%     #86BA7A  — misc secondary
;;   Grease       #4A4830  — comments, secondary text (stained grout, old carpet)

;;; Code:

(deftheme backrooms-dark "Backrooms dark theme — infinite fluorescent corridors.")

(custom-theme-set-faces
 'backrooms-dark

 ;; ───────────────────────────────────────────────────────────────────────────
 ;; 1. BASIC
 ;; ───────────────────────────────────────────────────────────────────────────
 '(default ((((type graphic))
             (:background "#0D0C08" :foreground "#E8E4D4"
              :slant normal :weight normal :height 160 :width normal
              :family "JuliaMono"))
            (t
             (:background "#0D0C08" :foreground "#E8E4D4"))))
 '(cursor ((t (:background "#D4C84A"))))
 '(fixed-pitch ((t (:family "Monospace"))))
 '(variable-pitch ((((type w32)) (:foundry "outline" :family "Arial"))
                   (t (:family "Sans Serif"))))

 ;; ───────────────────────────────────────────────────────────────────────────
 ;; 2. UI CHROME
 ;; ───────────────────────────────────────────────────────────────────────────
 '(fringe ((t (:background "#1A1910" :foreground "#4A4830"))))
 '(header-line ((t (:background "#1A1910" :foreground "#E8E4D4"
                    :box (:line-width 1 :color "#D4C84A")))))
 '(tooltip ((((class color))
             (:inherit variable-pitch
              :background "#1A1910" :foreground "#E8E4D4"))
            (t (:inherit variable-pitch))))
 '(mode-line ((t (:background "#1A1910" :foreground "#E0DA86"
                  :box (:line-width 1 :color "#D4C84A" :style nil)))))
 '(mode-line-buffer-id ((t (:foreground "#E8E4D4" :weight bold))))
 '(mode-line-emphasis ((t (:foreground "#D4C84A" :weight bold))))
 '(mode-line-highlight ((((class color) (min-colors 88))
                         (:box (:line-width 2 :color "#D4C84A" :style released-button)))
                        (t (:inherit highlight))))
 '(mode-line-inactive ((t (:background "#1A1910" :foreground "#4A4830"
                            :box (:line-width 1 :color "#1A1910" :style nil)))))
 '(tab-bar ((t (:background "#1A1910" :foreground "#4A4830"))))
 '(tab-bar-tab ((t (:background "#0D0C08" :foreground "#D4C84A"
                    :box (:line-width 2 :color "#D4C84A" :style nil)))))
 '(tab-bar-tab-inactive ((t (:background "#1A1910" :foreground "#4A4830"
                              :box (:line-width 2 :color "#1A1910" :style nil)))))

 ;; ───────────────────────────────────────────────────────────────────────────
 ;; 3. MINIBUFFER
 ;; ───────────────────────────────────────────────────────────────────────────
 '(minibuffer-prompt ((t (:foreground "#D4C84A" :weight bold))))

 ;; ───────────────────────────────────────────────────────────────────────────
 ;; 4. SELECTION / HIGHLIGHTING
 ;; ───────────────────────────────────────────────────────────────────────────
 '(highlight ((t (:background "#1A1910" :foreground "#E8E4D4" :extend t))))
 '(region ((t (:background "#2C2A18" :foreground "#E8E4D4" :extend t))))
 '(secondary-selection
   ((((class color) (min-colors 88) (background dark))
     (:background "#353210" :extend t))
    (((class color) (min-colors 8) (background dark))
     (:foreground "#E8E4D4" :background "#1A1910" :extend t))
    (t (:inverse-video t))))
 '(shadow ((((class color grayscale) (min-colors 88) (background dark))
            (:foreground "#4A4830"))
           (((class color) (min-colors 8) (background dark))
            (:foreground "#4A4830"))
           (t (:foreground "grey70"))))
 '(hl-line ((t (:background "#1A1910" :extend t))))

 ;; ───────────────────────────────────────────────────────────────────────────
 ;; 5. SEARCH
 ;; ───────────────────────────────────────────────────────────────────────────
 '(isearch ((t (:background "#D4C84A" :foreground "#0D0C08" :weight bold))))
 '(isearch-fail ((((class color) (min-colors 88) (background dark))
                  (:background "#3A1E00" :foreground "#E8E4D4"))
                 (((class color) (min-colors 8))
                  (:background "red" :foreground "white"))
                 (t (:inverse-video t))))
 '(lazy-highlight ((t (:background "#1A1910" :foreground "#E0DA86"
                        :underline (:color "#E0DA86" :style line)))))
 '(match ((((class color) (min-colors 88) (background dark))
           (:background "#353210" :foreground "#E8E4D4"))
          (((class color) (min-colors 8) (background dark))
           (:background "#1A1910" :foreground "#E8E4D4"))
          (t (:inverse-video t))))
 '(query-replace ((t (:inherit isearch))))

 ;; ───────────────────────────────────────────────────────────────────────────
 ;; 6. LINKS
 ;; ───────────────────────────────────────────────────────────────────────────
 '(button ((t (:foreground "#D4C84A" :underline (:color "#D4C84A" :style line)))))
 '(link ((t (:foreground "#D4C84A" :underline (:color "#D4C84A" :style line)))))
 '(link-visited ((default (:inherit link))
                 (((class color) (background dark))
                  (:foreground "#E0DA86"
                   :underline (:color "#E0DA86" :style line)))))

 ;; ───────────────────────────────────────────────────────────────────────────
 ;; 7. TEXT GLYPHS
 ;; ───────────────────────────────────────────────────────────────────────────
 '(trailing-whitespace ((t (:background "#5A8C50"))))
 '(escape-glyph ((((background dark)) (:foreground "#E0DA86"))
                 (((type pc)) (:foreground "#6FA364"))
                 (t (:foreground "#B0A830"))))
 '(homoglyph ((((background dark)) (:foreground "#E0DA86"))
              (((type pc)) (:foreground "#6FA364"))
              (t (:foreground "#B0A830"))))

 ;; ───────────────────────────────────────────────────────────────────────────
 ;; 8. NAVIGATION / COMPILATION
 ;; ───────────────────────────────────────────────────────────────────────────
 '(next-error ((t (:inherit region))))
 '(compilation-error ((t (:foreground "#5A8C50" :weight bold))))
 '(compilation-warning ((t (:foreground "#6FA364" :weight bold))))
 '(compilation-info ((t (:foreground "#D4C84A"))))
 '(compilation-line-number ((t (:foreground "#4A4830"))))
 '(compilation-column-number ((t (:foreground "#4A4830"))))
 '(compilation-mode-line-exit ((t (:foreground "#D4C84A" :weight bold))))
 '(compilation-mode-line-fail ((t (:foreground "#5A8C50" :weight bold))))
 '(compilation-mode-line-run ((t (:foreground "#6FA364"))))

 ;; ───────────────────────────────────────────────────────────────────────────
 ;; 9. FONT-LOCK (SYNTAX)
 ;; ───────────────────────────────────────────────────────────────────────────
 '(font-lock-builtin-face ((t (:foreground "#DAD168"))))
 '(font-lock-comment-delimiter-face ((t (:foreground "#4A4830" :slant italic))))
 '(font-lock-comment-face ((t (:foreground "#4A4830" :slant italic))))
 '(font-lock-constant-face ((((class color) (min-colors 88) (background dark))
                              (:foreground "#6FA364"))
                             (t (:foreground "#6FA364" :weight bold))))
 '(font-lock-doc-face ((t (:foreground "#7A7850"))))
 '(font-lock-doc-markup-face ((t (:foreground "#E0DA86"))))
 '(font-lock-function-name-face ((t (:foreground "#D4C84A"))))
 '(font-lock-keyword-face ((t (:foreground "#D4C84A" :weight bold))))
 '(font-lock-negation-char-face ((t (:foreground "#5A8C50" :weight bold))))
 '(font-lock-preprocessor-face ((t (:foreground "#DAD168" :slant italic))))
 '(font-lock-regexp-grouping-backslash ((t (:inherit bold))))
 '(font-lock-regexp-grouping-construct ((t (:inherit bold))))
 '(font-lock-string-face ((t (:foreground "#86BA7A"))))
 '(font-lock-type-face ((t (:foreground "#E8E3A8" :weight bold))))
 '(font-lock-variable-name-face ((t (:foreground "#E0DA86"))))
 '(font-lock-warning-face ((t (:foreground "#5A8C50" :weight bold))))
 ;; Emacs 29+ additional font-lock faces
 '(font-lock-bracket-face ((t (:foreground "#4A4830"))))
 '(font-lock-delimiter-face ((t (:foreground "#4A4830"))))
 '(font-lock-misc-punctuation-face ((t (:foreground "#4A4830"))))
 '(font-lock-number-face ((t (:foreground "#86BA7A"))))
 '(font-lock-operator-face ((t (:foreground "#E8E4D4"))))
 '(font-lock-property-name-face ((t (:foreground "#E0DA86"))))
 '(font-lock-property-use-face ((t (:foreground "#E0DA86"))))
 '(font-lock-punctuation-face ((t (:foreground "#4A4830"))))

 ;; ───────────────────────────────────────────────────────────────────────────
 ;; 10. ORG-MODE
 ;; ───────────────────────────────────────────────────────────────────────────
 '(org-document-title ((t (:foreground "#D4C84A" :weight bold :height 1.4))))
 '(org-document-info ((t (:foreground "#E0DA86" :slant italic))))
 '(org-document-info-keyword ((t (:foreground "#4A4830"))))
 '(org-level-1 ((t (:foreground "#D4C84A" :weight bold :height 1.3))))
 '(org-level-2 ((t (:foreground "#5A8C50" :weight bold :height 1.2))))
 '(org-level-3 ((t (:foreground "#E0DA86" :weight bold :height 1.1))))
 '(org-level-4 ((t (:foreground "#6FA364" :weight bold))))
 '(org-level-5 ((t (:foreground "#DAD168"))))
 '(org-level-6 ((t (:foreground "#86BA7A"))))
 '(org-level-7 ((t (:foreground "#E8E3A8"))))
 '(org-level-8 ((t (:foreground "#F0ECC8"))))
 '(org-block ((t (:background "#080806" :extend t))))
 '(org-block-begin-line ((t (:background "#1A1910" :foreground "#4A4830"
                              :slant italic :extend t))))
 '(org-block-end-line ((t (:background "#1A1910" :foreground "#4A4830"
                            :slant italic :extend t))))
 '(org-code ((t (:foreground "#E0DA86" :background "#080806"))))
 '(org-verbatim ((t (:foreground "#E8E3A8"))))
 '(org-table ((t (:foreground "#E8E4D4"))))
 '(org-link ((t (:foreground "#D4C84A" :underline (:color "#D4C84A" :style line)))))
 '(org-todo ((t (:foreground "#5A8C50" :weight bold))))
 '(org-done ((t (:foreground "#D4C84A" :weight bold))))
 '(org-headline-done ((t (:foreground "#4A4830" :strike-through t))))
 '(org-date ((t (:foreground "#E0DA86" :underline t))))
 '(org-warning ((t (:foreground "#5A8C50" :weight bold))))
 '(org-special-keyword ((t (:foreground "#4A4830"))))
 '(org-tag ((t (:foreground "#4A4830" :weight bold))))
 '(org-checkbox ((t (:foreground "#6FA364" :weight bold))))
 '(org-formula ((t (:foreground "#86BA7A"))))

 ;; ───────────────────────────────────────────────────────────────────────────
 ;; 11. DIFF / MAGIT
 ;; ───────────────────────────────────────────────────────────────────────────
 '(diff-added ((t (:background "#0A1808" :foreground "#86BA7A" :extend t))))
 '(diff-removed ((t (:background "#251E00" :foreground "#DAD168" :extend t))))
 '(diff-changed ((t (:background "#1A1910" :foreground "#E8E4D4" :extend t))))
 '(diff-header ((t (:background "#1A1910" :foreground "#4A4830" :weight bold))))
 '(diff-file-header ((t (:background "#1A1910" :foreground "#E8E4D4" :weight bold))))
 '(diff-hunk-header ((t (:background "#080806" :foreground "#E0DA86"))))
 '(diff-context ((t (:foreground "#4A4830"))))
 '(magit-section-heading ((t (:foreground "#D4C84A" :weight bold))))
 '(magit-section-highlight ((t (:background "#1A1910"))))
 '(magit-branch-local ((t (:foreground "#5A8C50" :weight bold))))
 '(magit-branch-remote ((t (:foreground "#6FA364"))))
 '(magit-branch-current ((t (:foreground "#5A8C50" :weight bold
                              :box (:line-width 1 :color "#5A8C50")))))
 '(magit-tag ((t (:foreground "#86BA7A"))))
 '(magit-hash ((t (:foreground "#4A4830"))))
 '(magit-diff-added ((t (:background "#0A1808" :foreground "#86BA7A" :extend t))))
 '(magit-diff-removed ((t (:background "#251E00" :foreground "#DAD168" :extend t))))
 '(magit-diff-added-highlight ((t (:background "#142210" :foreground "#86BA7A" :extend t))))
 '(magit-diff-removed-highlight ((t (:background "#352C00" :foreground "#DAD168" :extend t))))
 '(magit-diff-context ((t (:foreground "#4A4830" :extend t))))
 '(magit-diff-context-highlight ((t (:background "#1A1910" :foreground "#E8E4D4" :extend t))))
 '(magit-diff-hunk-heading ((t (:background "#1A1910" :foreground "#4A4830"))))
 '(magit-diff-hunk-heading-highlight ((t (:background "#1A1910" :foreground "#E0DA86" :weight bold))))
 '(magit-process-ok ((t (:foreground "#D4C84A" :weight bold))))
 '(magit-process-ng ((t (:foreground "#5A8C50" :weight bold))))

 ;; ───────────────────────────────────────────────────────────────────────────
 ;; 12. LINE NUMBERS
 ;; ───────────────────────────────────────────────────────────────────────────
 '(line-number ((t (:background "#0D0C08" :foreground "#4A4830"))))
 '(line-number-current-line ((t (:background "#1A1910" :foreground "#E8E4D4" :weight bold))))
 '(line-number-major-tick ((t (:background "#0D0C08" :foreground "#DAD168"))))
 '(line-number-minor-tick ((t (:background "#0D0C08" :foreground "#4A4830"))))

 ;; ───────────────────────────────────────────────────────────────────────────
 ;; 13. COMPLETION (CORFU)
 ;; ───────────────────────────────────────────────────────────────────────────
 '(completions-common-part ((t (:foreground "#D4C84A" :weight bold))))
 '(completions-first-difference ((t (:foreground "#5A8C50" :weight bold))))
 '(completions-annotations ((t (:foreground "#4A4830" :slant italic))))
 '(corfu-default ((t (:background "#1A1910" :foreground "#E8E4D4"))))
 '(corfu-current ((t (:background "#D4C84A" :foreground "#0D0C08" :weight bold))))
 '(corfu-bar ((t (:background "#D4C84A"))))
 '(corfu-border ((t (:background "#DAD168"))))
 '(corfu-annotations ((t (:foreground "#4A4830"))))
 '(corfu-deprecated ((t (:foreground "#4A4830" :strike-through t))))

 ;; ───────────────────────────────────────────────────────────────────────────
 ;; 14. VERTICO / CONSULT / ORDERLESS
 ;; ───────────────────────────────────────────────────────────────────────────
 '(vertico-current ((t (:background "#1A1910" :foreground "#E8E4D4" :extend t))))
 '(vertico-group-title ((t (:foreground "#4A4830" :slant italic))))
 '(vertico-group-separator ((t (:foreground "#4A4830" :strike-through t))))
 '(consult-file ((t (:foreground "#E0DA86"))))
 '(consult-buffer ((t (:foreground "#E8E4D4"))))
 '(consult-grep-context ((t (:foreground "#4A4830"))))
 '(consult-highlight-match ((t (:foreground "#D4C84A" :weight bold))))
 '(orderless-match-face-0 ((t (:foreground "#D4C84A" :weight bold))))
 '(orderless-match-face-1 ((t (:foreground "#5A8C50" :weight bold))))
 '(orderless-match-face-2 ((t (:foreground "#E0DA86" :weight bold))))
 '(orderless-match-face-3 ((t (:foreground "#6FA364" :weight bold))))

 ;; ───────────────────────────────────────────────────────────────────────────
 ;; 15. RAINBOW DELIMITERS
 ;; Alternating fluorescent yellow / mold green; grease as neutral depth-9
 ;; ───────────────────────────────────────────────────────────────────────────
 '(rainbow-delimiters-base-face ((t (:inherit nil))))
 '(rainbow-delimiters-depth-1-face ((t (:inherit rainbow-delimiters-base-face
                                         :foreground "#D4C84A"))))
 '(rainbow-delimiters-depth-2-face ((t (:inherit rainbow-delimiters-base-face
                                         :foreground "#5A8C50"))))
 '(rainbow-delimiters-depth-3-face ((t (:inherit rainbow-delimiters-base-face
                                         :foreground "#E0DA86"))))
 '(rainbow-delimiters-depth-4-face ((t (:inherit rainbow-delimiters-base-face
                                         :foreground "#6FA364"))))
 '(rainbow-delimiters-depth-5-face ((t (:inherit rainbow-delimiters-base-face
                                         :foreground "#DAD168"))))
 '(rainbow-delimiters-depth-6-face ((t (:inherit rainbow-delimiters-base-face
                                         :foreground "#86BA7A"))))
 '(rainbow-delimiters-depth-7-face ((t (:inherit rainbow-delimiters-base-face
                                         :foreground "#E8E3A8"))))
 '(rainbow-delimiters-depth-8-face ((t (:inherit rainbow-delimiters-base-face
                                         :foreground "#F0ECC8"))))
 '(rainbow-delimiters-depth-9-face ((t (:inherit rainbow-delimiters-base-face
                                         :foreground "#4A4830"))))
 '(rainbow-delimiters-unmatched-face ((t (:foreground "#0D0C08"
                                           :background "#5A8C50" :weight bold))))
 '(rainbow-delimiters-mismatched-face ((t (:foreground "#0D0C08"
                                            :background "#5A8C50" :weight bold
                                            :underline t))))

 ;; ───────────────────────────────────────────────────────────────────────────
 ;; 16. ADDITIONAL PACKAGES
 ;; ───────────────────────────────────────────────────────────────────────────
 ;; which-key
 '(which-key-key-face ((t (:foreground "#D4C84A" :weight bold))))
 '(which-key-separator-face ((t (:foreground "#4A4830"))))
 '(which-key-description-face ((t (:foreground "#E8E4D4"))))
 '(which-key-group-description-face ((t (:foreground "#6FA364"))))
 '(which-key-command-description-face ((t (:foreground "#E8E4D4"))))
 ;; treemacs
 '(treemacs-root-face ((t (:foreground "#D4C84A" :weight bold :height 1.1))))
 '(treemacs-directory-face ((t (:foreground "#E0DA86"))))
 '(treemacs-file-face ((t (:foreground "#E8E4D4"))))
 '(treemacs-git-modified-face ((t (:foreground "#6FA364"))))
 '(treemacs-git-added-face ((t (:foreground "#86BA7A"))))
 '(treemacs-git-renamed-face ((t (:foreground "#DAD168"))))
 '(treemacs-git-untracked-face ((t (:foreground "#4A4830"))))
 ;; flycheck / flymake
 '(flycheck-error ((t (:underline (:color "#5A8C50" :style wave)))))
 '(flycheck-warning ((t (:underline (:color "#6FA364" :style wave)))))
 '(flycheck-info ((t (:underline (:color "#D4C84A" :style wave)))))
 '(flymake-error ((t (:underline (:color "#5A8C50" :style wave)))))
 '(flymake-warning ((t (:underline (:color "#6FA364" :style wave)))))
 '(flymake-note ((t (:underline (:color "#D4C84A" :style wave)))))
 ;; eglot
 '(eglot-highlight-symbol-face ((t (:background "#1A1910" :weight bold))))
 '(eglot-diagnostic-tag-deprecated-face ((t (:strike-through t :foreground "#4A4830"))))
 '(eglot-diagnostic-tag-unnecessary-face ((t (:foreground "#4A4830"))))
 ;; show-paren
 '(show-paren-match ((t (:background "#D4C84A" :foreground "#0D0C08" :weight bold))))
 '(show-paren-mismatch ((t (:background "#5A8C50" :foreground "#0D0C08" :weight bold))))
 ;; eldoc
 '(eldoc-highlight-function-argument ((t (:foreground "#6FA364" :weight bold))))
 ;; dired
 '(dired-directory ((t (:foreground "#D4C84A" :weight bold))))
 '(dired-symlink ((t (:foreground "#E0DA86" :slant italic))))
 '(dired-flagged ((t (:foreground "#0D0C08" :background "#5A8C50"))))
 '(dired-marked ((t (:foreground "#0D0C08" :background "#6FA364"))))
 '(dired-header ((t (:foreground "#D4C84A" :weight bold))))
 ;; eshell
 '(eshell-prompt ((t (:foreground "#D4C84A" :weight bold))))
 '(eshell-ls-directory ((t (:foreground "#E0DA86" :weight bold))))
 '(eshell-ls-executable ((t (:foreground "#6FA364" :weight bold))))
 '(eshell-ls-symlink ((t (:foreground "#DAD168" :slant italic))))
 '(eshell-ls-unreadable ((t (:foreground "#5A8C50"))))
 )

(provide-theme 'backrooms-dark)

;;; backrooms-dark-theme.el ends here
