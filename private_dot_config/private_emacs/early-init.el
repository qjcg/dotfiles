;; Startup speed, annoyance suppression
(setq gc-cons-threshold 10000000)
(setq byte-compile-warnings '(not obsolete))
(setq warning-suppress-log-types '((comp) (bytecomp)))
(setq native-comp-async-report-warnings-errors 'silent)

;; '(fullscreen . maximized) or '(fullscreen . fullscreen)
(add-to-list 'initial-frame-alist '(fullscreen . fullscreen))

;; Add personal lisp dir to load-path.
(add-to-list 'load-path (expand-file-name "lisp" user-emacs-directory))

;; Use no-littering dir for native compilation cache.
;; https://github.com/emacscollective/no-littering#native-compilation-cache
;;
;; TODO: UNCOMMENT once no-littering is in place
;; (when (fboundp 'startup-redirect-eln-cache)
;;   (startup-redirect-eln-cache
;;    (convert-standard-filename
;;     (expand-file-name  "var/eln-cache/" user-emacs-directory))))
