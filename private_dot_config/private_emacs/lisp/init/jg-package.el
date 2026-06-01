;;; jg-package.el --- Package management -*- lexical-binding: t; -*-

(require 'package)
(setq package-archives '(("gnu" . "https://elpa.gnu.org/packages/")
			 ("nongnu" . "https://elpa.nongnu.org/nongnu/")
			 ("melpa-stable" . "https://stable.melpa.org/packages/")
			 ("melpa" . "https://melpa.org/packages/")))
(setq package-archive-priorities
      '(("melpa-stable" . 20)
        ("gnu"          . 15)
        ("nongnu"       . 10)
        ("melpa"        . 0)))
(package-initialize)

(provide 'jg-package)

;; Local Variables:
;; mode: emacs-lisp
;; End:
