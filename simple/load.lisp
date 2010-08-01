;;;; config
(defmacro quietly (fn l)
  `(handler-bind 
       ((style-warning #'muffle-warning)) 
     (mapcar ,fn ,l)))

(defun make0 (x) (format t "~&; [~a] ~%" x) (load x))
(defun make  ()  (quietly #'make0 '("with.lisp")))

(make)
