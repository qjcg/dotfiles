;;; jg-ai.el --- AI assistant config -*- lexical-binding: t; -*-

(use-package gptel
  :ensure :pin nongnu
  :bind (("C-`" . gptel)
         ("C-<tab>" . gptel-rewrite)
         ("C-c RET" . gptel-send)
         ("C-c SPC SPC" . gptel)
         ("C-c SPC m" . gptel-menu)
         ("C-c SPC a" . gptel-add)
         ("C-c SPC f" . gptel-add-file)
         ("C-c SPC r" . gptel-rewrite)
         ("C-c SPC c" . gptel-mcp-connect)
         ("C-c SPC C" . gptel-mcp-disconnect)
         ("C-c SPC t" . gptel-org-set-topic)
         ("C-c SPC s" . gptel-system-prompt)
         ("C-c SPC p" . gptel--preset)

	 :map gptel-mode-map
	 ((
	   ("C-c SPC m" . gptel-menu)
	   ("C-c d" . my/gptel-save-to-denote)
	   )))

  :config
  (require 'gptel-integrations)
  (setopt gptel-default-mode 'org-mode)
  (setopt gptel-org-branching-context t)
  (setopt gptel-highlight-mode t)
  (setq gptel--known-backends nil)

  (defun my/gptel-save-to-denote (destination &optional title keywords)
    "Save the current gptel buffer to a denote file.

DESTINATION is either `new' (create a new note) or `journal'
(append to today's journal entry).  When called interactively,
prompt for the destination.  TITLE and KEYWORDS are used only
when creating a new note."
    (interactive
     (let ((dest (intern
                  (completing-read "Save to: "
                                   '("new" "journal")
                                   nil t nil nil "journal"))))
       (if (eq dest 'new)
           (list dest (denote-title-prompt) (denote-keywords-prompt))
	 (list dest))))
    (unless (bound-and-true-p gptel-mode)
      (user-error "Not in a gptel buffer"))
    (let ((content (buffer-substring-no-properties (point-min) (point-max))))
      (pcase destination
	('new
	 (denote title keywords 'org)
	 (goto-char (point-max))
	 (insert "\n* Conversation\n\n" content)
	 (save-buffer)
	 (message "Saved gptel buffer to new note %s" (buffer-file-name)))
	('journal
	 (my/gptel--append-to-journal content)))))

  (defun my/gptel--append-to-journal (content)
    "Append CONTENT to today's denote journal entry, creating it if needed."
    (let ((heading (format-time-string "** GPTel conversation (%H:%M)")))
      (cond
       ;; Preferred: denote-journal package
       ((fboundp 'denote-journal-new-or-existing-entry)
	(denote-journal-new-or-existing-entry)
	(goto-char (point-max))
	(insert "\n" heading "\n\n" content "\n")
	(save-buffer))
       ;; Older denote-journal-extras API
       ((fboundp 'denote-journal-extras-new-or-existing-entry)
	(denote-journal-extras-new-or-existing-entry)
	(goto-char (point-max))
	(insert "\n" heading "\n\n" content "\n")
	(save-buffer))
       (t
	(user-error "denote-journal is not available")))
      (message "Appended gptel buffer to today's journal")))

  (require 'jg-ai-backends)

  (gptel-make-preset 'dev
    :description "A coding assistant."
    :system 'programming
    :category "programmimg"
    :tools '()
    :stream t
    :use-context 'system
    :include-reasoning t)

  (gptel-make-preset 'ted
    :system
    "You are Father Ted Crilly, the reluctant priest from the Irish sitcom
/Father Ted/, exiled on the remote Craggy Island with the dim-witted
Father Dougal McGuire, the foul-mouthed Father Jack Hackett, and the
obsessively hospitable housekeeper Mrs. Doyle. You're a well-meaning but
easily exasperated cleric, often dealing with absurd situations, petty
parish politics, and your housemates' chaos. Speak in a warm Irish
lilt (use casual phrasing like `feck`, `Jaysus`, or `ah, go on` for
authenticity). Stay in character: respond with sarcasm, patience, or
mild frustration as needed, reference Craggy Island life, and avoid
breaking the fourth wall. End responses as if chatting in the parochial
house.")

  (gptel-make-preset 'rsc
    :system
    "Role-play as Russ Cox: a senior systems engineer and former technical lead for the Go programming language. Your core expertise includes Go language design and implementation, compilers and toolchains, runtimes, distributed systems, and developer tooling (for example Git). When responding:
- Be direct, precise, and practical. Favor clear, simple explanations and actionable advice.
- Begin with a concise summary (1–2 sentences), then provide detailed technical exposition, rationale, and trade-offs.
- Provide small, correct Go examples, commands, or pseudo-code when helpful.
- Explain concepts at the level of experienced engineers; include why choices are made and their consequences.
- Avoid speculation. Clearly label any conjecture or personal opinion and, when uncertain, describe how to verify or test it.
- Ask concise clarifying questions if the request is ambiguous or lacks necessary detail.
- If the query is outside these expertise areas, politely redirect to more appropriate resources or ask how to refocus the question.
- Cite references or authoritative sources when available."))

(use-package gptel-agent
  :vc (:url "https://github.com/karthink/gptel-agent" :rev :newest)
  :config (gptel-agent-update))

(use-package mcp
  :vc (:url "https://github.com/lizqwerscott/mcp.el")
  :init (require 'mcp-hub)
  :config
  (setq mcp-hub-servers
	'(("filesystem" . (:command "npx" :args ("-y" "@modelcontextprotocol/server-filesystem" ".")))
	  ("filesystemgo" . (:command "go" :args ("run" "github.com/mark3labs/mcp-filesystem-server@v0.11.1" ".")))
          ("fetch" . (:command "uvx" :args ("mcp-server-fetch"))))))

(use-package agent-shell :ensure :pin melpa-stable)
(use-package acp :ensure :pin melpa-stable)

(use-package cui :ensure
  :config
  (require 'jg-ai-backends)
  )

(provide 'jg-ai)
;;; jg-ai.el ends here
