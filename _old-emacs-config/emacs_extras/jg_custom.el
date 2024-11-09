(use-package dired
  :config
  (setenv "LC_COLLATE" "C")) ;; Use preferred ordering for dired listings.

(use-package gptel
  :bind
  (())
  :config
  (setq gptel-default-mode 'org-mode)
  (setq gptel-prompt-string "* ")
  (setq
   gptel-model "gpt-4o"
   gptel-backend (gptel-make-azure "drw-azureai"
                   :protocol "https"
                   :host "azure-openai.drwcloud.com"
		   :endpoint "/openai/deployments/gpt-4o/chat/completions?api-version=2024-06-01"
                   :stream t
                   :key "7c67423331a41feb323fd9ff985953e7"
                   :models '("gpt-4o"))))

(use-package emms
  :config
  (emms-all))

(use-package zoxide
  :ensure
  :bind
  (("C-c z z" . zoxide-travel)
   ("C-c z f" . zoxide-find-file)
   ))
