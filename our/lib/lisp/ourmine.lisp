; disable an irritating SBCL flag

(defparameter *files* '(
			"tests/deftest"
			"tricks/lispfuns"
			"tricks/macros"
			"tricks/caution"
			"tricks/string"
			"tricks/list"
			"tricks/hash"
			"tricks/random"
			"table/structs"
			))

(defun make (&optional (verbose nil))
  (if verbose
      (make1 *files*)
      (handler-bind 
	  ((style-warning #'muffle-warning))
	(make1 *files*))))
  
(defun make1 (files)
  (let ((n 0))
    (dolist (file files)  
      (format t ";;;; ~a.lisp~%"  file) 
      (incf n)
      (load file))
    (format t ";;;; ~a files loaded~%" n)))

(make)
