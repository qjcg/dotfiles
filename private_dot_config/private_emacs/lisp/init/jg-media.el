;;; jg-media.el --- Reading & multimedia -*- lexical-binding: t; -*-

(use-package elpher :ensure :pin melpa-stable)

(use-package eww
  :bind (("C-c w" . eww)))

(use-package emms
  :ensure :pin gnu
  :bind (("C-c e e" . emms)
         ("C-c e n" . emms-next)
         ("C-c e p" . emms-previous)
         ("C-c e P" . (lambda () (interactive)
			"Play my preferred EMMS playlist."
			(emms-play-playlist (expand-file-name "streams-jg.emms" emms-source-file-default-directory))))
         ("C-c e r" . emms-random)
         ("C-c e s" . emms-stop)
         ("C-c e SPC" . emms-pause))
  :config
  (emms-all)
  (setopt emms-player-list '(emms-player-mpv))
  (setopt emms-player-mpv-update-metadata t))

(use-package elfeed :ensure :pin melpa-stable)
(use-package elfeed-org :ensure :config (elfeed-org))
(use-package elfeed-score :ensure :pin melpa-stable)

(use-package nov :ensure :pin melpa-stable)

(use-package slack
  :ensure :disabled
  :bind (("C-c S K" . slack-stop)
         ("C-c S c" . slack-select-rooms)
         ("C-c S u" . slack-select-unread-rooms)
         ("C-c S U" . slack-user-select)
         ("C-c S s" . slack-search-from-messages)
         ("C-c S J" . slack-jump-to-browser)
         ("C-c S j" . slack-jump-to-app)
         ("C-c S e" . slack-insert-emoji)
         ("C-c S E" . slack-message-edit)
         ("C-c S r" . slack-message-add-reaction)
         ("C-c S t" . slack-thread-show-or-create)
         ("C-c S g" . slack-message-redisplay)
         ("C-c S G" . slack-conversations-list-update-quick)
         ("C-c S q" . slack-quote-and-reply)
         ("C-c S Q" . slack-quote-and-reply-with-link)
         (:map slack-mode-map
               (("@" . slack-message-embed-mention)
                ("#" . slack-message-embed-channel)))))

(provide 'jg-media)
;;; jg-media.el ends here
