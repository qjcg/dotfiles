;; Compare models: https://platform.openai.com/docs/models/compare

(defvar jg-gptel-backend-azure-completions
  (gptel-make-azure "AzureAI"
    :host (auth-source-gopass-search "azure-host") 

    ;; See:
    ;; https://learn.microsoft.com/en-us/azure/ai-foundry/openai/reference#chat-completions
    ;; https://learn.microsoft.com/en-us/azure/ai-foundry/openai/reference-preview#api-specs
    :endpoint "/openai/v1/chat/completions"
    :stream t
    :key (auth-source-gopass-search "azure-key")
    :models '(
	      gpt-5.1
	      gpt-5-mini
	      gpt-5-nano
	      gpt-5-chat
	      gpt-5-chat_2025-10-03
	      gpt-5-pro
	      ))
  "AzureAI ChatGPT backend for models using the /v1/chat/completions endpoint.")

(defvar jg-gptel-backend-azure-responses
  (gptel-make-azure "AzureAI (Responses)"
    :host (auth-source-gopass-search "azure-host") 

    ;; See:
    ;; https://learn.microsoft.com/en-us/azure/ai-foundry/openai/reference#chat-completions
    ;; https://learn.microsoft.com/en-us/azure/ai-foundry/openai/reference-preview#api-specs
    ;;:endpoint "/openai/deployments/codex-mini/chat/completions?api-version=2025-04-01-preview"
    :endpoint "/openai/v1/responses"
    :stream t
    :key (auth-source-gopass-search "azure-key")
    :models '(gpt-5.1-codex
	      gpt-5.1-codex-mini))

  "AzureAI ChatGPT backend for models using the /v1/responses endpoint."
  )

;; https://learn.microsoft.com/en-us/azure/ai-services/openai/concepts/models?tabs=global-standard%2Cstandard-chat-completions#model-summary-table-and-region-availability

(provide 'jg-gptel-backend-azure)
