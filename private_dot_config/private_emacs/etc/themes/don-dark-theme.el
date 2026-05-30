;;; don-dark-theme.el --- Don dark theme  -*- lexical-binding: t; -*-

;; Author: John Gosset
;; Version: 1.0
;; Keywords: faces themes

;;; Commentary:
;; A dark Emacs theme.
;;
;; Color palette:
;;   Dark Navy  #121518  — primary background
;;   Navy       #182742  — secondary background (mode-line, fringe)
;;   Sand       #F3F4EE  — primary foreground
;;   Teal       #00D4C1  — primary accent (links, keywords, functions)
;;   Teal 80%   #33DCC9  — builtins, preprocessors
;;   Teal 60%   #66E4D1  — variables, lazy-highlight
;;   Teal 40%   #99EBD9  — types
;;   Teal 20%   #CCF2F0  — background highlights
;;   Orange     #F85C45  — cursor, warnings
;;   Orange 80% #F97D68  — constants
;;   Orange 60% #FA9E8A  — strings
;;   Dark Green #707C78  — comments, secondary text

;;; Code:

(deftheme don-dark "Don dark theme.")

(custom-theme-set-faces
 'don-dark

 ;; ───────────────────────────────────────────────────────────────────────────
 ;; 1. BASIC
 ;; ───────────────────────────────────────────────────────────────────────────
 '(default ((((type graphic))
             (:background "#121518" :foreground "#F3F4EE"
              :slant normal :weight normal :height 160 :width normal
              :family "JuliaMono"))
            (t
             (:background "#121518" :foreground "#F3F4EE"))))
 '(cursor ((t (:background "#F85C45"))))
 '(fixed-pitch ((t (:family "Monospace"))))
 '(variable-pitch ((((type w32)) (:foundry "outline" :family "Arial"))
                   (t (:family "Sans Serif"))))

 ;; ───────────────────────────────────────────────────────────────────────────
 ;; 2. UI CHROME
 ;; ───────────────────────────────────────────────────────────────────────────
 '(fringe ((t (:background "#182742" :foreground "#707C78"))))
 '(header-line ((t (:background "#182742" :foreground "#F3F4EE"
                    :box (:line-width 1 :color "#00D4C1")))))
 '(tooltip ((((class color))
             (:inherit variable-pitch
              :background "#182742" :foreground "#F3F4EE"))
            (t (:inherit variable-pitch))))
 '(mode-line ((t (:background "#182742" :foreground "#66E4D1"
                  :box (:line-width 1 :color "#00D4C1" :style nil)))))
 '(mode-line-buffer-id ((t (:foreground "#F3F4EE" :weight bold))))
 '(mode-line-emphasis ((t (:foreground "#00D4C1" :weight bold))))
 '(mode-line-highlight ((((class color) (min-colors 88))
                         (:box (:line-width 2 :color "#00D4C1" :style released-button)))
                        (t (:inherit highlight))))
 '(mode-line-inactive ((t (:background "#182742" :foreground "#707C78"
                            :box (:line-width 1 :color "#182742" :style nil)))))
 '(tab-bar ((t (:background "#182742" :foreground "#707C78"))))
 '(tab-bar-tab ((t (:background "#121518" :foreground "#00D4C1"
                    :box (:line-width 2 :color "#00D4C1" :style nil)))))
 '(tab-bar-tab-inactive ((t (:background "#182742" :foreground "#707C78"
                              :box (:line-width 2 :color "#182742" :style nil)))))

 ;; ───────────────────────────────────────────────────────────────────────────
 ;; 3. MINIBUFFER
 ;; ───────────────────────────────────────────────────────────────────────────
 '(minibuffer-prompt ((t (:foreground "#00D4C1" :weight bold))))

 ;; ───────────────────────────────────────────────────────────────────────────
 ;; 4. SELECTION / HIGHLIGHTING
 ;; ───────────────────────────────────────────────────────────────────────────
 '(highlight ((t (:background "#182742" :foreground "#F3F4EE" :extend t))))
 '(region ((t (:background "#182742" :foreground "#F3F4EE" :extend t))))
 '(secondary-selection
   ((((class color) (min-colors 88) (background dark))
     (:background "#1E3A5C" :extend t))
    (((class color) (min-colors 8) (background dark))
     (:foreground "#F3F4EE" :background "#182742" :extend t))
    (t (:inverse-video t))))
 '(shadow ((((class color grayscale) (min-colors 88) (background dark))
            (:foreground "#707C78"))
           (((class color) (min-colors 8) (background dark))
            (:foreground "#707C78"))
           (t (:foreground "grey70"))))
 '(hl-line ((t (:background "#182742" :extend t))))

 ;; ───────────────────────────────────────────────────────────────────────────
 ;; 5. SEARCH
 ;; ───────────────────────────────────────────────────────────────────────────
 '(isearch ((t (:background "#00D4C1" :foreground "#121518" :weight bold))))
 '(isearch-fail ((((class color) (min-colors 88) (background dark))
                  (:background "#7A1A10" :foreground "#F3F4EE"))
                 (((class color) (min-colors 8))
                  (:background "red" :foreground "white"))
                 (t (:inverse-video t))))
 '(lazy-highlight ((t (:background "#182742" :foreground "#66E4D1"
                        :underline (:color "#66E4D1" :style line)))))
 '(match ((((class color) (min-colors 88) (background dark))
           (:background "#1E3A5C" :foreground "#F3F4EE"))
          (((class color) (min-colors 8) (background dark))
           (:background "#182742" :foreground "#F3F4EE"))
          (t (:inverse-video t))))
 '(query-replace ((t (:inherit isearch))))

 ;; ───────────────────────────────────────────────────────────────────────────
 ;; 6. LINKS
 ;; ───────────────────────────────────────────────────────────────────────────
 '(button ((t (:foreground "#00D4C1" :underline (:color "#00D4C1" :style line)))))
 '(link ((t (:foreground "#00D4C1" :underline (:color "#00D4C1" :style line)))))
 '(link-visited ((default (:inherit link))
                 (((class color) (background dark))
                  (:foreground "#66E4D1"
                   :underline (:color "#66E4D1" :style line)))))

 ;; ───────────────────────────────────────────────────────────────────────────
 ;; 7. TEXT GLYPHS
 ;; ───────────────────────────────────────────────────────────────────────────
 '(trailing-whitespace ((t (:background "#F85C45"))))
 '(escape-glyph ((((background dark)) (:foreground "#66E4D1"))
                 (((type pc)) (:foreground "#F97D68"))
                 (t (:foreground "#009E90"))))
 '(homoglyph ((((background dark)) (:foreground "#66E4D1"))
              (((type pc)) (:foreground "#F97D68"))
              (t (:foreground "#009E90"))))

 ;; ───────────────────────────────────────────────────────────────────────────
 ;; 8. NAVIGATION / COMPILATION
 ;; ───────────────────────────────────────────────────────────────────────────
 '(next-error ((t (:inherit region))))
 '(compilation-error ((t (:foreground "#F85C45" :weight bold))))
 '(compilation-warning ((t (:foreground "#F97D68" :weight bold))))
 '(compilation-info ((t (:foreground "#00D4C1"))))
 '(compilation-line-number ((t (:foreground "#707C78"))))
 '(compilation-column-number ((t (:foreground "#707C78"))))
 '(compilation-mode-line-exit ((t (:foreground "#00D4C1" :weight bold))))
 '(compilation-mode-line-fail ((t (:foreground "#F85C45" :weight bold))))
 '(compilation-mode-line-run ((t (:foreground "#F97D68"))))

 ;; ───────────────────────────────────────────────────────────────────────────
 ;; 9. FONT-LOCK (SYNTAX)
 ;; ───────────────────────────────────────────────────────────────────────────
 '(font-lock-builtin-face ((t (:foreground "#33DCC9"))))
 '(font-lock-comment-delimiter-face ((t (:foreground "#707C78" :slant italic))))
 '(font-lock-comment-face ((t (:foreground "#707C78" :slant italic))))
 '(font-lock-constant-face ((((class color) (min-colors 88) (background dark))
                              (:foreground "#F97D68"))
                             (t (:foreground "#F97D68" :weight bold))))
 '(font-lock-doc-face ((t (:foreground "#9AADA8"))))
 '(font-lock-doc-markup-face ((t (:foreground "#66E4D1"))))
 '(font-lock-function-name-face ((t (:foreground "#00D4C1"))))
 '(font-lock-keyword-face ((t (:foreground "#00D4C1" :weight bold))))
 '(font-lock-negation-char-face ((t (:foreground "#F85C45" :weight bold))))
 '(font-lock-preprocessor-face ((t (:foreground "#33DCC9" :slant italic))))
 '(font-lock-regexp-grouping-backslash ((t (:inherit bold))))
 '(font-lock-regexp-grouping-construct ((t (:inherit bold))))
 '(font-lock-string-face ((t (:foreground "#FA9E8A"))))
 '(font-lock-type-face ((t (:foreground "#99EBD9" :weight bold))))
 '(font-lock-variable-name-face ((t (:foreground "#66E4D1"))))
 '(font-lock-warning-face ((t (:foreground "#F85C45" :weight bold))))
 ;; Emacs 29+ additional font-lock faces
 '(font-lock-bracket-face ((t (:foreground "#707C78"))))
 '(font-lock-delimiter-face ((t (:foreground "#707C78"))))
 '(font-lock-misc-punctuation-face ((t (:foreground "#707C78"))))
 '(font-lock-number-face ((t (:foreground "#FBBFAC"))))
 '(font-lock-operator-face ((t (:foreground "#F3F4EE"))))
 '(font-lock-property-name-face ((t (:foreground "#66E4D1"))))
 '(font-lock-property-use-face ((t (:foreground "#66E4D1"))))
 '(font-lock-punctuation-face ((t (:foreground "#707C78"))))

 ;; ───────────────────────────────────────────────────────────────────────────
 ;; 10. ORG-MODE
 ;; ───────────────────────────────────────────────────────────────────────────
 '(org-document-title ((t (:foreground "#00D4C1" :weight bold :height 1.4))))
 '(org-document-info ((t (:foreground "#66E4D1" :slant italic))))
 '(org-document-info-keyword ((t (:foreground "#707C78"))))
 '(org-level-1 ((t (:foreground "#00D4C1" :weight bold :height 1.3))))
 '(org-level-2 ((t (:foreground "#F97D68" :weight bold :height 1.2))))
 '(org-level-3 ((t (:foreground "#66E4D1" :weight bold :height 1.1))))
 '(org-level-4 ((t (:foreground "#FA9E8A" :weight bold))))
 '(org-level-5 ((t (:foreground "#33DCC9"))))
 '(org-level-6 ((t (:foreground "#FBBFAC"))))
 '(org-level-7 ((t (:foreground "#99EBD9"))))
 '(org-level-8 ((t (:foreground "#FDDFCE"))))
 '(org-block ((t (:background "#0D1017" :extend t))))
 '(org-block-begin-line ((t (:background "#182742" :foreground "#707C78"
                              :slant italic :extend t))))
 '(org-block-end-line ((t (:background "#182742" :foreground "#707C78"
                            :slant italic :extend t))))
 '(org-code ((t (:foreground "#66E4D1" :background "#0D1017"))))
 '(org-verbatim ((t (:foreground "#99EBD9"))))
 '(org-table ((t (:foreground "#F3F4EE"))))
 '(org-link ((t (:foreground "#00D4C1" :underline (:color "#00D4C1" :style line)))))
 '(org-todo ((t (:foreground "#F85C45" :weight bold))))
 '(org-done ((t (:foreground "#00D4C1" :weight bold))))
 '(org-headline-done ((t (:foreground "#707C78" :strike-through t))))
 '(org-date ((t (:foreground "#66E4D1" :underline t))))
 '(org-warning ((t (:foreground "#F85C45" :weight bold))))
 '(org-special-keyword ((t (:foreground "#707C78"))))
 '(org-tag ((t (:foreground "#707C78" :weight bold))))
 '(org-checkbox ((t (:foreground "#F97D68" :weight bold))))
 '(org-formula ((t (:foreground "#FA9E8A"))))

 ;; ───────────────────────────────────────────────────────────────────────────
 ;; 11. DIFF / MAGIT
 ;; ───────────────────────────────────────────────────────────────────────────
 '(diff-added ((t (:background "#0A2520" :foreground "#66E4D1" :extend t))))
 '(diff-removed ((t (:background "#2A0E0A" :foreground "#F97D68" :extend t))))
 '(diff-changed ((t (:background "#182742" :foreground "#F3F4EE" :extend t))))
 '(diff-header ((t (:background "#182742" :foreground "#707C78" :weight bold))))
 '(diff-file-header ((t (:background "#182742" :foreground "#F3F4EE" :weight bold))))
 '(diff-hunk-header ((t (:background "#0D1017" :foreground "#66E4D1"))))
 '(diff-context ((t (:foreground "#707C78"))))
 '(magit-section-heading ((t (:foreground "#00D4C1" :weight bold))))
 '(magit-section-highlight ((t (:background "#182742"))))
 '(magit-branch-local ((t (:foreground "#F85C45" :weight bold))))
 '(magit-branch-remote ((t (:foreground "#F97D68"))))
 '(magit-branch-current ((t (:foreground "#F85C45" :weight bold
                              :box (:line-width 1 :color "#F85C45")))))
 '(magit-tag ((t (:foreground "#FA9E8A"))))
 '(magit-hash ((t (:foreground "#707C78"))))
 '(magit-diff-added ((t (:background "#0A2520" :foreground "#66E4D1" :extend t))))
 '(magit-diff-removed ((t (:background "#2A0E0A" :foreground "#F97D68" :extend t))))
 '(magit-diff-added-highlight ((t (:background "#0D3028" :foreground "#66E4D1" :extend t))))
 '(magit-diff-removed-highlight ((t (:background "#3A1410" :foreground "#F97D68" :extend t))))
 '(magit-diff-context ((t (:foreground "#707C78" :extend t))))
 '(magit-diff-context-highlight ((t (:background "#182742" :foreground "#F3F4EE" :extend t))))
 '(magit-diff-hunk-heading ((t (:background "#182742" :foreground "#707C78"))))
 '(magit-diff-hunk-heading-highlight ((t (:background "#182742" :foreground "#66E4D1" :weight bold))))
 '(magit-process-ok ((t (:foreground "#00D4C1" :weight bold))))
 '(magit-process-ng ((t (:foreground "#F85C45" :weight bold))))

 ;; ───────────────────────────────────────────────────────────────────────────
 ;; 12. LINE NUMBERS
 ;; ───────────────────────────────────────────────────────────────────────────
 '(line-number ((t (:background "#121518" :foreground "#707C78"))))
 '(line-number-current-line ((t (:background "#182742" :foreground "#F3F4EE" :weight bold))))
 '(line-number-major-tick ((t (:background "#121518" :foreground "#33DCC9"))))
 '(line-number-minor-tick ((t (:background "#121518" :foreground "#707C78"))))

 ;; ───────────────────────────────────────────────────────────────────────────
 ;; 13. COMPLETION (CORFU)
 ;; ───────────────────────────────────────────────────────────────────────────
 '(completions-common-part ((t (:foreground "#00D4C1" :weight bold))))
 '(completions-first-difference ((t (:foreground "#F85C45" :weight bold))))
 '(completions-annotations ((t (:foreground "#707C78" :slant italic))))
 '(corfu-default ((t (:background "#182742" :foreground "#F3F4EE"))))
 '(corfu-current ((t (:background "#00D4C1" :foreground "#121518" :weight bold))))
 '(corfu-bar ((t (:background "#00D4C1"))))
 '(corfu-border ((t (:background "#33DCC9"))))
 '(corfu-annotations ((t (:foreground "#707C78"))))
 '(corfu-deprecated ((t (:foreground "#707C78" :strike-through t))))

 ;; ───────────────────────────────────────────────────────────────────────────
 ;; 14. VERTICO / CONSULT / ORDERLESS
 ;; ───────────────────────────────────────────────────────────────────────────
 '(vertico-current ((t (:background "#182742" :foreground "#F3F4EE" :extend t))))
 '(vertico-group-title ((t (:foreground "#707C78" :slant italic))))
 '(vertico-group-separator ((t (:foreground "#707C78" :strike-through t))))
 '(consult-file ((t (:foreground "#66E4D1"))))
 '(consult-buffer ((t (:foreground "#F3F4EE"))))
 '(consult-grep-context ((t (:foreground "#707C78"))))
 '(consult-highlight-match ((t (:foreground "#00D4C1" :weight bold))))
 '(orderless-match-face-0 ((t (:foreground "#00D4C1" :weight bold))))
 '(orderless-match-face-1 ((t (:foreground "#F85C45" :weight bold))))
 '(orderless-match-face-2 ((t (:foreground "#66E4D1" :weight bold))))
 '(orderless-match-face-3 ((t (:foreground "#F97D68" :weight bold))))

 ;; ───────────────────────────────────────────────────────────────────────────
 ;; 15. RAINBOW DELIMITERS
 ;; Alternating teal / orange tints; Dark Green as neutral break at depth 9
 ;; ───────────────────────────────────────────────────────────────────────────
 '(rainbow-delimiters-base-face ((t (:inherit nil))))
 '(rainbow-delimiters-depth-1-face ((t (:inherit rainbow-delimiters-base-face
                                         :foreground "#00D4C1"))))
 '(rainbow-delimiters-depth-2-face ((t (:inherit rainbow-delimiters-base-face
                                         :foreground "#F85C45"))))
 '(rainbow-delimiters-depth-3-face ((t (:inherit rainbow-delimiters-base-face
                                         :foreground "#66E4D1"))))
 '(rainbow-delimiters-depth-4-face ((t (:inherit rainbow-delimiters-base-face
                                         :foreground "#F97D68"))))
 '(rainbow-delimiters-depth-5-face ((t (:inherit rainbow-delimiters-base-face
                                         :foreground "#33DCC9"))))
 '(rainbow-delimiters-depth-6-face ((t (:inherit rainbow-delimiters-base-face
                                         :foreground "#FA9E8A"))))
 '(rainbow-delimiters-depth-7-face ((t (:inherit rainbow-delimiters-base-face
                                         :foreground "#99EBD9"))))
 '(rainbow-delimiters-depth-8-face ((t (:inherit rainbow-delimiters-base-face
                                         :foreground "#FBBFAC"))))
 '(rainbow-delimiters-depth-9-face ((t (:inherit rainbow-delimiters-base-face
                                         :foreground "#707C78"))))
 '(rainbow-delimiters-unmatched-face ((t (:foreground "#F3F4EE"
                                           :background "#F85C45" :weight bold))))
 '(rainbow-delimiters-mismatched-face ((t (:foreground "#F3F4EE"
                                            :background "#F85C45" :weight bold
                                            :underline t))))

 ;; ───────────────────────────────────────────────────────────────────────────
 ;; 16. ADDITIONAL PACKAGES
 ;; ───────────────────────────────────────────────────────────────────────────
 ;; which-key
 '(which-key-key-face ((t (:foreground "#00D4C1" :weight bold))))
 '(which-key-separator-face ((t (:foreground "#707C78"))))
 '(which-key-description-face ((t (:foreground "#F3F4EE"))))
 '(which-key-group-description-face ((t (:foreground "#F97D68"))))
 '(which-key-command-description-face ((t (:foreground "#F3F4EE"))))
 ;; treemacs
 '(treemacs-root-face ((t (:foreground "#00D4C1" :weight bold :height 1.1))))
 '(treemacs-directory-face ((t (:foreground "#66E4D1"))))
 '(treemacs-file-face ((t (:foreground "#F3F4EE"))))
 '(treemacs-git-modified-face ((t (:foreground "#F97D68"))))
 '(treemacs-git-added-face ((t (:foreground "#66E4D1"))))
 '(treemacs-git-renamed-face ((t (:foreground "#FA9E8A"))))
 '(treemacs-git-untracked-face ((t (:foreground "#707C78"))))
 ;; flycheck / flymake
 '(flycheck-error ((t (:underline (:color "#F85C45" :style wave)))))
 '(flycheck-warning ((t (:underline (:color "#F97D68" :style wave)))))
 '(flycheck-info ((t (:underline (:color "#00D4C1" :style wave)))))
 '(flymake-error ((t (:underline (:color "#F85C45" :style wave)))))
 '(flymake-warning ((t (:underline (:color "#F97D68" :style wave)))))
 '(flymake-note ((t (:underline (:color "#00D4C1" :style wave)))))
 ;; eglot
 '(eglot-highlight-symbol-face ((t (:background "#182742" :weight bold))))
 '(eglot-diagnostic-tag-deprecated-face ((t (:strike-through t :foreground "#707C78"))))
 '(eglot-diagnostic-tag-unnecessary-face ((t (:foreground "#707C78"))))
 ;; show-paren
 '(show-paren-match ((t (:background "#00D4C1" :foreground "#121518" :weight bold))))
 '(show-paren-mismatch ((t (:background "#F85C45" :foreground "#F3F4EE" :weight bold))))
 ;; eldoc
 '(eldoc-highlight-function-argument ((t (:foreground "#F97D68" :weight bold))))
 ;; dired
 '(dired-directory ((t (:foreground "#00D4C1" :weight bold))))
 '(dired-symlink ((t (:foreground "#66E4D1" :slant italic))))
 '(dired-flagged ((t (:foreground "#F3F4EE" :background "#F85C45"))))
 '(dired-marked ((t (:foreground "#121518" :background "#F97D68"))))
 '(dired-header ((t (:foreground "#00D4C1" :weight bold))))
 ;; eshell
 '(eshell-prompt ((t (:foreground "#00D4C1" :weight bold))))
 '(eshell-ls-directory ((t (:foreground "#66E4D1" :weight bold))))
 '(eshell-ls-executable ((t (:foreground "#F97D68" :weight bold))))
 '(eshell-ls-symlink ((t (:foreground "#33DCC9" :slant italic))))
 '(eshell-ls-unreadable ((t (:foreground "#F85C45"))))
 )

(provide-theme 'don-dark)

;;; don-dark-theme.el ends here
