;;; jg-dashboard-panels.el --- Movable text panels -*- lexical-binding: t; -*-

;;; Commentary:
;; A fixed-pitch, invisible-grid canvas for ordinary Emacs text, not images.
;; Render specs carry :id, :title, :x, :y, :width, and a :render function which
;; accepts the interior width and returns a string.  Layout and input live here;
;; widget data, refresh, and animation remain in jg-dashboard.el.

;;; Code:

(require 'cl-lib)
(require 'subr-x)

(defgroup jg-dashboard-panels nil
  "Movable dashboard panels."
  :group 'jg-dashboard)

(defcustom jg-dashboard-panel-grid '(4 . 2)
  "Invisible snapping grid in character columns and text rows.
Both dimensions must be positive integers."
  :type '(cons (integer :tag "Columns") (integer :tag "Rows")))

(defcustom jg-dashboard-panel-layout nil
  "Saved panel positions, an alist of IDs to :x/:y plists.
Coordinates are character columns and text rows relative to the canvas.
For example: ((weather . (:x 0 :y 0)) (quote . (:x 48 :y 0))).
Drag title bars or use M-arrow keys to move panels.  S saves the current
layout through Customize; R restores the automatic layout in this buffer.
Narrow windows reflow without overwriting saved positions."
  :type '(alist :key-type symbol :value-type sexp))

(defface jg-dashboard-panel-border
  '((t :inherit shadow))
  "Face for panel borders.")

(defface jg-dashboard-panel-title
  '((t :inherit font-lock-function-name-face :weight bold))
  "Face for draggable panel titles.")

(defvar-local jg-dashboard-panels-redraw-function nil
  "No-argument function redrawing the current dashboard.")
(defvar-local jg-dashboard-panels-dragging nil)
(defvar-local jg-dashboard-panels--panels nil)
(defvar-local jg-dashboard-panels--start nil)
(defvar-local jg-dashboard-panels--width nil)
(defvar-local jg-dashboard-panels--height nil)
(defvar-local jg-dashboard-panels--priority nil)
(cl-defstruct (jg-dashboard-panels--panel (:constructor jg-dashboard-panels--make-panel))
  id title x y width lines)

(defun jg-dashboard-panels--step (axis)
  "Return the validated snapping step along AXIS, x or y."
  (let ((step (if (eq axis 'x) (car jg-dashboard-panel-grid) (cdr jg-dashboard-panel-grid))))
    (unless (and (integerp step) (> step 0))
      (user-error "Panel grid dimensions must be positive integers"))
    step))

(defun jg-dashboard-panels--snap (value axis)
  "Snap VALUE to the nearest nonnegative grid position on AXIS."
  (let ((step (jg-dashboard-panels--step axis)))
    (* step (max 0 (floor (+ (/ (float value) step) 0.5))))))

(defun jg-dashboard-panels--fit-lines (text width)
  "Wrap TEXT to WIDTH columns, preserving faces and all content."
  (cl-loop for line in (split-string (string-trim-right text "\n+") "\n")
           append
           (if (<= (string-width line) width)
               ;; Table alignment and indented continuation lines are significant.
               (list line)
             (with-temp-buffer
               (insert line)
               (let ((fill-column width)) (fill-region (point-min) (point-max)))
               (cl-loop for part in (split-string (buffer-string) "\n") append
                        (let (pieces)
                          ;; Also split long unbreakable words, never truncate them.
                          (while (> (string-width part) width)
                            (let ((head (truncate-string-to-width part width)))
                              (push head pieces)
                              (setq part (substring part (length head)))))
                          (nreverse (cons part pieces))))))))

(defun jg-dashboard-panels--height (panel)
  "Return PANEL's height, including its top and bottom borders."
  (+ 2 (length (jg-dashboard-panels--panel-lines panel))))

(defun jg-dashboard-panels--overlap-p (a b)
  "Return non-nil if rectangles A and B overlap."
  (and (< (jg-dashboard-panels--panel-x a)
          (+ (jg-dashboard-panels--panel-x b) (jg-dashboard-panels--panel-width b)))
       (< (jg-dashboard-panels--panel-x b)
          (+ (jg-dashboard-panels--panel-x a) (jg-dashboard-panels--panel-width a)))
       (< (jg-dashboard-panels--panel-y a)
          (+ (jg-dashboard-panels--panel-y b) (jg-dashboard-panels--height b)))
       (< (jg-dashboard-panels--panel-y b)
          (+ (jg-dashboard-panels--panel-y a) (jg-dashboard-panels--height a)))))

(defun jg-dashboard-panels--layout (specs width)
  "Lay out SPECS within WIDTH, snapping origins and resolving overlaps.
The last moved panel has priority; collisions push other panels down."
  (let (placed)
    (dolist (spec (if jg-dashboard-panels--priority
                     (append (cl-remove-if-not
                              (lambda (s) (eq (plist-get s :id) jg-dashboard-panels--priority)) specs)
                             (cl-remove-if
                              (lambda (s) (eq (plist-get s :id) jg-dashboard-panels--priority)) specs))
                   specs))
      (let* ((id (plist-get spec :id))
             (saved (alist-get id jg-dashboard-panel-layout))
             (panel-width (min width (max 20 (plist-get spec :width))))
             (x (or (plist-get saved :x) (plist-get spec :x) 0))
             (y (or (plist-get saved :y) (plist-get spec :y) 0))
             (panel (jg-dashboard-panels--make-panel
                     :id id :title (plist-get spec :title)
                     :x (min (jg-dashboard-panels--snap x 'x)
                             (* (jg-dashboard-panels--step 'x)
                                (/ (- width panel-width) (jg-dashboard-panels--step 'x))))
                     :y (jg-dashboard-panels--snap y 'y) :width panel-width
                     :lines (jg-dashboard-panels--fit-lines
                             (funcall (plist-get spec :render) (- panel-width 4)) (- panel-width 4)))))
        (while (cl-some (lambda (other) (jg-dashboard-panels--overlap-p panel other)) placed)
          (cl-incf (jg-dashboard-panels--panel-y panel) (jg-dashboard-panels--step 'y)))
        (push panel placed)))
    (nreverse placed)))

(defvar jg-dashboard-panels--title-map
  (let ((map (make-sparse-keymap)))
    (define-key map [down-mouse-1] #'jg-dashboard-panels-drag)
    map))

(defun jg-dashboard-panels--box (panel)
  "Return the boxed display lines for PANEL with title-bar input properties."
  (let* ((width (jg-dashboard-panels--panel-width panel))
         (title (truncate-string-to-width (jg-dashboard-panels--panel-title panel) (- width 6)))
         (top (concat "╭─ " title " " (make-string (- width 5 (string-width title)) ?─) "╮")))
    (add-text-properties 0 (length top)
                         '(face jg-dashboard-panel-title mouse-face highlight
                           jg-dashboard-panel-header t
                           help-echo "Drag to move; M-arrow keys snap to the invisible grid") top)
    (put-text-property 0 (length top) 'keymap jg-dashboard-panels--title-map top)
    (append (list top)
            (mapcar (lambda (line)
                      (concat (propertize "│ " 'face 'jg-dashboard-panel-border)
                              line (make-string (- width 4 (string-width line)) ?\s)
                              (propertize " │" 'face 'jg-dashboard-panel-border)))
                    (jg-dashboard-panels--panel-lines panel))
            (list (propertize (concat "╰" (make-string (- width 2) ?─) "╯")
                              'face 'jg-dashboard-panel-border)))))

(defun jg-dashboard-panels-render (specs width)
  "Insert a bordered, movable panel canvas for SPECS, fitting WIDTH columns.
Save row geometry for input and content positions.  The caller owns redraw."
  (setq jg-dashboard-panels--panels (jg-dashboard-panels--layout specs width)
        jg-dashboard-panels--width width
        jg-dashboard-panels--height
        (+ 6 (cl-loop for panel in jg-dashboard-panels--panels maximize
                      (+ (jg-dashboard-panels--panel-y panel) (jg-dashboard-panels--height panel)))))
  (when (markerp jg-dashboard-panels--start) (set-marker jg-dashboard-panels--start nil))
  (setq jg-dashboard-panels--start (copy-marker (point)))
  (let ((rows (cl-loop repeat jg-dashboard-panels--height collect (make-string width ?\s))))
    (dolist (panel jg-dashboard-panels--panels)
      (cl-loop for line in (jg-dashboard-panels--box panel)
               for y from (jg-dashboard-panels--panel-y panel) do
               (let* ((x (jg-dashboard-panels--panel-x panel))
                      (row (nth y rows))
                      (before (truncate-string-to-width row x))
                      (after (substring row
                                        (length (truncate-string-to-width row (+ x (string-width line)))))))
                 (add-text-properties 0 (length line)
                                      (list 'jg-dashboard-panel (jg-dashboard-panels--panel-id panel)) line)
                 (setf (nth y rows) (concat before line after)))))
    (dolist (row rows) (insert row "\n")))
  (add-face-text-property jg-dashboard-panels--start (point) 'fixed-pitch t)
  (when jg-dashboard-panels--priority
    ;; Persist collision resolution in the buffer, not in the user's file.
    (setq-local jg-dashboard-panel-layout (jg-dashboard-panels--positions))
    (setq jg-dashboard-panels--priority nil)))

(defun jg-dashboard-panels--find (id)
  "Return the rendered panel with ID."
  (cl-find id jg-dashboard-panels--panels :key #'jg-dashboard-panels--panel-id))

(defun jg-dashboard-panels-content (id)
  "Return (WIDTH . ROW-POSITIONS) for the interior of the panel with ID.
This lets an animation replace existing cells rather than expand canvas rows."
  (when-let* ((panel (jg-dashboard-panels--find id)))
    (save-excursion
      (goto-char jg-dashboard-panels--start)
      (forward-line (1+ (jg-dashboard-panels--panel-y panel)))
      (let (positions)
        (dotimes (_ (length (jg-dashboard-panels--panel-lines panel)))
          (move-to-column (+ 2 (jg-dashboard-panels--panel-x panel)))
          (push (point) positions)
          (forward-line 1))
        (cons (- (jg-dashboard-panels--panel-width panel) 4) (nreverse positions))))))

(defun jg-dashboard-panels--positions ()
  "Return current positions, preserving entries for temporarily hidden panels."
  (let ((layout (copy-tree jg-dashboard-panel-layout)))
    (dolist (panel jg-dashboard-panels--panels)
      (setf (alist-get (jg-dashboard-panels--panel-id panel) layout)
            (list :x (jg-dashboard-panels--panel-x panel) :y (jg-dashboard-panels--panel-y panel))))
    layout))

(defun jg-dashboard-panels--redraw ()
  "Redraw through the owning dashboard, without fetching external data."
  (unless (functionp jg-dashboard-panels-redraw-function)
    (user-error "Open the dashboard first"))
  (funcall jg-dashboard-panels-redraw-function))

(defun jg-dashboard-panels-move (id x y)
  "Move the panel with ID to X/Y, snapping and keeping all panels nonoverlapping."
  (unless (jg-dashboard-panels--find id) (user-error "No panel named %s" id))
  (setq-local jg-dashboard-panel-layout (jg-dashboard-panels--positions))
  (setf (alist-get id jg-dashboard-panel-layout) (list :x x :y y))
  (setq jg-dashboard-panels--priority id)
  (jg-dashboard-panels--redraw)
  (when-let* ((content (jg-dashboard-panels-content id)))
    (goto-char (cadr content))))

(defun jg-dashboard-panels--nudge (dx dy)
  "Move the panel at point DX/DY grid cells."
  (let* ((id (or (get-text-property (point) 'jg-dashboard-panel)
                 (intern (completing-read "Move panel: "
                                          (mapcar (lambda (p) (symbol-name (jg-dashboard-panels--panel-id p)))
                                                  jg-dashboard-panels--panels) nil t))))
         (panel (jg-dashboard-panels--find id)))
    (unless panel (user-error "Point is not in a dashboard panel"))
    (jg-dashboard-panels-move id (+ (jg-dashboard-panels--panel-x panel) (* dx (jg-dashboard-panels--step 'x)))
                             (+ (jg-dashboard-panels--panel-y panel) (* dy (jg-dashboard-panels--step 'y))))))

(defun jg-dashboard-panels-left ()
  "Move the panel at point left by one grid cell."
  (interactive) (jg-dashboard-panels--nudge -1 0))
(defun jg-dashboard-panels-right ()
  "Move the panel at point right by one grid cell."
  (interactive) (jg-dashboard-panels--nudge 1 0))
(defun jg-dashboard-panels-up ()
  "Move the panel at point up by one grid cell."
  (interactive) (jg-dashboard-panels--nudge 0 -1))
(defun jg-dashboard-panels-down ()
  "Move the panel at point down by one grid cell."
  (interactive) (jg-dashboard-panels--nudge 0 1))

(defun jg-dashboard-panels-save ()
  "Save the current layout through Customize, including hidden panel positions."
  (interactive)
  (unless jg-dashboard-panels--panels (user-error "Open the dashboard first"))
  (unless init-file-user
    (user-error "Start Emacs normally (without -q/-Q) to save layout customizations"))
  (customize-save-variable 'jg-dashboard-panel-layout
                           (when jg-dashboard-panel-layout (jg-dashboard-panels--positions)))
  (message "Dashboard layout saved"))

(defun jg-dashboard-panels-reset ()
  "Restore automatic layout in this buffer.  Use S to save the reset."
  (interactive)
  (setq-local jg-dashboard-panel-layout nil)
  (setq jg-dashboard-panels--priority nil)
  (jg-dashboard-panels--redraw))

(defun jg-dashboard-panels--event-cell (position)
  "Return the canvas column/row for mouse POSITION, or nil outside this canvas."
  (let ((window (posn-window position))
        (point (posn-point position)))
    (when (and (windowp window) (eq (window-buffer window) (current-buffer))
               (integer-or-marker-p point) jg-dashboard-panels--start)
      (save-excursion
        (goto-char point)
        (let ((x (current-column))
              (y (- (line-number-at-pos) (line-number-at-pos jg-dashboard-panels--start))))
          (when (and (>= x 0) (< x jg-dashboard-panels--width)
                     (>= y 0) (< y jg-dashboard-panels--height))
            (cons x y)))))))

(defun jg-dashboard-panels-drag (event)
  "Drag a panel title using EVENT; snap on release, Escape or C-g cancels.
The title is highlighted during dragging; messages preview snapped coordinates."
  (interactive "e")
  (let* ((start (event-start event))
         (window (posn-window start)))
    (when (windowp window)
      (with-current-buffer (window-buffer window)
        (let* ((point (posn-point start))
               (id (and (integer-or-marker-p point) (get-text-property point 'jg-dashboard-panel)))
               (panel (jg-dashboard-panels--find id))
               (cell (jg-dashboard-panels--event-cell start)))
          (when (and panel cell (get-text-property point 'jg-dashboard-panel-header))
            (select-window window)
            (goto-char point)
            (let* ((offset-x (- (car cell) (jg-dashboard-panels--panel-x panel)))
                   (offset-y (- (cdr cell) (jg-dashboard-panels--panel-y panel)))
                   (highlight
                    (save-excursion
                      (move-to-column (jg-dashboard-panels--panel-x panel))
                      (let ((begin (point)))
                        (move-to-column (+ (jg-dashboard-panels--panel-x panel)
                                           (jg-dashboard-panels--panel-width panel)))
                        (make-overlay begin (point)))))
                   release)
              (overlay-put highlight 'face 'highlight)
              (setq jg-dashboard-panels-dragging t)
              (unwind-protect
                  (track-mouse
                    (catch 'done
                      (while t
                        (let* ((next (read-event))
                               (kind (and (consp next) (event-basic-type next)))
                               (target (and (consp next) (jg-dashboard-panels--event-cell (event-end next)))))
                          (cond
                           ((memq next '(escape 27)) (throw 'done nil))
                           ((eq kind 'mouse-1)
                            (setq release target) (throw 'done nil))
                           ((eq kind 'mouse-movement)
                            (when target
                              (message "Drop %s at column %d, row %d (Esc cancels)"
                                       (jg-dashboard-panels--panel-title panel)
                                       (jg-dashboard-panels--snap (- (car target) offset-x) 'x)
                                       (jg-dashboard-panels--snap (- (cdr target) offset-y) 'y))))
                           (t (push next unread-command-events) (throw 'done nil)))))))
                (setq jg-dashboard-panels-dragging nil)
                (delete-overlay highlight)
                (if (and release (not (equal release cell)))
                    (jg-dashboard-panels-move id (- (car release) offset-x) (- (cdr release) offset-y))
                  (jg-dashboard-panels--redraw))))))))))

(provide 'jg-dashboard-panels)
;;; jg-dashboard-panels.el ends here
