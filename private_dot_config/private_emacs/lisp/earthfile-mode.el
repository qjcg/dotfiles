;;; earthfile-mode.el --- Major mode for Earthly Earthfiles  -*- lexical-binding: t -*-

;; Keywords: languages earthly earthfile docker build
;; Package-Requires: ((emacs "26.1"))

;; SPDX-License-Identifier: GPL-3.0-only

;;; Commentary:

;; A major mode for Earthly Earthfiles (named Earthfile or with .earth
;; extension).  Provides syntax highlighting for the complete Earthfile
;; language reference as documented at https://docs.earthbuild.dev/docs/earthfile.
;;
;; Highlighted elements:
;;
;;   Target/command names      (my-target:, my-command:)
;;   VERSION directive         (VERSION 0.8)
;;   Dockerfile-like commands  (FROM, RUN, COPY, ARG, ENV, …)
;;   Earthly-specific commands (SAVE ARTIFACT, SAVE IMAGE, BUILD, …)
;;   Control flow keywords     (IF, ELSE IF, ELSE, FOR, WAIT, END, …)
;;   Command options           (--push, --no-cache, --secret, …)
;;   Environment variables     ($VAR, ${VAR})
;;   Dynamic expressions       ($(cmd ...))
;;   Quoted strings            ("…", '…')
;;   Comments                  (# …)
;;
;; Installation:
;;
;;   (add-to-list 'load-path "/path/to/earthfile-mode")
;;   (require 'earthfile-mode)
;;
;;   Files named Earthfile or matching *.earth are associated automatically.

;;; Code:

(defgroup earthfile nil
  "Major mode for Earthly Earthfiles."
  :group 'languages
  :prefix "earthfile-")

;;; Faces

(defface earthfile-target-face
  '((t :inherit font-lock-function-name-face :weight bold))
  "Face for target/command names (lines ending with `:')."
  :group 'earthfile)

(defface earthfile-version-face
  '((t :inherit font-lock-preprocessor-face :weight bold))
  "Face for the VERSION directive."
  :group 'earthfile)

(defface earthfile-command-face
  '((t :inherit font-lock-keyword-face))
  "Face for Earthfile commands (FROM, RUN, COPY, BUILD, …)."
  :group 'earthfile)

(defface earthfile-control-flow-face
  '((t :inherit font-lock-builtin-face :weight bold))
  "Face for control flow keywords (IF, FOR, WAIT, TRY, …)."
  :group 'earthfile)

(defface earthfile-clause-face
  '((t :inherit font-lock-builtin-face))
  "Face for clause keywords (WITH DOCKER, ELSE, END, …)."
  :group 'earthfile)

;;; Font-lock

(defconst earthfile--docker-commands
  '("ADD" "CMD" "COPY" "ENTRYPOINT" "ENV" "EXPOSE" "FROM"
    "HEALTHCHECK" "LABEL" "RUN" "SHELL" "USER" "VOLUME" "WORKDIR")
  "Dockerfile commands supported by Earthly.")

(defconst earthfile--earthly-commands
  '("ARG" "BUILD" "CACHE" "COMMAND" "DO" "FUNCTION" "GIT CLONE"
    "HOST" "IMPORT" "LET" "LOCALLY" "PROJECT" "REQUIRES"
    "SAVE ARTIFACT" "SAVE IMAGE" "SET" "SIGNATURE")
  "Earthly-specific commands.")

(defconst earthfile--control-flow
  '("ELSE" "END" "FINALLY" "FOR" "IF" "TRY" "WAIT")
  "Control flow keywords.")

(defconst earthfile--clause-keywords
  '("WITH DOCKER")
  "Multi-word clause keywords.")

(defconst earthfile-font-lock-keywords
  `(
    ;; ── Comments (line comments, no block comments in Earthfiles) ──
    ("^[[:space:]]*#.*" . font-lock-comment-face)

    ;; ── VERSION directive (must be first command in an Earthfile) ──
    ("^[[:space:]]*\\(VERSION\\)"
     . (1 'earthfile-version-face))

    ;; ── Target/command names: line, optional indent, then name, then colon
    ("^[[:space:]]*\\([[:alnum:]_/-]+\\):"
     . (1 'earthfile-target-face))

    ;; ── SAVE ARTIFACT / SAVE IMAGE / GIT CLONE / FROM DOCKERFILE
    ;;    Must appear before the single-word command rules.
    ("\\<\\(SAVE[[:space:]]+ARTIFACT\\|SAVE[[:space:]]+IMAGE\\|GIT[[:space:]]+CLONE\\|FROM[[:space:]]+DOCKERFILE\\|WITH[[:space:]]+DOCKER\\)"
     . (1 'earthfile-command-face))

    ;; ── Single-word Dockerfile commands ──
    (,(regexp-opt earthfile--docker-commands 'words)
     . 'earthfile-command-face)

    ;; ── Single-word Earthly commands ──
    (,(regexp-opt earthfile--earthly-commands 'words)
     . 'earthfile-command-face)

    ;; ── Control flow keywords ──
    (,(regexp-opt earthfile--control-flow 'words)
     . 'earthfile-control-flow-face)

    ;; ── Dollar- and parentheses-bounded dynamic expressions $(...) ──
    ("\\$\\(([^)]*)\\)"
     . (1 font-lock-variable-name-face))

    ;; ── Environment variable references: $VAR or ${VAR} ──
    ("\\$\\(?:{\\([^}\n]+\\)}\\|\\([[:alnum:]_]+\\)\\)"
     (1 font-lock-variable-name-face nil t)
     (2 font-lock-variable-name-face nil t))

    ;; ── Quoted strings: double-quoted ──
    ("\"[^\"\n]*\""
     . font-lock-string-face)

    ;; ── Quoted strings: single-quoted ──
    ("'[^'\n]*'"
     . font-lock-string-face)

    ;; ── AS LOCAL (SAVE ARTIFACT destination marker) ──
    ("\\<AS[[:space:]]+LOCAL\\>" . 'font-lock-constant-face)

    ;; ── Command options: --flag ──
    ("\\(--[[:alnum:]][[:alnum:]-]*\\)"
     . (1 font-lock-constant-face))
    )
  "Font-lock keyword specification for `earthfile-mode'.")

;;; Syntax table

(defvar earthfile-mode-syntax-table
  (let ((st (make-syntax-table)))
    ;; # starts a line comment; newline ends it
    (modify-syntax-entry ?# "<" st)
    (modify-syntax-entry ?\n ">" st)
    ;; Treat $ as a symbol constituent so $VAR is one token
    (modify-syntax-entry ?$ "_" st)
    ;; Single and double quotes delimit strings
    (modify-syntax-entry ?' "\"" st)
    (modify-syntax-entry ?\" "\"" st)
    st)
  "Syntax table for `earthfile-mode'.")

;;; Mode definition

;;;###autoload
(define-derived-mode earthfile-mode prog-mode "Earthfile"
  "Major mode for editing Earthly Earthfiles.

Provides syntax highlighting for the full Earthfile language:
target names, VERSION directives, Dockerfile-style commands
(FROM, RUN, COPY, ARG, ENV, ...), Earthly-specific commands
(SAVE ARTIFACT, SAVE IMAGE, BUILD, ...), control flow
(IF, FOR, WAIT, TRY, ...), options (--push, --secret, ...),
environment variables ($VAR, ${VAR}), dynamic expressions
($(...)), quoted strings, and comments.

Reference: https://docs.earthbuild.dev/docs/earthfile

\\{earthfile-mode-map}"
  :syntax-table earthfile-mode-syntax-table

  ;; Comment syntax so M-; works
  (setq-local comment-start "# ")
  (setq-local comment-start-skip "#+[[:space:]]*")
  (setq-local comment-end "")

  ;; Font-lock
  (setq-local font-lock-defaults
              '(earthfile-font-lock-keywords
                nil   ; keywords-only
                nil   ; case-fold
                nil))

  ;; Indentation: Earthfiles use spaces
  (setq-local indent-tabs-mode nil))

;;;###autoload
(add-to-list 'auto-mode-alist '("Earthfile\\(?:\\.[^/]*\\)?\\'" . earthfile-mode))
;;;###autoload
(add-to-list 'auto-mode-alist '("\\.earth\\'" . earthfile-mode))

(provide 'earthfile-mode)

;;; earthfile-mode.el ends here
