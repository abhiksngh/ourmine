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
                        "kmeans"
                        "proj/1/listEqual"
                        "proj/1/carList"
			"proj/1/isCompress"
			"proj/1/isUncomp"
                        "proj/1/isMirror"
                        "proj/1/nthElt"
                        "proj/1/inReverse"
                        "proj/1/myStack"
                        "proj/1/isSingle"
                        "proj/1/appends"
                        "proj/1/mapInt"
                        "proj/1/filters"
			"proj/1/mostLen"
			"proj/1/loops"
			"proj/1/bfst"
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
