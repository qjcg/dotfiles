(deftheme jgosset-scratch
  "Created 2022-05-17.")

(custom-theme-set-faces
 'jgosset-scratch
 '(cursor ((t (:background "magenta1"))))
 '(org-document-title ((t (:foreground "white smoke" :height 2.0))))
 '(org-document-info ((t (:foreground "pale turquoise" :slant italic :height 1.0))))
 '(font-lock-comment-face ((t (:foreground "dim gray"))))
 '(rainbow-delimiters-base-face ((t (:inherit nil))))
 '(rainbow-delimiters-depth-1-face ((t (:inherit rainbow-delimiters-base-face :foreground "dim gray"))))
 '(rainbow-delimiters-depth-2-face ((t (:inherit rainbow-delimiters-base-face :foreground "yellow"))))
 '(rainbow-delimiters-depth-3-face ((t (:inherit rainbow-delimiters-base-face :foreground "green"))))
 '(rainbow-delimiters-depth-4-face ((t (:inherit rainbow-delimiters-base-face :foreground "deep sky blue"))))
 '(rainbow-delimiters-depth-5-face ((t (:inherit rainbow-delimiters-base-face :foreground "magenta"))))
 '(rainbow-delimiters-depth-6-face ((t (:inherit rainbow-delimiters-base-face :foreground "light coral"))))
 '(rainbow-delimiters-depth-7-face ((t (:inherit rainbow-delimiters-base-face :foreground "gold2"))))
 '(rainbow-delimiters-depth-8-face ((t (:inherit rainbow-delimiters-base-face :foreground "PaleGreen1"))))
 '(rainbow-delimiters-depth-9-face ((t (:inherit rainbow-delimiters-base-face :foreground "cyan1"))))
 '(mode-line ((t (:background "black" :foreground "white smoke" :box (:line-width -1 :style pressed-button)))))
 '(font-lock-comment-face ((t (:foreground "dim gray"))))
 '(outline-4 ((t (:foreground "light coral"))))
 '(default ((t (:background "#000000" :foreground "#ffffff")))))

(provide-theme 'jgosset-scratch)
