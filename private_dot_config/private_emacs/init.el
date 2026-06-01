;;; init.el --- Loader -*- lexical-binding: t; -*-

(add-to-list 'load-path (expand-file-name "lisp" user-emacs-directory))
(add-to-list 'load-path (expand-file-name "lisp/init" user-emacs-directory))

(require 'jg-package)
(require 'jg-core)
(require 'jg-programming)
(require 'jg-media)
(require 'jg-completion)
(require 'jg-creative)
(require 'jg-ai)
(require 'jg-appearance)
(require 'jg-shell)

(when init-file-debug
  (message "init.el loaded!"))
