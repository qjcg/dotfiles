;;; jg-creative.el --- Denote, Org, writing -*- lexical-binding: t; -*-

(use-package denote
  :ensure :pin gnu
  :bind (("C-c n n" . denote-open-or-create)))

(use-package consult-denote :ensure :after (consult denote))
(use-package denote-explore :ensure :pin melpa-stable :after (denote))

(use-package denote-journal
  :ensure :pin gnu :demand t
  :bind (("C-c n j" . denote-journal-new-or-existing-entry)))

(use-package denote-silo :ensure :pin gnu)

(use-package org
  :ensure :pin gnu
  :after (denote denote-journal)
  :config
  (setopt org-hide-emphasis-markers t)
  (setopt org-log-into-drawer t)
  (setopt org-agenda-files `(,(expand-file-name denote-journal-directory))))

(use-package markdown-toc :ensure :pin melpa-stable)
(use-package ox-gfm :ensure :pin melpa-stable)
(use-package ox-typst :ensure)

(use-package ox-slideboom
  :if (locate-library "ox-slideboom")
  :custom (org-slideboom-normalize-heading-levels t))

(use-package slideboom-watch-mode :if (locate-library "slideboom-watch-mode"))
(use-package slideboom-mode :if (locate-library "slideboom-mode"))

(use-package todotxt-mode :ensure)
(use-package pdf-tools :ensure :pin nongnu)

(provide 'jg-creative)
;;; jg-creative.el ends here
