;;;; config
(defmacro ssh (&body body)
  `(handler-bind ((style-warning #'muffle-warning)) ,@body))

(defun make0 (&rest l)
  (ssh (dolist (x l nil) 
	 (format t "~&;;;; loading ~a ~%" x) 
	 (load x))))

(defun make () 
  (make0 "with.lisp"))

(make)
