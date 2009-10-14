(defparameter *files* '(
                        "tests/data/sick"
                        "tests/data/waveform"
			"tests/data/vehicle"
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
                        "nbins"
			"fill-in"
			"kmeans"
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
