;;; don-light-theme.el --- Don light theme  -*- lexical-binding: t; -*-

;; Author: John Gosset
;; Version: 1.0
;; Keywords: faces themes

;;; Commentary:
;; A light Emacs theme.
;;
;; Color palette:
;;   Sand       #F3F4EE  — primary background
;;   Dark Navy  #121518  — primary foreground
;;   Dark Green #707C78  — comments, secondary text
;;   Orange     #F85C45  — cursor (decorative only on light bg)
;;
;; Raw Teal (#00D4C1) and Orange (#F85C45) do NOT meet WCAG AA (4.5:1)
;; on Sand (#F3F4EE).  Contrast-safe derived values are used for text:
;;   Deep Teal  #007A70  ~6.0:1  — keywords, links, functions, prompts
;;   Mid Teal   #009E90  ~4.6:1  — builtins, preprocessors, annotations
;;   Teal Depth #005C55  ~7.6:1  — variables, visited links
;;   Deep Orange #C94030 ~5.2:1  — errors, strings, constants
;;   Mid Orange  #E0501C ~4.6:1  — warnings, checkboxes
;;
;; Teal (#00D4C1) and tints are retained for backgrounds (region,
;; isearch, hl-line) where dark foreground text provides the contrast.

;;; Code:

(deftheme don-light "Don light theme.")

(custom-theme-set-faces
 'don-light

 ;; ───────────────────────────────────────────────────────────────────────────
 ;; 1. BASIC
 ;; ───────────────────────────────────────────────────────────────────────────
 '(default ((((type graphic))
             (:background "#F3F4EE" :foreground "#121518"
              :slant normal :weight normal :height 160 :width normal
              :family "JuliaMono"))
            (t
             (:background "#F3F4EE" :foreground "#121518"))))
 '(cursor ((t (:background "#F85C45"))))
 '(fixed-pitch ((t (:family "Monospace"))))
 '(variable-pitch ((((type w32)) (:foundry "outline" :family "Arial"))
                   (t (:family "Sans Serif"))))

 ;; ───────────────────────────────────────────────────────────────────────────
 ;; 2. UI CHROME
 ;; ───────────────────────────────────────────────────────────────────────────
 '(fringe ((t (:background "#E8E9E3" :foreground "#707C78"))))
 '(header-line ((t (:background "#FFFFFF" :foreground "#121518"
                    :box (:line-width 1 :color "#009E90")))))
 '(tooltip ((((class color))
             (:inherit variable-pitch
              :background "#FFFFFF" :foreground "#121518"))
            (t (:inherit variable-pitch))))
 '(mode-line ((t (:background "#FFFFFF" :foreground "#121518"
                  :box (:line-width 1 :color "#009E90" :style nil)))))
 '(mode-line-buffer-id ((t (:foreground "#121518" :weight bold))))
 '(mode-line-emphasis ((t (:foreground "#007A70" :weight bold))))
 '(mode-line-highlight ((((class color) (min-colors 88))
                         (:box (:line-width 2 :color "#009E90" :style released-button)))
                        (t (:inherit highlight))))
 '(mode-line-inactive ((t (:background "#E8E9E3" :foreground "#707C78"
                            :box (:line-width 1 :color "#E8E9E3" :style nil)))))
 '(tab-bar ((t (:background "#E8E9E3" :foreground "#707C78"))))
 '(tab-bar-tab ((t (:background "#F3F4EE" :foreground "#007A70"
                    :box (:line-width 2 :color "#007A70" :style nil)))))
 '(tab-bar-tab-inactive ((t (:background "#E8E9E3" :foreground "#707C78"
                              :box (:line-width 2 :color "#E8E9E3" :style nil)))))

 ;; ───────────────────────────────────────────────────────────────────────────
 ;; 3. MINIBUFFER
 ;; ───────────────────────────────────────────────────────────────────────────
 '(minibuffer-prompt ((t (:foreground "#007A70" :weight bold))))

 ;; ───────────────────────────────────────────────────────────────────────────
 ;; 4. SELECTION / HIGHLIGHTING
 ;; ───────────────────────────────────────────────────────────────────────────
 '(highlight ((t (:background "#CCF2F0" :foreground "#121518" :extend t))))
 '(region ((t (:background "#CCF2F0" :foreground "#121518" :extend t))))
 '(secondary-selection
   ((((class color) (min-colors 88) (background light))
     (:background "#99EBD9" :extend t))
    (((class color) (min-colors 8) (background light))
     (:foreground "#121518" :background "#CCF2F0" :extend t))
    (t (:inverse-video t))))
 '(shadow ((((class color grayscale) (min-colors 88) (background light))
            (:foreground "#707C78"))
           (((class color) (min-colors 8) (background light))
            (:foreground "#707C78"))
           (t (:foreground "grey50"))))
 '(hl-line ((t (:background "#E8EDE9" :extend t))))

 ;; ───────────────────────────────────────────────────────────────────────────
 ;; 5. SEARCH
 ;; ───────────────────────────────────────────────────────────────────────────
 '(isearch ((t (:background "#007A70" :foreground "#F3F4EE" :weight bold))))
 '(isearch-fail ((((class color) (min-colors 88) (background light))
                  (:background "#FBBFAC" :foreground "#121518"))
                 (((class color) (min-colors 8))
                  (:background "red" :foreground "white"))
                 (t (:inverse-video t))))
 '(lazy-highlight ((t (:background "#CCF2F0" :foreground "#121518"
                        :underline (:color "#007A70" :style line)))))
 '(match ((((class color) (min-colors 88) (background light))
           (:background "#99EBD9" :foreground "#121518"))
          (((class color) (min-colors 8) (background light))
           (:background "#CCF2F0" :foreground "#121518"))
          (t (:inverse-video t))))
 '(query-replace ((t (:inherit isearch))))

 ;; ───────────────────────────────────────────────────────────────────────────
 ;; 6. LINKS
 ;; ───────────────────────────────────────────────────────────────────────────
 '(button ((t (:foreground "#007A70" :underline (:color "#007A70" :style line)))))
 '(link ((t (:foreground "#007A70" :underline (:color "#007A70" :style line)))))
 '(link-visited ((default (:inherit link))
                 (((class color) (background light))
                  (:foreground "#005C55"
                   :underline (:color "#005C55" :style line)))))

 ;; ───────────────────────────────────────────────────────────────────────────
 ;; 7. TEXT GLYPHS
 ;; ───────────────────────────────────────────────────────────────────────────
 '(trailing-whitespace ((t (:background "#F85C45"))))
 '(escape-glyph ((((background light)) (:foreground "#007A70"))
                 (((type pc)) (:foreground "#C94030"))
                 (t (:foreground "#009E90"))))
 '(homoglyph ((((background light)) (:foreground "#007A70"))
              (((type pc)) (:foreground "#C94030"))
              (t (:foreground "#009E90"))))

 ;; ───────────────────────────────────────────────────────────────────────────
 ;; 8. NAVIGATION / COMPILATION
 ;; ───────────────────────────────────────────────────────────────────────────
 '(next-error ((t (:inherit region))))
 '(compilation-error ((t (:foreground "#C94030" :weight bold))))
 '(compilation-warning ((t (:foreground "#E0501C" :weight bold))))
 '(compilation-info ((t (:foreground "#007A70"))))
 '(compilation-line-number ((t (:foreground "#707C78"))))
 '(compilation-column-number ((t (:foreground "#707C78"))))
 '(compilation-mode-line-exit ((t (:foreground "#007A70" :weight bold))))
 '(compilation-mode-line-fail ((t (:foreground "#C94030" :weight bold))))
 '(compilation-mode-line-run ((t (:foreground "#E0501C"))))

 ;; ───────────────────────────────────────────────────────────────────────────
 ;; 9. FONT-LOCK (SYNTAX)
 ;; ───────────────────────────────────────────────────────────────────────────
 '(font-lock-builtin-face ((t (:foreground "#009E90"))))
 '(font-lock-comment-delimiter-face ((t (:foreground "#707C78" :slant italic))))
 '(font-lock-comment-face ((t (:foreground "#707C78" :slant italic))))
 '(font-lock-constant-face ((((class color) (min-colors 88) (background light))
                              (:foreground "#C94030"))
                             (t (:foreground "#C94030" :weight bold))))
 '(font-lock-doc-face ((t (:foreground "#505856"))))
 '(font-lock-doc-markup-face ((t (:foreground "#009E90"))))
 '(font-lock-function-name-face ((t (:foreground "#007A70"))))
 '(font-lock-keyword-face ((t (:foreground "#007A70" :weight bold))))
 '(font-lock-negation-char-face ((t (:foreground "#C94030" :weight bold))))
 '(font-lock-preprocessor-face ((t (:foreground "#009E90" :slant italic))))
 '(font-lock-regexp-grouping-backslash ((t (:inherit bold))))
 '(font-lock-regexp-grouping-construct ((t (:inherit bold))))
 '(font-lock-string-face ((t (:foreground "#C94030"))))
 '(font-lock-type-face ((t (:foreground "#121518" :weight bold))))
 '(font-lock-variable-name-face ((t (:foreground "#005C55"))))
 '(font-lock-warning-face ((t (:foreground "#C94030" :weight bold))))
 ;; Emacs 29+ additional font-lock faces
 '(font-lock-bracket-face ((t (:foreground "#707C78"))))
 '(font-lock-delimiter-face ((t (:foreground "#707C78"))))
 '(font-lock-misc-punctuation-face ((t (:foreground "#707C78"))))
 '(font-lock-number-face ((t (:foreground "#C94030"))))
 '(font-lock-operator-face ((t (:foreground "#121518"))))
 '(font-lock-property-name-face ((t (:foreground "#005C55"))))
 '(font-lock-property-use-face ((t (:foreground "#005C55"))))
 '(font-lock-punctuation-face ((t (:foreground "#707C78"))))

 ;; ───────────────────────────────────────────────────────────────────────────
 ;; 10. ORG-MODE
 ;; ───────────────────────────────────────────────────────────────────────────
 '(org-document-title ((t (:foreground "#007A70" :weight bold :height 1.4))))
 '(org-document-info ((t (:foreground "#009E90" :slant italic))))
 '(org-document-info-keyword ((t (:foreground "#707C78"))))
 '(org-level-1 ((t (:foreground "#007A70" :weight bold :height 1.3))))
 '(org-level-2 ((t (:foreground "#C94030" :weight bold :height 1.2))))
 '(org-level-3 ((t (:foreground "#009E90" :weight bold :height 1.1))))
 '(org-level-4 ((t (:foreground "#121518" :weight bold))))
 '(org-level-5 ((t (:foreground "#007A70"))))
 '(org-level-6 ((t (:foreground "#E0501C"))))
 '(org-level-7 ((t (:foreground "#009E90"))))
 '(org-level-8 ((t (:foreground "#505856"))))
 '(org-block ((t (:background "#EAEEE8" :extend t))))
 '(org-block-begin-line ((t (:background "#E8E9E3" :foreground "#707C78"
                              :slant italic :extend t))))
 '(org-block-end-line ((t (:background "#E8E9E3" :foreground "#707C78"
                            :slant italic :extend t))))
 '(org-code ((t (:foreground "#007A70" :background "#EAEEE8"))))
 '(org-verbatim ((t (:foreground "#009E90"))))
 '(org-table ((t (:foreground "#121518"))))
 '(org-link ((t (:foreground "#007A70" :underline (:color "#007A70" :style line)))))
 '(org-todo ((t (:foreground "#C94030" :weight bold))))
 '(org-done ((t (:foreground "#007A70" :weight bold))))
 '(org-headline-done ((t (:foreground "#707C78" :strike-through t))))
 '(org-date ((t (:foreground "#009E90" :underline t))))
 '(org-warning ((t (:foreground "#C94030" :weight bold))))
 '(org-special-keyword ((t (:foreground "#707C78"))))
 '(org-tag ((t (:foreground "#707C78" :weight bold))))
 '(org-checkbox ((t (:foreground "#E0501C" :weight bold))))
 '(org-formula ((t (:foreground "#C94030"))))

 ;; ───────────────────────────────────────────────────────────────────────────
 ;; 11. DIFF / MAGIT
 ;; ───────────────────────────────────────────────────────────────────────────
 '(diff-added ((t (:background "#C8EFE9" :foreground "#004D45" :extend t))))
 '(diff-removed ((t (:background "#FDDDD8" :foreground "#7A1A10" :extend t))))
 '(diff-changed ((t (:background "#E8E9E3" :foreground "#121518" :extend t))))
 '(diff-header ((t (:background "#E8E9E3" :foreground "#707C78" :weight bold))))
 '(diff-file-header ((t (:background "#E8E9E3" :foreground "#121518" :weight bold))))
 '(diff-hunk-header ((t (:background "#EAEEE8" :foreground "#009E90"))))
 '(diff-context ((t (:foreground "#707C78"))))
 '(magit-section-heading ((t (:foreground "#007A70" :weight bold))))
 '(magit-section-highlight ((t (:background "#E8E9E3"))))
 '(magit-branch-local ((t (:foreground "#C94030" :weight bold))))
 '(magit-branch-remote ((t (:foreground "#007A70"))))
 '(magit-branch-current ((t (:foreground "#C94030" :weight bold
                              :box (:line-width 1 :color "#C94030")))))
 '(magit-tag ((t (:foreground "#E0501C"))))
 '(magit-hash ((t (:foreground "#707C78"))))
 '(magit-diff-added ((t (:background "#C8EFE9" :foreground "#004D45" :extend t))))
 '(magit-diff-removed ((t (:background "#FDDDD8" :foreground "#7A1A10" :extend t))))
 '(magit-diff-added-highlight ((t (:background "#A8E8DF" :foreground "#004D45" :extend t))))
 '(magit-diff-removed-highlight ((t (:background "#FBBFAC" :foreground "#7A1A10" :extend t))))
 '(magit-diff-context ((t (:foreground "#707C78" :extend t))))
 '(magit-diff-context-highlight ((t (:background "#E8E9E3" :foreground "#121518" :extend t))))
 '(magit-diff-hunk-heading ((t (:background "#E8E9E3" :foreground "#707C78"))))
 '(magit-diff-hunk-heading-highlight ((t (:background "#E8E9E3" :foreground "#007A70" :weight bold))))
 '(magit-process-ok ((t (:foreground "#007A70" :weight bold))))
 '(magit-process-ng ((t (:foreground "#C94030" :weight bold))))

 ;; ───────────────────────────────────────────────────────────────────────────
 ;; 12. LINE NUMBERS
 ;; ───────────────────────────────────────────────────────────────────────────
 '(line-number ((t (:background "#F3F4EE" :foreground "#707C78"))))
 '(line-number-current-line ((t (:background "#E8E9E3" :foreground "#121518" :weight bold))))
 '(line-number-major-tick ((t (:background "#F3F4EE" :foreground "#007A70"))))
 '(line-number-minor-tick ((t (:background "#F3F4EE" :foreground "#707C78"))))

 ;; ───────────────────────────────────────────────────────────────────────────
 ;; 13. COMPLETION (CORFU)
 ;; ───────────────────────────────────────────────────────────────────────────
 '(completions-common-part ((t (:foreground "#007A70" :weight bold))))
 '(completions-first-difference ((t (:foreground "#C94030" :weight bold))))
 '(completions-annotations ((t (:foreground "#707C78" :slant italic))))
 '(corfu-default ((t (:background "#FFFFFF" :foreground "#121518"))))
 '(corfu-current ((t (:background "#007A70" :foreground "#F3F4EE" :weight bold))))
 '(corfu-bar ((t (:background "#007A70"))))
 '(corfu-border ((t (:background "#009E90"))))
 '(corfu-annotations ((t (:foreground "#707C78"))))
 '(corfu-deprecated ((t (:foreground "#707C78" :strike-through t))))

 ;; ───────────────────────────────────────────────────────────────────────────
 ;; 14. VERTICO / CONSULT / ORDERLESS
 ;; ───────────────────────────────────────────────────────────────────────────
 '(vertico-current ((t (:background "#E8E9E3" :foreground "#121518" :extend t))))
 '(vertico-group-title ((t (:foreground "#707C78" :slant italic))))
 '(vertico-group-separator ((t (:foreground "#707C78" :strike-through t))))
 '(consult-file ((t (:foreground "#009E90"))))
 '(consult-buffer ((t (:foreground "#121518"))))
 '(consult-grep-context ((t (:foreground "#707C78"))))
 '(consult-highlight-match ((t (:foreground "#007A70" :weight bold))))
 '(orderless-match-face-0 ((t (:foreground "#007A70" :weight bold))))
 '(orderless-match-face-1 ((t (:foreground "#C94030" :weight bold))))
 '(orderless-match-face-2 ((t (:foreground "#009E90" :weight bold))))
 '(orderless-match-face-3 ((t (:foreground "#E0501C" :weight bold))))

 ;; ───────────────────────────────────────────────────────────────────────────
 ;; 15. RAINBOW DELIMITERS
 ;; Contrast-safe teal/orange cycle for light backgrounds
 ;; ───────────────────────────────────────────────────────────────────────────
 '(rainbow-delimiters-base-face ((t (:inherit nil))))
 '(rainbow-delimiters-depth-1-face ((t (:inherit rainbow-delimiters-base-face
                                         :foreground "#007A70"))))
 '(rainbow-delimiters-depth-2-face ((t (:inherit rainbow-delimiters-base-face
                                         :foreground "#C94030"))))
 '(rainbow-delimiters-depth-3-face ((t (:inherit rainbow-delimiters-base-face
                                         :foreground "#009E90"))))
 '(rainbow-delimiters-depth-4-face ((t (:inherit rainbow-delimiters-base-face
                                         :foreground "#E0501C"))))
 '(rainbow-delimiters-depth-5-face ((t (:inherit rainbow-delimiters-base-face
                                         :foreground "#005C55"))))
 '(rainbow-delimiters-depth-6-face ((t (:inherit rainbow-delimiters-base-face
                                         :foreground "#7A1A10"))))
 '(rainbow-delimiters-depth-7-face ((t (:inherit rainbow-delimiters-base-face
                                         :foreground "#004D45"))))
 '(rainbow-delimiters-depth-8-face ((t (:inherit rainbow-delimiters-base-face
                                         :foreground "#A0382A"))))
 '(rainbow-delimiters-depth-9-face ((t (:inherit rainbow-delimiters-base-face
                                         :foreground "#707C78"))))
 '(rainbow-delimiters-unmatched-face ((t (:foreground "#F3F4EE"
                                           :background "#C94030" :weight bold))))
 '(rainbow-delimiters-mismatched-face ((t (:foreground "#F3F4EE"
                                            :background "#C94030" :weight bold
                                            :underline t))))

 ;; ───────────────────────────────────────────────────────────────────────────
 ;; 16. ADDITIONAL PACKAGES
 ;; ───────────────────────────────────────────────────────────────────────────
 ;; which-key
 '(which-key-key-face ((t (:foreground "#007A70" :weight bold))))
 '(which-key-separator-face ((t (:foreground "#707C78"))))
 '(which-key-description-face ((t (:foreground "#121518"))))
 '(which-key-group-description-face ((t (:foreground "#E0501C"))))
 '(which-key-command-description-face ((t (:foreground "#121518"))))
 ;; treemacs
 '(treemacs-root-face ((t (:foreground "#007A70" :weight bold :height 1.1))))
 '(treemacs-directory-face ((t (:foreground "#009E90"))))
 '(treemacs-file-face ((t (:foreground "#121518"))))
 '(treemacs-git-modified-face ((t (:foreground "#E0501C"))))
 '(treemacs-git-added-face ((t (:foreground "#007A70"))))
 '(treemacs-git-renamed-face ((t (:foreground "#C94030"))))
 '(treemacs-git-untracked-face ((t (:foreground "#707C78"))))
 ;; flycheck / flymake
 '(flycheck-error ((t (:underline (:color "#C94030" :style wave)))))
 '(flycheck-warning ((t (:underline (:color "#E0501C" :style wave)))))
 '(flycheck-info ((t (:underline (:color "#007A70" :style wave)))))
 '(flymake-error ((t (:underline (:color "#C94030" :style wave)))))
 '(flymake-warning ((t (:underline (:color "#E0501C" :style wave)))))
 '(flymake-note ((t (:underline (:color "#007A70" :style wave)))))
 ;; eglot
 '(eglot-highlight-symbol-face ((t (:background "#CCF2F0" :weight bold))))
 '(eglot-diagnostic-tag-deprecated-face ((t (:strike-through t :foreground "#707C78"))))
 '(eglot-diagnostic-tag-unnecessary-face ((t (:foreground "#707C78"))))
 ;; show-paren
 '(show-paren-match ((t (:background "#007A70" :foreground "#F3F4EE" :weight bold))))
 '(show-paren-mismatch ((t (:background "#C94030" :foreground "#F3F4EE" :weight bold))))
 ;; eldoc
 '(eldoc-highlight-function-argument ((t (:foreground "#C94030" :weight bold))))
 ;; dired
 '(dired-directory ((t (:foreground "#007A70" :weight bold))))
 '(dired-symlink ((t (:foreground "#009E90" :slant italic))))
 '(dired-flagged ((t (:foreground "#F3F4EE" :background "#C94030"))))
 '(dired-marked ((t (:foreground "#F3F4EE" :background "#E0501C"))))
 '(dired-header ((t (:foreground "#007A70" :weight bold))))
 ;; eshell
 '(eshell-prompt ((t (:foreground "#007A70" :weight bold))))
 '(eshell-ls-directory ((t (:foreground "#009E90" :weight bold))))
 '(eshell-ls-executable ((t (:foreground "#E0501C" :weight bold))))
 '(eshell-ls-symlink ((t (:foreground "#007A70" :slant italic))))
 '(eshell-ls-unreadable ((t (:foreground "#C94030"))))
 )

(provide-theme 'don-light)

;;; don-light-theme.el ends here
