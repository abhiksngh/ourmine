; disable an irritating SBCL flag
(defparameter *files* '(
			"../../../../lib/lisp/tests/deftest"
			"../../../../lib/lisp/tricks/lispfuns"
			"../../../../lib/lisp/tricks/macros"
			"../../../../lib/lisp/tricks/number"
			"../../../../lib/lisp/tricks/string"
			"../../../../lib/lisp/tricks/list"
			"../../../../lib/lisp/tricks/hash"
			"../../../../lib/lisp/tricks/random"
			"../../../../lib/lisp/tricks/normal"
			"../../../../lib/lisp/tricks/caution"
			;(load "../../../../lib/lisp/table/structs")
			;(load "../../../../lib/lisp/table/header")
			;(load "../../../../lib/lisp/table/data")
			;(load "../../../../lib/lisp/table/table")
			;(load "../../../../lib/lisp/table/xindex")
			;(load "../../../../lib/lisp/learn/nb")
			"tests/ch2"
			"tests/ch5"
			"tests/ch6"
			"tests/chp3-7-10-14"
			"tests/tests"
			))

(defun make1 (files)
  (let ((n 0))
    (dolist (file files)  
      (format t ";;;; ~a.lisp~%"  file) 
      (incf n)
      (load file))
    (format t ";;;; ~a files loaded~%" n)))

(defun make (&optional (verbose nil))
  (if verbose
      (make1 *files*)
      (handler-bind 
	  ((style-warning #'muffle-warning))
	(make1 *files*))))

(make)

