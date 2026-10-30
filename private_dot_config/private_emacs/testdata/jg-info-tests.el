;;; jg-info-tests.el --- Native Info discovery checks -*- lexical-binding: t; -*-

(require 'cl-lib)
(require 'package)

(setq user-emacs-directory (file-name-as-directory (getenv "JG_INFO_TEST_ROOT"))
      package-user-dir (getenv "JG_INFO_PACKAGE_DIR")
      no-littering-etc-directory (expand-file-name "etc/" user-emacs-directory)
      no-littering-var-directory (expand-file-name "var/" user-emacs-directory)
      native-comp-jit-compilation nil)
;; jg-package normally configures this archive before jg-core is loaded.
;; Only installed Lisp is used here; package installation is disabled below.
(add-to-list 'package-archives '("melpa-stable" . "https://stable.melpa.org/packages/"))
(package-initialize)
(require 'use-package)
(setq use-package-ensure-function #'ignore)

(let ((cached (equal (getenv "JG_INFO_TEST_MODE") "cached"))
      standard-directories)
  (when cached
    (call-interactively (key-binding (kbd "C-h i")))
    (Info-directory)
    (setq standard-directories (copy-sequence Info-directory-list))
    (goto-char (point-min))
    (cl-assert (not (search-forward "Ghostel Workflow:" nil t)))
    (info nil "*info*<2>*")
    (Info-directory))
  ;; A config reload normally happens from an editor buffer, not an Info buffer.
  (switch-to-buffer (get-buffer-create " *jg-info-test-editor*"))
  (load (expand-file-name "lisp/init/jg-core.el" user-emacs-directory) nil t)
  (unless cached
    (cl-assert (not (featurep 'info))))
  (call-interactively (key-binding (kbd "C-h i")))
  (Info-directory)
  (when cached
    (cl-assert (equal standard-directories Info-directory-list)))
  (goto-char (point-min))
  (cl-assert (search-forward "Ghostel Workflow:" nil t))
  (Info-menu "Ghostel Workflow")
  (cl-assert (equal Info-current-node "Top"))
  (Info-menu "Keys")
  (dolist (key '("C-`" "C-u C-`" "C-c t n" "C-c t N" "C-c t b"
                 "C-c t ]" "C-c t [" "C-c t f" "C-c t g" "C-c t G"
                 "C-c t t"))
    (goto-char (point-min))
    (cl-assert (search-forward key nil t)))
  (dolist (node '("Display Modes" "Contexts" "Input Modes" "Tests"
                  "Building the Manual" "Key Index" "Concept Index"))
    (Info-goto-node (concat "(jg-ghostel)" node))
    (cl-assert (equal Info-current-node node)))
  (Info-index "fullscreen terminal")
  (cl-assert (equal Info-current-node "Display Modes"))
  (Info-index "C-c t f")
  (cl-assert (equal Info-current-node "Keys"))
  (Info-find-node "emacs" "Top")
  (cl-assert (equal Info-current-node "Top"))
  (when cached
    (info nil "*info*<2>*")
    (Info-directory)
    (goto-char (point-min))
    (cl-assert (search-forward "Ghostel Workflow:" nil t))))
(princ "Local Info discovery, indexes, and system manuals passed.\n")
;;; jg-info-tests.el ends here
