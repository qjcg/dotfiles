;;; drakon-mode.el --- Major mode for .drakon diagram DSL files -*- lexical-binding: t; -*-

;; Author: John Gosset
;; Version: 1.0.0
;; Package-Requires: ((emacs "29.1"))
;; Keywords: languages, outlines, diagrams

;;; Commentary:

;; Syntax highlighting and org-style visibility cycling for the
;; .drakon diagram DSL.
;;
;; Keys:
;;   TAB / <tab> / C-i  On a heading: cycle subtree visibility.
;;                      On a content line: indent to next stop.
;;   S-TAB / <backtab>  Cycle the whole buffer.
;;   C-u TAB            Cycle the whole buffer.
;;   C-c C-c            Render to SVG and display in a new window.
;;
;; A foldable heading is one of:
;;   diagram ...
;;   Branch name:
;;   yes: / no: / default: / case-label:
;;   if ... / select ... / for ... / loop ... / input ... / output ...

;;; Code:

(require 'outline)

(defgroup drakon nil
  "Editing support for the .drakon diagram DSL."
  :group 'languages
  :prefix "drakon-")

(defcustom drakon-indent-offset 4
  "Number of spaces used for one indentation level in \`drakon-mode'."
  :type 'integer
  :safe #'integerp
  :group 'drakon)

(defvar-local drakon--global-cycle-state 'all)

(defconst drakon--keywords
  '("diagram" "if" "select" "for" "loop" "input" "output" "goto" "end"
    "call" "parallel" "timer" "pause"
    "process" "simpleinput" "simpleoutput" "comment" "ctrlstart" "ctrlend" "duration"))

(defconst drakon--block-keywords
  '("if" "select" "for" "loop" "input" "output" "parallel" "timer" "pause"
    "process" "simpleinput" "simpleoutput"))

;; No leading "^": outline-minor-mode prepends its own when searching,
;; and outline-on-heading-p calls (looking-at outline-regexp) at bol.
(defconst drakon--outline-regexp
  (concat "[[:space:]]*"
          "\\("
          "diagram\\_>.*"
          "\\|"
          (regexp-opt drakon--block-keywords 'symbols)
          ".*"
          "\\|"
          ".*:[[:space:]]*$"
          "\\)"))

(defconst drakon-font-lock-keywords
  `(("^\\s-*//.*$" . font-lock-comment-face)
    ("^\\s-*# .*$" . font-lock-comment-face)
    ("^\\s-*\\(diagram\\)\\s-+\\(.+\\)$"
     (1 font-lock-keyword-face)
     (2 font-lock-function-name-face))
    ("^\\([^[:space:]\n].*[^:]\\):\\s-*$" . font-lock-function-name-face)
    ("^\\s-+\\(yes\\|no\\|default\\):\\s-*$" . font-lock-builtin-face)
    ("^\\s-+\\([^:[:space:]\n][^:\n]*\\):\\s-*$" . font-lock-constant-face)
    (,(regexp-opt drakon--keywords 'symbols) . font-lock-keyword-face)
    ("^\\s-*\\([[:alnum:]_.-]+\\)\\s-*=.*$" (1 font-lock-variable-name-face))
    ("\\<\\(yes\\|no\\)\\>" . font-lock-builtin-face)))

(defvar drakon-mode-syntax-table
  (let ((st (make-syntax-table)))
    (modify-syntax-entry ?/ ". 124b" st)
    (modify-syntax-entry ?\n "> b" st)
    (modify-syntax-entry ?_ "w" st)
    (modify-syntax-entry ?- "w" st)
    st)
  "Syntax table for \`drakon-mode'.")

(defun drakon--indentation ()
  "Return indentation of the current line."
  (save-excursion
    (back-to-indentation)
    (current-column)))

(defun drakon-outline-level ()
  "Return outline level for the current .drakon heading."
  (save-excursion
    (back-to-indentation)
    (cond
     ((looking-at-p "diagram\\_>") 1)
     ((and (= (drakon--indentation) 0)
           (looking-at-p ".+:[[:space:]]*$"))
      2)
     (t (+ 3 (/ (drakon--indentation) drakon-indent-offset))))))

(defun drakon--heading-p ()
  "Return non-nil when the current line is a foldable heading."
  (save-excursion
    (beginning-of-line)
    (looking-at-p drakon--outline-regexp)))

(defun drakon--goto-heading ()
  "Move to the nearest heading at or before point.
Return non-nil on success, nil when point is before the first heading."
  (if (drakon--heading-p)
      (progn (beginning-of-line) t)
    (outline-previous-heading)
    (beginning-of-line)
    (drakon--heading-p)))

(defun drakon--subtree-end ()
  "Return the end position of the current outline subtree."
  (save-excursion
    (outline-end-of-subtree)
    (point)))

(defun drakon--subtree-folded-p ()
  "Return non-nil if the current heading's body is hidden."
  (save-excursion
    (drakon--goto-heading)
    (let ((end (drakon--subtree-end)))
      (forward-line 1)
      (and (< (point) end)
           (invisible-p (point))))))

(defun drakon--subtree-has-hidden-p ()
  "Return non-nil if the current subtree contains any hidden text."
  (save-excursion
    (drakon--goto-heading)
    (let ((end (drakon--subtree-end))
          (found nil))
      (forward-line 1)
      (while (and (not found) (< (point) end))
        (when (invisible-p (point))
          (setq found t))
        (goto-char (or (next-single-char-property-change (point) 'invisible nil end)
                       end)))
      found)))

(defun drakon-cycle (&optional global)
  "Cycle visibility of the current subtree, like Org's TAB.
With GLOBAL or a prefix argument, cycle the whole buffer instead.
Does nothing when point is before the first heading."
  (interactive "P")
  (if global
      (drakon-cycle-global)
    (save-excursion
      (when (drakon--goto-heading)
        (cond
         ((drakon--subtree-folded-p)     (outline-show-children))
         ((drakon--subtree-has-hidden-p) (outline-show-subtree))
         (t                              (outline-hide-subtree)))))))

(defun drakon-cycle-global ()
  "Cycle the whole buffer: overview -> contents -> all text."
  (interactive)
  (pcase drakon--global-cycle-state
    ('all
     (outline-hide-sublevels 1)
     (setq drakon--global-cycle-state 'overview))
    ('overview
     (outline-show-all)
     (outline-hide-body)
     (setq drakon--global-cycle-state 'contents))
    (_
     (outline-show-all)
     (setq drakon--global-cycle-state 'all))))

(defun drakon-indent-line ()
  "Indent current line to the next stop of `drakon-indent-offset'.
Advances indentation one step at a time (cycles back to 0 after the
maximum meaningful level)."
  (interactive)
  (let* ((pos     (- (point-max) (point)))
         (current (current-indentation))
         (target  (* drakon-indent-offset
                     (1+ (/ current drakon-indent-offset)))))
    (indent-line-to target)
    (when (> (- (point-max) pos) (point))
      (goto-char (- (point-max) pos)))))

(defcustom drakon-cli-executable "drakon"
  "Path to the drakon CLI executable."
  :type 'string
  :group 'drakon)

(defun drakon-render ()
  "Run the drakon CLI on the current buffer and display the SVG output.
Saves the buffer first if it is visiting a file, otherwise writes its
contents to a temporary input file.  The SVG is written to a second
temporary file and displayed in a new window via `image-mode'."
  (interactive)
  (let* ((src-file (if (and buffer-file-name (not (buffer-modified-p)))
                       buffer-file-name
                     ;; Write unsaved/scratch content to a temp file.
                     (let ((tmp (make-temp-file "drakon-in-" nil ".drakon")))
                       (write-region (point-min) (point-max) tmp)
                       tmp)))
         (svg-file (make-temp-file "drakon-out-" nil ".svg"))
         (exit-code (call-process drakon-cli-executable nil
                                  (get-buffer-create "*drakon-render*")
                                  nil
                                  "-in"  src-file
                                  "-out" svg-file)))
    (if (zerop exit-code)
        (let ((buf (find-file-other-window svg-file)))
          (with-current-buffer buf
            (image-mode)
            (setq-local revert-buffer-function
                        (lambda (&rest _) (image-mode)))))
      (display-buffer (get-buffer "*drakon-render*"))
      (user-error "drakon exited with code %d; see *drakon-render* for details"
                  exit-code))))

(defun drakon-tab ()
  "Context-sensitive TAB: cycle subtree on headings, indent elsewhere.
With a prefix argument, delegate to `drakon-cycle-global' regardless
of point position."
  (interactive)
  (cond
   (current-prefix-arg (drakon-cycle-global))
   ((drakon--heading-p)  (drakon-cycle))
   (t                    (drakon-indent-line))))

(defvar-keymap drakon-mode-map
  :parent prog-mode-map
  "TAB"       #'drakon-tab
  "<tab>"     #'drakon-tab
  "C-i"       #'drakon-tab
  "<backtab>" #'drakon-cycle-global
  "S-TAB"     #'drakon-cycle-global
  "C-c C-c"   #'drakon-render)

;;;###autoload
(define-derived-mode drakon-mode prog-mode "DRAKON"
  "Major mode for editing minimal .drakon diagram DSL files."
  :syntax-table drakon-mode-syntax-table
  ;; outline-regexp, outline-level, and outline-minor-mode are configured via
  ;; :after-hook so they are set after all mode hooks have run.  Packages such
  ;; as outshine activate on outline-minor-mode-hook and would otherwise
  ;; clobber these buffer-local values.
  :after-hook
  (progn
    (when (bound-and-true-p outshine-mode)
      (outshine-mode -1))
    (setq-local outline-regexp drakon--outline-regexp)
    (setq-local outline-level  #'drakon-outline-level)
    (outline-minor-mode 1))
  (setq-local font-lock-defaults '(drakon-font-lock-keywords))
  (setq-local comment-start "// ")
  (setq-local comment-end   "")
  (setq-local indent-line-function #'drakon-indent-line))

;;;###autoload
(add-to-list 'auto-mode-alist '("\\.drakon\\'" . drakon-mode))

(provide 'drakon-mode)

;;; drakon-mode.el ends here
