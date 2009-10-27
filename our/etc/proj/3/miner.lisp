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
                        "utilities"
                        ;"normalize"
                        ;"n-chops"
                        ;"b-squared
                        ;"grid"
                        ;"kmeans" ; need to get this working from 2
                        ;"Whatever classifer Will is doing"
                        ;"kth-nearest"
                        
                        "tests/data/additionalbolts"
                        "tests/data/anneal"
                        "tests/data/fishcatch"
                        "tests/data/primary-tumor"
                        "tests/data/pollution"
                        "tests/data/housing"
                        "tests/data/soybean"
                        "tests/data/waveform"
                        "tests/data/basketball"
                        "tests/data/sick"
                        "tests/data/elusage"
                        
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
