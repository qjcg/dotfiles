;;; jg-completion.el --- Minibuffer & completion -*- lexical-binding: t; -*-

(use-package vertico
  :ensure :pin gnu
  :config
  (setopt vertico-count 20)
  (setopt vertico-resize t)
  :init (vertico-mode))

(use-package consult
  :ensure :pin gnu
  :bind (("C-x b" . consult-buffer)
         ("M-s b" . consult-buffer)
         ("M-s f" . consult-flymake)
         ("M-s l" . consult-line)
         ("M-s M-o" . consult-outline)
         ("M-s r" . consult-ripgrep)
         ("M-s t" . consult-theme)))

(use-package orderless
  :ensure :pin melpa-stable
  :init
  (setopt completion-styles '(orderless basic))
  (setopt completion-category-overrides '((file (styles basic partial-completion)))))

(use-package marginalia
  :ensure :pin gnu
  :bind (:map minibuffer-local-map
              ("M-A" . marginalia-cycle))
  :init (marginalia-mode))

(use-package tempel
  :disabled :ensure :pin gnu
  :hook prog-mode
  :init (global-tempel-abbrev-mode))

(use-package embark
  :ensure t
  :bind (("C-." . embark-act)
         ("C-;" . embark-dwim)
         :map minibuffer-local-map
         ("C-c C-o" . embark-export))
  :init (setq prefix-help-command #'embark-prefix-help-command))

(use-package embark-consult
  :ensure t
  :after (embark consult)
  :hook (embark-collect-mode . consult-preview-at-point-mode))

(use-package corfu
  :ensure t :disabled
  :custom
  (corfu-auto t)
  (corfu-cycle t)
  (corfu-echo-delay 0)
  :init (global-corfu-mode))

(use-package cape
  :ensure t :disabled
  :after corfu
  :config
  (add-to-list 'completion-at-point-functions #'cape-file)
  (add-to-list 'completion-at-point-functions #'cape-dabbrev)
  (add-to-list 'completion-at-point-functions #'cape-keyword))

(provide 'jg-completion)
;;; jg-completion.el ends here
