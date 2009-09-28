(defparameter *files* '(
                        "tests/deftest"
                        "data/ar3"
                    ;    "data/combined_CM1"
                    ;    "data/combined_KC1"
                    ;    "data/combined_KC2"
                        "data/shared_CM1"
                        "data/shared_KC1"
                        "data/shared_KC2"
                        "data/shared_KC3"
                        "data/shared_MC2"
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
                        "discretizers/discretizers"
                        "preprocessors/bins"
                        "preprocessors/numericvalue"
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

