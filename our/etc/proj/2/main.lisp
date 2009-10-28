(defparameter *files* '(
                        "tests/deftest"
                        "reduction/prune"
                        "discretizers/equal-freq"
                        "data/ar4"
                        "data/ar5"
                        "data/ar3"
                        "reduction/median"
                        "data/sick"
                        "data/shared_CM1"
                        "data/shared_KC1"
                        "data/shared_KC2"
                        "data/shared_KC3"
                        "data/shared_MC2"
                        "data/shared_MW1"
                        "data/shared_PC1"
                        "preprocessors/sample-data"
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
                        "reduction/b-squared"
                        "preprocessors/sub-sample"
                        "discretizers/discretizers"
                        "preprocessors/bins"
                        "preprocessors/list-search"
                        "preprocessors/sort"
                        "preprocessors/nvalues"
                        "preprocessors/numericvalue"
                        "clusterers/knn"
                        "classifiers/nb"
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

