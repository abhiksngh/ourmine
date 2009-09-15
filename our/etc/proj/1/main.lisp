(defparameter *files* '(
                        "deftest"
                        "chapter2"
			"chapter5"
                        "chapter10"
                        "awhite"
                        "listEqual"
                        "carList"
                        "appends"
                        "dca"
                        "filters"
                        "inReverse"
                        "isCompress"
                        "isMirror"
                        "isSingle"
                        "isUncomp"
                        "loops"
                        "mapInt"
                        "mostLen"
                        "myStack"
                        "nthElt"
                        ))


(defun make1 (files)
  (let ((n 0))
    (dolist (file files)
      (format t ";;;; ~a.lisp~%" file)
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
