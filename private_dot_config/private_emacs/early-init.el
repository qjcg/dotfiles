;; Startup speed, annoyance suppression
(setopt gc-cons-threshold 10000000)
(setq byte-compile-warnings '(not obsolete))
(setopt warning-suppress-log-types '((comp) (bytecomp)))
(setopt native-comp-async-report-warnings-errors 'silent)

(add-to-list 'initial-frame-alist '(fullscreen . fullscreen))

(setopt user-emacs-directory "~/.config/emacs")
(add-to-list 'load-path (expand-file-name "lisp" user-emacs-directory))

(require 'xdg)
(when (fboundp 'startup-redirect-eln-cache)
  (startup-redirect-eln-cache
   (convert-standard-filename
    (expand-file-name  "emacs/eln-cache" (xdg-cache-home)))))

(message "early-init.el loaded!")
