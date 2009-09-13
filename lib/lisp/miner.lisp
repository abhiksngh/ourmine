; disable an irritating SBCL flag

(defparameter *files* '(
			"tests/deftest"  ; must be loaded first
			"tricks/lispfuns"
			"tricks/macros"
			"tricks/number"
			"tricks/string"
			"tricks/list"
			"tricks/hash"
			"tricks/random"
			"tricks/normal"
			"tricks/caution"
			"table/structs"
			"table/header"
			"table/data"
			"table/table"
			"table/xindex"
			"learn/nb"
                        "proj1/deftests/tests"
                        "proj1/HyperPipes/structs"
                        "proj1/HyperPipes/HyperPipe"
                        "proj1/TWCNB/nb-ourfinal"
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
