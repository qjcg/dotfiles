;; '(fullscreen . maximized) or '(fullscreen . fullscreen)
(add-to-list 'initial-frame-alist '(fullscreen . fullscreen))

;; Startup speed, annoyance suppression
(setq gc-cons-threshold 10000000)
(setq byte-compile-warnings '(not obsolete))
(setq warning-suppress-log-types '((comp) (bytecomp)))
(setq native-comp-async-report-warnings-errors 'silent)
