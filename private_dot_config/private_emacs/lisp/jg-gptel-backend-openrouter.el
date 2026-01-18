(defvar jg-gptel-backend-openrouter
  (gptel-make-openai "OpenRouter"
    :host "openrouter.ai"
    :endpoint "/api/v1/chat/completions"
    :stream t
    :key (auth-source-gopass-search "openrouter.ai")

    ;; See https://openrouter.ai/rankings
    :models '(x-ai/grok-code-fast-1
	      x-ai/grok-4-fast
	      google/gemini-2.5-flash
	      minimax/minimax-m2
	      )))

(provide 'jg-gptel-backend-openrouter)
