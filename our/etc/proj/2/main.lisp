(defparameter *files* '(
                        "tests/deftest"
                        "data/ar3"
                        "data/sick"
;                        "data/combined_CM1"
;                        "data/combined_KC1"
;                        "data/combined_KC2"
;                        "data/combined_KC3"
;                        "data/combined_MW1"
;                        "data/combined_MC2"
;                        "data/combined_PC1"
;                        "data/shared_CM1"
;                        "data/shared_KC1"
;                        "data/shared_KC2"
;                        "data/shared_KC3"
;                        "data/shared_MC2"
;                        "data/shared_MW1"
;                        "data/shared_PC1"
                        "tricks/lispfuns"
                        "tricks/list"
                        "tricks/macros"
                        "tricks/caution"
                        "tricks/hash"
                        "tricks/normal"
                        "tricks/number"
                        "tricks/random"
                        "tricks/string"
                        "table/structs"
                        "table/header"
                        "table/data"
                        "table/table"
                        "table/xindex"
                        "./learn"
                        ;"reduction/b-squared"
                        "preprocessors/sub-sampling"
                        "discretizers/discretizers"
                        "preprocessors/bins"
                        "preprocessors/list-search"
                        "preprocessors/sort"
                        "preprocessors/nvalues"
                        "preprocessors/numericvalue"
                        "preprocessors/knn"
                        "learners/hyperpipes"
                        "learners/nb"
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

