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
			"../../../../lib/lisp/table/structs"
			"../../../../lib/lisp/table/header"
			"../../../../lib/lisp/table/data"
			"../../../../lib/lisp/table/table"
			"../../../../lib/lisp/table/xindex"
			"../../../../lib/lisp/learn/nb"
			"data/ar3"
			"data/ar4"
			"data/ar5"
			"data/ar3short"
			"data/ar4short"
			"data/ar5short"
			"data/pc1short"
			"data/cm1short"
			"data/kc1short"
			"data/kc2short"
			"data/kc3short"
			"data/mc2short"
			"data/mw1short"
			"data/shared_PC1"
			"data/shared_CM1"
			"data/shared_KC1"
			"data/shared_KC2"
			"data/shared_KC3"
			"data/shared_MC2"
			"data/shared_MW1"
			"util"
			"knn"
			"discretize"
			"preprocessor"
  		"learner"
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

