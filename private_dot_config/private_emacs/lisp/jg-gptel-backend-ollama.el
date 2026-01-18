(defvar jg-gptel-backend-ollama
  (gptel-make-ollama "Ollama"
    :stream t

    ;; See https://ollama.com/search
    :models '(
	      PetrosStav/gemma3-tools:4b
	      aliafshar/gemma3-it-qat-tools:27b
	      aliafshar/gemma3-it-qat-tools:12b
	      aliafshar/gemma3-it-qat-tools:4b
	      aliafshar/gemma3-it-qat-tools:1b
	      aliafshar/gemma3-it-qat-tools:latest
	      deepseek-r1:1.5b
	      deepseek-r1:14b
	      deepseek-r1:7b
	      deepseek-r1:latest
	      dolphin-mistral:latest
	      gemma3:12b
	      gemma3:12b-it-qat
	      gemma3:27b-it-qat
	      gemma3:4b
	      gemma3:4b-it-qat
	      gemma3:latest
	      gpt-oss:latest
	      granite3.3:2b
	      ishumilin/deepseek-r1-coder-tools:1.5b
	      llama3.2:latest
	      mistral-nemo:latest
	      qwen3:latest
	      )))

(provide 'jg-gptel-backend-ollama)
