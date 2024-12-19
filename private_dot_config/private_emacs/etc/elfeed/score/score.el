;;; Elfeed score file                                     -*- lisp -*-
((version 10)
 ("title"
  (:text "Sacha Chua.*Emacs news" :value 10 :type r))

 ("content")
 ("tag"
  (:tags (t . '(emacs os personal)) :value 10))

 ("authors")
 ("feed"
  (:text "research!rsc" :value 20 :type s :attr t))

 ("link")
 ("udf")
 (mark nil)
 ("adjust-tags"

  (:threshold
   (t . 10)
   :tags
   (t relevant))

  (:threshold
   (nil . -10)
   :tags
   (nil crap))))
