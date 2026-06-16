;;; txtar-mode.el --- Major mode for testscript .txtar files  -*- lexical-binding: t -*-

;; Keywords: languages tools testscript
;; Package-Requires: ((emacs "26.1"))

;; SPDX-License-Identifier: GPL-3.0-only

;;; Commentary:

;; A major mode for editing .txtar testscript files used by
;; golang.org/x/tools/txtar and github.com/rogpeppe/go-internal/testscript.
;;
;; A .txtar file has two sections:
;;
;;   1. Script section: testscript commands (exec, stdout, stderr, exists, …)
;;      separated from the rest by the first file-section marker.
;;
;;   2. File sections: one or more embedded files, each introduced by a
;;      marker line of the form:
;;
;;        -- path/to/file.ext --
;;
;;      Everything between one marker and the next is the literal content
;;      of that file, written to $WORK/<path> before the script runs.
;;
;; Syntax elements highlighted:
;;
;;   • File-section markers  (-- path --)         bold keyword face
;;   • Comment lines         (# …)                comment face
;;   • Condition blocks      ([!condition])        type face
;;   • Negation operator     (!)                  warning face
;;   • Command verbs         (exec, stdout, …)    builtin face
;;   • Environment variables ($VAR, ${VAR})        variable-name face
;;   • Quoted strings        ('…', "…")           string face
;;   • CLI flags             (--flag, -f)          constant face
;;
;; Installation:
;;
;;   Add to your init.el:
;;
;;     (add-to-list 'load-path "/path/to/txtar-mode")
;;     (require 'txtar-mode)
;;
;;   Files matching *.txtar are associated automatically.

;;; Code:

(defgroup txtar nil
  "Major mode for testscript .txtar files."
  :group 'languages
  :prefix "txtar-")

;;; Faces

(defface txtar-section-marker-face
  '((t :inherit font-lock-keyword-face :weight bold))
  "Face for -- file -- section markers in txtar files."
  :group 'txtar)

;;; Font-lock

(defconst txtar--commands
  '("append" "cc" "cd" "chmod" "cmp" "cmpenv" "cp" "env"
    "exec" "exists" "grep" "mkdir" "mv" "replace" "rm"
    "skip" "stdin" "stderr" "stdout" "stop" "symlink"
    "unquote" "wait")
  "Testscript command verbs recognised in txtar-mode.")

(defconst txtar-font-lock-keywords
  `(
    ;; -- path/to/file.ext -- section markers (most visually prominent)
    ("^--[[:space:]]+.+[[:space:]]+--[[:space:]]*$"
     . 'txtar-section-marker-face)

    ;; # comment lines
    ("^#.*"
     . font-lock-comment-face)

    ;; [condition] or [!condition] blocks at the start of a line
    ("^\\(\\[[^]]*\\]\\)"
     . (1 font-lock-type-face))

    ;; Negation operator !: at line start, or immediately after a ] block
    ;; Uses two alternations with nil t so either capture group may be absent.
    ("^\\(!\\)\\|\\][[:space:]]*\\(!\\)"
     (1 font-lock-warning-face nil t)
     (2 font-lock-warning-face nil t))

    ;; Command verbs (word-boundary anchored, regexp-opt for efficiency)
    (,(regexp-opt txtar--commands 'words)
     . font-lock-builtin-face)

    ;; Environment variable references: $VAR or ${VAR}
    ("\\$\\(?:{\\([^}\n]+\\)}\\|\\([[:alnum:]_]+\\)\\)"
     . font-lock-variable-name-face)

    ;; Single-quoted strings (common for regex arguments)
    ("'[^'\n]*'"
     . font-lock-string-face)

    ;; Double-quoted strings
    ("\"[^\"\n]*\""
     . font-lock-string-face)

    ;; CLI flags: --long-flag or -s following whitespace
    ("[[:space:]]\\(--?[[:alnum:]][[:alnum:]-]*\\)"
     . (1 font-lock-constant-face))
    )
  "Font-lock keyword specification for `txtar-mode'.")

;;; Syntax table

(defvar txtar-mode-syntax-table
  (let ((st (make-syntax-table)))
    ;; # starts a line comment
    (modify-syntax-entry ?# "<" st)
    (modify-syntax-entry ?\n ">" st)
    ;; Treat $ as a symbol constituent so $VAR is one token
    (modify-syntax-entry ?$ "_" st)
    ;; Single quotes delimit strings
    (modify-syntax-entry ?' "\"" st)
    st)
  "Syntax table for `txtar-mode'.")

;;; Mode definition

;;;###autoload
(define-derived-mode txtar-mode prog-mode "Txtar"
  "Major mode for editing testscript .txtar files.

A .txtar file consists of a script section (testscript commands) followed
by zero or more embedded file sections introduced by markers of the form:

  -- path/to/file --

Keybindings:
\\{txtar-mode-map}"
  :syntax-table txtar-mode-syntax-table
  (setq-local comment-start "# ")
  (setq-local comment-start-skip "#+[[:space:]]*")
  (setq-local comment-end "")
  (setq-local font-lock-defaults
              '(txtar-font-lock-keywords
                nil   ; keywords-only — don't use syntax-table for strings/comments
                nil   ; case-fold
                nil   ; syntax-alist
                nil)) ; syntax-begin
  (setq-local indent-tabs-mode nil))

;;;###autoload
(add-to-list 'auto-mode-alist '("\\.txtar\\'" . txtar-mode))

(provide 'txtar-mode)

;;; txtar-mode.el ends here
