;;; gherkin-mode.el --- Major mode for Gherkin .feature files  -*- lexical-binding: t -*-

;; Keywords: languages gherkin cucumber bdd testing
;; Package-Requires: ((emacs "26.1"))

;; SPDX-License-Identifier: MIT

;;; Commentary:

;; A major mode for Gherkin feature files (.feature and .gherkin).
;; Provides syntax highlighting for the complete Gherkin language
;; specification, including all structural keywords, step keywords,
;; tags, data tables, doc strings, placeholders, and quoted strings.
;;
;; Reference: https://cucumber.io/docs/gherkin/reference
;;
;; Highlighted elements:
;;
;;   Structural keywords (with colon):
;;     Feature / Business Need / Ability
;;     Rule
;;     Background
;;     Scenario / Example
;;     Scenario Outline / Scenario Template
;;     Examples / Scenarios
;;
;;   Step keywords (followed by space):
;;     Given  When  Then  And  But  * (bullet)
;;
;;   Punctuation / special syntax:
;;     @tag          — tag annotations
;;     # comment     — line comments
;;     # language:   — language directive
;;     | cell |      — data table rows
;;     """ / '''     — doc string delimiters
;;     <placeholder> — Scenario Outline substitution variables
;;     "string"      — quoted string step arguments
;;
;; Installation:
;;
;;   (add-to-list 'load-path "/path/to/gherkin-mode")
;;   (require 'gherkin-mode)
;;
;;   .feature and .gherkin files are associated automatically.

;;; Code:

(defgroup gherkin nil
  "Major mode for Gherkin feature files."
  :group 'languages
  :prefix "gherkin-")

;;; ── Faces ────────────────────────────────────────────────────────────────────

(defface gherkin-feature-face
  '((t :inherit font-lock-keyword-face :weight bold))
  "Face for Feature / Business Need / Ability keywords."
  :group 'gherkin)

(defface gherkin-rule-face
  '((t :inherit font-lock-type-face :weight bold))
  "Face for Rule keywords."
  :group 'gherkin)

(defface gherkin-scenario-face
  '((t :inherit font-lock-function-name-face :weight bold))
  "Face for Scenario / Example / Scenario Outline / Scenario Template keywords."
  :group 'gherkin)

(defface gherkin-background-face
  '((t :inherit font-lock-preprocessor-face :weight bold))
  "Face for Background keywords."
  :group 'gherkin)

(defface gherkin-examples-face
  '((t :inherit font-lock-type-face))
  "Face for Examples / Scenarios keywords."
  :group 'gherkin)

;; Step keywords: Given / When / Then get their own colours so the
;; Given→When→Then narrative flow is visually distinct.

(defface gherkin-step-given-face
  '((default :weight bold)
    (((class color) (background light)) :foreground "#5f5fff")
    (((class color) (background dark))  :foreground "#8888ff"))
  "Face for the Given step keyword."
  :group 'gherkin)

(defface gherkin-step-when-face
  '((default :weight bold)
    (((class color) (background light)) :foreground "#875f00")
    (((class color) (background dark))  :foreground "#d0a000"))
  "Face for the When step keyword."
  :group 'gherkin)

(defface gherkin-step-then-face
  '((default :weight bold)
    (((class color) (background light)) :foreground "#005f00")
    (((class color) (background dark))  :foreground "#50c050"))
  "Face for the Then step keyword."
  :group 'gherkin)

(defface gherkin-step-and-face
  '((t :inherit font-lock-builtin-face))
  "Face for the And step keyword."
  :group 'gherkin)

(defface gherkin-step-but-face
  '((t :inherit font-lock-warning-face))
  "Face for the But step keyword."
  :group 'gherkin)

(defface gherkin-step-bullet-face
  '((t :inherit font-lock-builtin-face))
  "Face for the * bullet step keyword."
  :group 'gherkin)

(defface gherkin-tag-face
  '((t :inherit font-lock-preprocessor-face))
  "Face for @tag annotations."
  :group 'gherkin)

(defface gherkin-table-cell-face
  '((t :inherit font-lock-constant-face))
  "Face for | data table | rows."
  :group 'gherkin)

(defface gherkin-doc-string-face
  '((t :inherit font-lock-doc-face :weight bold))
  "Face for \"\"\" and ''' doc string delimiters."
  :group 'gherkin)

(defface gherkin-placeholder-face
  '((t :inherit font-lock-variable-name-face))
  "Face for <placeholder> variables in Scenario Outline steps."
  :group 'gherkin)

(defface gherkin-string-face
  '((t :inherit font-lock-string-face))
  "Face for \"quoted string\" step arguments."
  :group 'gherkin)

(defface gherkin-comment-face
  '((t :inherit font-lock-comment-face))
  "Face for # comment lines."
  :group 'gherkin)

(defface gherkin-language-directive-face
  '((t :inherit font-lock-comment-face :slant italic))
  "Face for the # language: xx directive."
  :group 'gherkin)

;;; ── Font-lock keywords ───────────────────────────────────────────────────────

(defconst gherkin-font-lock-keywords
  (let (
        ;; Regex fragments — built as strings to stay Emacs 26 compatible.
        ;;
        ;; A keyword that takes a colon is always at the start of meaningful
        ;; content (optional leading whitespace, then the word, then ":").
        (kw-col  "^[[:space:]]*")       ; line-start prefix with optional indent
        (colon   "\\(:\\)")             ; colon (used after structural keywords)
        )
    `(
      ;; ── Language directive (must precede generic comment rule) ────────────
      ;; # language: fr
      ("^[[:space:]]*\\(#[[:space:]]*language:[[:space:]]*[[:alnum:]-]+\\)"
       . (1 'gherkin-language-directive-face))

      ;; ── Comment lines ─────────────────────────────────────────────────────
      ("^[[:space:]]*\\(#.*\\)"
       . (1 'gherkin-comment-face))

      ;; ── Tags (@tag) ───────────────────────────────────────────────────────
      ;; Multiple tags may appear on one line: @smoke @slow @network
      ("\\(@[[:alnum:]_-]+\\)"
       . (1 'gherkin-tag-face))

      ;; ── Structural keywords (keyword + colon) ─────────────────────────────
      ;; Order matters: more specific patterns first.

      ;; Feature / Business Need / Ability
      ("^[[:space:]]*\\(Feature\\|Business Need\\|Ability\\):"
       . (1 'gherkin-feature-face))

      ;; Rule (Gherkin 6+)
      ("^[[:space:]]*\\(Rule\\):"
       . (1 'gherkin-rule-face))

      ;; Background
      ("^[[:space:]]*\\(Background\\):"
       . (1 'gherkin-background-face))

      ;; Scenario Outline / Scenario Template (before plain Scenario)
      ("^[[:space:]]*\\(Scenario Outline\\|Scenario Template\\):"
       . (1 'gherkin-scenario-face))

      ;; Scenario / Example
      ("^[[:space:]]*\\(Scenario\\|Example\\):"
       . (1 'gherkin-scenario-face))

      ;; Examples / Scenarios (data table section header)
      ("^[[:space:]]*\\(Examples\\|Scenarios\\):"
       . (1 'gherkin-examples-face))

      ;; ── Step keywords ─────────────────────────────────────────────────────
      ;; Each keyword is followed by at least one whitespace character.
      ;; Using [[:space:]] rather than a word boundary so the pattern
      ;; correctly requires content after the keyword on the same line.

      ("^[[:space:]]*\\(Given\\)[[:space:]]"  . (1 'gherkin-step-given-face))
      ("^[[:space:]]*\\(When\\)[[:space:]]"   . (1 'gherkin-step-when-face))
      ("^[[:space:]]*\\(Then\\)[[:space:]]"   . (1 'gherkin-step-then-face))
      ("^[[:space:]]*\\(And\\)[[:space:]]"    . (1 'gherkin-step-and-face))
      ("^[[:space:]]*\\(But\\)[[:space:]]"    . (1 'gherkin-step-but-face))
      ;; Asterisk bullet step (must be followed by space, not a glob etc.)
      ("^[[:space:]]*\\(\\*\\)[[:space:]]"    . (1 'gherkin-step-bullet-face))

      ;; ── Data table rows ───────────────────────────────────────────────────
      ;; A table row starts with optional whitespace and a | character.
      ;; The entire row (including all cells and separators) is coloured.
      ("^[[:space:]]*\\(|[^\n]*\\)"
       . (1 'gherkin-table-cell-face))

      ;; ── Doc string delimiters ─────────────────────────────────────────────
      ;; Opening:  """json  or  """  or  '''markdown  or  '''
      ;; Closing:  """      or  '''
      ;; The optional content-type hint (json, xml, markdown, …) on the
      ;; opening delimiter line is included in the highlighted region.
      ("^[[:space:]]*\\(\"\"\"[[:alnum:]]*\\|'''[[:alnum:]]*\\)"
       . (1 'gherkin-doc-string-face))

      ;; ── Placeholders <name> ───────────────────────────────────────────────
      ;; Used in Scenario Outline step text and Examples table headers.
      ("<[^>\n]+>"
       . 'gherkin-placeholder-face)

      ;; ── Quoted string step arguments "value" ──────────────────────────────
      ;; Applied last so it does not interfere with the structural patterns
      ;; above.  Deliberately does not match across newlines.
      ("\"[^\"\n]*\""
       . 'gherkin-string-face)
      ))
  "Font-lock keyword specification for `gherkin-mode'.")

;;; ── Syntax table ─────────────────────────────────────────────────────────────

(defvar gherkin-mode-syntax-table
  (let ((st (make-syntax-table text-mode-syntax-table)))
    ;; # begins a comment; newline ends it.
    (modify-syntax-entry ?# "<" st)
    (modify-syntax-entry ?\n ">" st)
    ;; @ is a symbol constituent — avoids splitting @tag at the @ character.
    (modify-syntax-entry ?@ "_" st)
    ;; < and > are punctuation, not paired delimiters (avoids confusion with
    ;; angle-bracket matching in modes that inherit from prog-mode defaults).
    (modify-syntax-entry ?< "." st)
    (modify-syntax-entry ?> "." st)
    ;; | is punctuation (not a vertical bar operator).
    (modify-syntax-entry ?| "." st)
    st)
  "Syntax table for `gherkin-mode'.")

;;; ── Outline support ──────────────────────────────────────────────────────────

(defconst gherkin--outline-regexp
  (concat "^[[:space:]]*"
          "\\(?:Feature\\|Business Need\\|Ability"
          "\\|Rule"
          "\\|Background"
          "\\|Scenario Outline\\|Scenario Template\\|Scenario\\|Example"
          "\\|Examples\\|Scenarios\\)")
  "Regexp matching Gherkin structural keyword lines for outline support.")

(defun gherkin--outline-level ()
  "Return outline depth of the current Gherkin heading line."
  (save-excursion
    (back-to-indentation)
    (cond
     ((looking-at "\\(?:Feature\\|Business Need\\|Ability\\)") 1)
     ((looking-at "Rule") 2)
     (t 3))))

;;; ── Imenu support ────────────────────────────────────────────────────────────

(defconst gherkin--imenu-generic-expression
  `(("Feature"
     "^[[:space:]]*\\(?:Feature\\|Business Need\\|Ability\\):[[:space:]]*\\(.*\\)$"
     1)
    ("Rule"
     "^[[:space:]]*Rule:[[:space:]]*\\(.*\\)$"
     1)
    ("Scenario"
     ,(concat "^[[:space:]]*"
              "\\(?:Scenario Outline\\|Scenario Template\\|Scenario\\|Example\\)"
              ":[[:space:]]*\\(.*\\)$")
     1)
    ("Background"
     "^[[:space:]]*Background:[[:space:]]*\\(.*\\)$"
     1))
  "Imenu generic expression for `gherkin-mode'.")

;;; ── Mode definition ──────────────────────────────────────────────────────────

;;;###autoload
(define-derived-mode gherkin-mode text-mode "Gherkin"
  "Major mode for editing Gherkin feature files (.feature, .gherkin).

Provides syntax highlighting for the complete Gherkin language:
structural keywords (Feature, Rule, Background, Scenario, Scenario
Outline, Examples), step keywords (Given, When, Then, And, But, *),
tags (@tag), data tables (| cell |), doc strings (\"\"\"), placeholders
(<name>), and quoted step arguments.

Reference: https://cucumber.io/docs/gherkin/reference

\\{gherkin-mode-map}"
  :syntax-table gherkin-mode-syntax-table

  ;; Comment syntax so M-; works correctly
  (setq-local comment-start "# ")
  (setq-local comment-start-skip "#+[[:space:]]*")
  (setq-local comment-end "")

  ;; Font-lock
  (setq-local font-lock-defaults
              '(gherkin-font-lock-keywords
                nil   ; keywords-only — do not let the syntax table override faces
                nil   ; case-fold
                nil))

  ;; Indentation: Gherkin uses spaces only
  (setq-local indent-tabs-mode nil)
  (setq-local tab-width 2)
  ;; Do not let electric-indent reformat lines automatically
  (setq-local electric-indent-inhibit t)

  ;; Outline minor mode support (fold Feature/Rule/Scenario blocks)
  (setq-local outline-regexp gherkin--outline-regexp)
  (setq-local outline-level #'gherkin--outline-level)

  ;; Imenu (M-g i or counsel-imenu) — jump to any Feature/Scenario by name
  (setq-local imenu-generic-expression gherkin--imenu-generic-expression)
  (setq-local imenu-case-fold-search nil))

;;;###autoload
(add-to-list 'auto-mode-alist '("\\.feature\\'" . gherkin-mode))
;;;###autoload
(add-to-list 'auto-mode-alist '("\\.gherkin\\'" . gherkin-mode))

(provide 'gherkin-mode)

;;; gherkin-mode.el ends here
