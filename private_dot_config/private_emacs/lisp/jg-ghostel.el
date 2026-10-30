;;; jg-ghostel.el --- Context-aware quake terminals -*- lexical-binding: t; -*-

;;; Commentary:
;; C-` summons the last-used terminal in the current project or global group.
;; C-c t offers creation, selection, cycling, and quake/full-frame display.
;; Ownership uses Ghostel identities, never the shell's changing directory.
;; Ghostel owns terminal processes; this module owns presentation per frame.

;;; Code:

(require 'cl-lib)
(require 'ghostel-project)

(defgroup jg-ghostel nil
  "Context-aware Ghostel terminals."
  :group 'ghostel)

(defcustom jg-ghostel-quake-height 0.35
  "Fraction of the frame's height used by the top terminal panel."
  :type 'float
  :group 'jg-ghostel)

(defconst jg-ghostel--global-name "*ghostel: global*"
  "Ghostel slot name identifying the managed global group.")

(defvar-local jg-ghostel--fullscreen nil
  "Non-nil when this terminal should display in full-frame mode.
Creation and `jg-ghostel-toggle-size' choose this preference.  Showing,
switching, or hiding never changes it; editor layouts remain per-frame.")

(cl-defstruct jg-ghostel--view
  window buffer return-window editor-configuration)

(defun jg-ghostel--root (root)
  "Normalize project ROOT like Ghostel's creation-time identities.
Avoid resolving remote paths, which could initiate a TRAMP connection."
  (if (file-remote-p root)
      (file-name-as-directory root)
    (abbreviate-file-name (file-name-as-directory (expand-file-name root)))))

(defun jg-ghostel--owner (buffer)
  "Return BUFFER's project root or `global', or nil if it is unmanaged."
  (when (buffer-live-p buffer)
    (with-current-buffer buffer
      (when (and (derived-mode-p 'ghostel-mode)
                 (eq (alist-get 'kind ghostel-identity) 'term))
        (or (when-let* ((root (alist-get 'project-root ghostel-identity)))
              (jg-ghostel--root root))
            (when (equal (alist-get 'name ghostel-identity)
                         jg-ghostel--global-name)
              'global))))))

(defun jg-ghostel--context ()
  "Return the current terminal's owner, current project root, or `global'."
  (or (jg-ghostel--owner (current-buffer))
      (when-let* ((project (project-current nil)))
        (jg-ghostel--root (project-root project)))
      'global))

(defun jg-ghostel--buffers (&optional context)
  "Return managed terminals in last-used order.
When CONTEXT is non-nil, restrict results to that project or global group."
  (cl-remove-if-not
   (lambda (buffer)
     (let ((owner (jg-ghostel--owner buffer)))
       (and owner (or (null context) (equal context owner)))))
   (buffer-list)))

(defun jg-ghostel--view ()
  "Return the selected frame's live terminal view, discarding stale state."
  (when-let* ((view (frame-parameter nil 'jg-ghostel-view)))
    (if (and (window-live-p (jg-ghostel--view-window view))
             (buffer-live-p (jg-ghostel--view-buffer view))
             (eq (window-buffer (jg-ghostel--view-window view))
                 (jg-ghostel--view-buffer view)))
        view
      ;; A manual buffer/window change relinquishes presentation ownership.
      (set-frame-parameter nil 'jg-ghostel-view nil)
      nil)))

(defun jg-ghostel--replace-buffer (window buffer)
  "Show BUFFER in WINDOW, preserving its side-window dedication."
  (let ((dedicated (window-dedicated-p window)))
    (set-window-dedicated-p window nil)
    (unwind-protect
        (set-window-buffer window buffer)
      (set-window-dedicated-p window dedicated))))

(defun jg-ghostel--display-buffer (buffer alist)
  "Display BUFFER in its remembered mode and return the frame's terminal window.
ALIST may specify `jg-ghostel-initial-fullscreen' when creating a terminal,
so Ghostel sees its final window dimensions before spawning the shell."
  (when-let* ((initial-mode (assq 'jg-ghostel-initial-fullscreen alist)))
    (with-current-buffer buffer
      (setq jg-ghostel--fullscreen (not (null (cdr initial-mode))))))
  (let* ((fullscreen (buffer-local-value 'jg-ghostel--fullscreen buffer))
         (view (jg-ghostel--view)))
    ;; The incoming terminal owns its mode.  Restore the editor first when
    ;; changing modes; merely swapping buffers would inherit the old mode.
    (when (and view
               (not (eq fullscreen
                        (not (null (jg-ghostel--view-editor-configuration view))))))
      (jg-ghostel--hide)
      (setq view nil))
    (if view
        (jg-ghostel--replace-buffer (jg-ghostel--view-window view) buffer)
      (setq view (make-jg-ghostel--view
                  :buffer buffer :return-window (selected-window)))
      (if fullscreen
          ;; Expand directly, without a temporary panel that could round
          ;; odd-sized editor splits before their layout is saved.
          (jg-ghostel--expand view)
        (setf (jg-ghostel--view-window view)
              (display-buffer-in-side-window
               buffer `((side . top) (slot . 0)
                        (window-height . ,jg-ghostel-quake-height))))))
    (unless (window-live-p (jg-ghostel--view-window view))
      (user-error "Cannot display the Ghostel terminal"))
    (setf (jg-ghostel--view-buffer view) buffer)
    (set-frame-parameter nil 'jg-ghostel-view view)
    (jg-ghostel--view-window view)))

(defun jg-ghostel--hide ()
  "Hide the terminal without killing its process or resetting its display mode."
  (when-let* ((view (jg-ghostel--view)))
    (set-frame-parameter nil 'jg-ghostel-view nil)
    (if (jg-ghostel--view-editor-configuration view)
        (set-window-configuration
         (jg-ghostel--view-editor-configuration view))
      (delete-window (jg-ghostel--view-window view)))
    (when (window-live-p (jg-ghostel--view-return-window view))
      (select-window (jg-ghostel--view-return-window view)))))

(defun jg-ghostel--buffer-killed ()
  "Restore every frame displaying the terminal being killed."
  (let ((buffer (current-buffer)))
    (dolist (frame (frame-list))
      (when-let* ((view (frame-parameter frame 'jg-ghostel-view))
                  ((eq buffer (jg-ghostel--view-buffer view))))
        (with-selected-frame frame
          (jg-ghostel--hide))))))

(defun jg-ghostel--setup-buffer ()
  "Arrange for terminal exit or explicit buffer killing to restore the editor."
  (add-hook 'kill-buffer-hook #'jg-ghostel--buffer-killed nil t))

(defun jg-ghostel--create (context &optional fullscreen)
  "Create a terminal belonging to CONTEXT, in quake mode unless FULLSCREEN."
  (let* ((buffers (jg-ghostel--buffers context))
         (instance (1+ (cl-loop for buffer in buffers
                               maximize (or (alist-get
                                             'instance
                                             (buffer-local-value
                                              'ghostel-identity buffer))
                                            0) into highest
                               finally return (or highest 0))))
         (global (eq context 'global))
         (default-directory (if global (expand-file-name "~/") context))
         (label (if global "global"
                  (file-name-nondirectory (directory-file-name context))))
         (identity `((kind . term)
                     ,(if global `(name . ,jg-ghostel--global-name)
                        `(project-root . ,context))
                     (instance . ,instance)))
         ;; Restore presentation too if module loading or spawning fails.
         (configuration (current-window-configuration))
         (old-view (when-let* ((view (jg-ghostel--view)))
                     (copy-jg-ghostel--view view))))
    (condition-case error
        (ghostel-create (format "*ghostel: %s #%d*" label instance)
                        `((jg-ghostel--display-buffer)
                          (jg-ghostel-initial-fullscreen . ,fullscreen))
                        identity)
      ((error quit)
       (set-window-configuration configuration)
       (set-frame-parameter nil 'jg-ghostel-view old-view)
       (signal (car error) (cdr error))))))

(defun jg-ghostel--open (context &optional new)
  "Show CONTEXT's last-used terminal, creating it if missing or NEW is non-nil."
  (if-let* ((buffer (and (not new) (car (jg-ghostel--buffers context)))))
      (pop-to-buffer buffer '((jg-ghostel--display-buffer)))
    (jg-ghostel--create context)))

(defun jg-ghostel--toggle (context &optional new)
  "Summon, focus, or hide CONTEXT's terminal; NEW forces a fresh terminal."
  (let ((view (jg-ghostel--view)))
    (if (and (not new) view
             (equal context (jg-ghostel--owner (jg-ghostel--view-buffer view))))
        (if (eq (selected-window) (jg-ghostel--view-window view))
            (jg-ghostel--hide)
          (pop-to-buffer (jg-ghostel--view-buffer view)
                         '((jg-ghostel--display-buffer))))
      (jg-ghostel--open context new))))

;;;###autoload
(defun jg-ghostel-toggle (&optional new)
  "Toggle the context's terminal.  With prefix NEW, create another in quake mode."
  (interactive "P")
  (jg-ghostel--toggle (jg-ghostel--context) new))

(defun jg-ghostel-new ()
  "Create another quake terminal in the current project or global group."
  (interactive)
  (jg-ghostel--open (jg-ghostel--context) t))

(defun jg-ghostel-new-fullscreen ()
  "Create a fullscreen terminal in the current project or global group."
  (interactive)
  (jg-ghostel--create (jg-ghostel--context) t))

(defun jg-ghostel-global (&optional new)
  "Toggle the global terminal, even in a project.  Prefix NEW creates a quake one."
  (interactive "P")
  (jg-ghostel--toggle 'global new))

(defun jg-ghostel-global-new ()
  "Create another global quake terminal, even in a project."
  (interactive)
  (jg-ghostel--open 'global t))

(defun jg-ghostel-project (&optional new)
  "Show the selected project's last-used terminal.  Prefix NEW creates a quake one.
Unlike the toggle, this project-switch action always shows the terminal."
  (interactive "P")
  (jg-ghostel--open (jg-ghostel--root (project-root (project-current t))) new))

(defun jg-ghostel--annotation (name)
  "Annotate terminal NAME with its owner, process status, and terminal title."
  (when-let* ((buffer (get-buffer name)))
    (format "  [%s]%s" (jg-ghostel--owner buffer)
            (or (ghostel-annotate-buffer name) ""))))

(defun jg-ghostel-switch (&optional all)
  "Choose a terminal in the current context; with ALL, choose across contexts."
  (interactive "P")
  (let* ((buffers (jg-ghostel--buffers (unless all (jg-ghostel--context))))
         (names (mapcar #'buffer-name buffers))
         (completion-extra-properties
          '(:annotation-function jg-ghostel--annotation)))
    (unless names
      (user-error "No Ghostel terminals in this %s" (if all "session" "context")))
    (let ((buffer (get-buffer (completing-read "Ghostel terminal: " names nil t))))
      (unless (jg-ghostel--owner buffer)
        (user-error "The selected Ghostel terminal has exited"))
      (pop-to-buffer buffer '((jg-ghostel--display-buffer))))))

(defun jg-ghostel-switch-all ()
  "Choose from all managed project and global terminals."
  (interactive)
  (jg-ghostel-switch t))

(defun jg-ghostel--cycle (direction)
  "Switch DIRECTION slots within the current terminal context, wrapping around."
  (let* ((buffers (sort (jg-ghostel--buffers (jg-ghostel--context))
                        (lambda (a b)
                          (< (alist-get 'instance
                                        (buffer-local-value 'ghostel-identity a) 0)
                             (alist-get 'instance
                                        (buffer-local-value 'ghostel-identity b) 0)))))
         (index (cl-position (current-buffer) buffers))
         (count (length buffers)))
    (unless buffers
      (user-error "No Ghostel terminals in this context"))
    (pop-to-buffer
     (nth (if index (mod (+ index direction) count)
            (if (> direction 0) 0 (1- count)))
          buffers)
     '((jg-ghostel--display-buffer)))))

(defun jg-ghostel-next ()
  "Show the next terminal in the current context, wrapping around."
  (interactive)
  (jg-ghostel--cycle 1))

(defun jg-ghostel-previous ()
  "Show the previous terminal in the current context, wrapping around."
  (interactive)
  (jg-ghostel--cycle -1))

(defun jg-ghostel--expand (view)
  "Expand terminal VIEW, saving the editor layout without changing its preference."
  ;; A side window cannot be made the sole window.  Save the editor
  ;; layout without the panel, then expand a normal window instead.
  (when (window-live-p (jg-ghostel--view-window view))
    (delete-window (jg-ghostel--view-window view)))
  (let ((return-window (jg-ghostel--view-return-window view)))
    (select-window
     (if (and (window-live-p return-window)
              (not (window-parameter return-window 'window-side)))
         return-window
       (cl-find-if (lambda (window)
                     (not (window-parameter window 'window-side)))
                   (window-list nil 'nomini)))))
  (setf (jg-ghostel--view-editor-configuration view)
        (current-window-configuration))
  ;; Invoking from a dedicated editor or sidebar must also work.  Its
  ;; dedication is part of the saved configuration and restored later.
  (set-window-dedicated-p (selected-window) nil)
  (switch-to-buffer (jg-ghostel--view-buffer view))
  (let ((ignore-window-parameters t))
    (delete-other-windows))
  (setf (jg-ghostel--view-window view) (selected-window)))

(defun jg-ghostel-toggle-size ()
  "Toggle and remember only this terminal's quake/full-frame display mode.
Switching and hiding terminals leave their preferences unchanged."
  (interactive)
  (unless (jg-ghostel--view)
    (jg-ghostel--open (jg-ghostel--context)))
  (let* ((view (jg-ghostel--view))
         (buffer (jg-ghostel--view-buffer view)))
    (with-current-buffer buffer
      (setq jg-ghostel--fullscreen
            (null (jg-ghostel--view-editor-configuration view))))
    (pop-to-buffer buffer '((jg-ghostel--display-buffer)))))

(defvar jg-ghostel-prefix-map (make-sparse-keymap)
  "Context-aware terminal commands.")

;; Configure in place so reloading adds bindings to input-mode maps that
;; already reference this prefix map.
(define-keymap :keymap jg-ghostel-prefix-map
  "n" #'jg-ghostel-new
  "N" #'jg-ghostel-new-fullscreen
  "b" #'jg-ghostel-switch
  "t" #'jg-ghostel-switch-all
  "]" #'jg-ghostel-next
  "[" #'jg-ghostel-previous
  "f" #'jg-ghostel-toggle-size
  "g" #'jg-ghostel-global
  "G" #'jg-ghostel-global-new)

(keymap-global-set "C-`" #'jg-ghostel-toggle)
(keymap-global-set "C-c t" jg-ghostel-prefix-map)
(keymap-set ghostel-mode-map "C-`" #'jg-ghostel-toggle)
(keymap-set ghostel-mode-map "C-c t" jg-ghostel-prefix-map)
;; Char mode has no parent and overrides minor modes.  Reserve our controls
;; there as well; C-c C-c / C-c C-q allow literal terminal control keys.
(keymap-set ghostel-char-mode-map "C-`" #'jg-ghostel-toggle)
(keymap-set ghostel-char-mode-map "C-c" (keymap-lookup ghostel-mode-map "C-c"))
(keymap-set ghostel-char-mode-map "C-u" #'universal-argument)
(setopt ghostel-keymap-exceptions
        (cons "C-`" (remove "C-`" ghostel-keymap-exceptions)))
(setopt ghostel-project-buffer-scope 'identity)
(add-hook 'ghostel-mode-hook #'jg-ghostel--setup-buffer)
;; Also restore presentation if a previously opened terminal is adopted.
(dolist (buffer (jg-ghostel--buffers))
  (with-current-buffer buffer (jg-ghostel--setup-buffer)))

(provide 'jg-ghostel)
;;; jg-ghostel.el ends here
