;; Startup speed, annoyance suppression
(setopt gc-cons-threshold 10000000)
(setq byte-compile-warnings '(not obsolete))
(setopt warning-suppress-log-types '((comp) (bytecomp)))
(setopt native-comp-async-report-warnings-errors 'silent)

(add-to-list 'initial-frame-alist '(fullscreen . fullscreen))

(setopt user-emacs-directory "~/.config/emacs")
(add-to-list 'load-path (expand-file-name "lisp" user-emacs-directory))

(require 'xdg) ;; FIXME: handle package not installed
(when (fboundp 'startup-redirect-eln-cache)
  (startup-redirect-eln-cache
   (convert-standard-filename
    (expand-file-name  "emacs/eln-cache" (xdg-cache-home)))))

;; The lines below fix an issue where some packages in load-path were
;; sourced from from ~/.emacs.d/elpa, and others from
;; ~/.config/emacs/var/elpa (i.e. seemingly a race between package.el and
;; no-littering.el at startup).
(setq package-enable-at-startup nil)
(setq package-user-dir (expand-file-name "var/elpa" user-emacs-directory))
(setq no-littering-etc-directory (expand-file-name "etc/" user-emacs-directory))
(setq no-littering-var-directory (expand-file-name "var/" user-emacs-directory))

(when init-file-debug
  (message "early-init.el loaded!"))
