(defparameter *files* '(
                        "deftest"
                        "chapter2"
                        "chapter4"
                        "chapter5"
                        "chapter7"
                        "chapter10"
                        "awhite"
                        "listEqual"
                        "carList"
                        "appends"
                        "filters"
                        "inReverse"
                        "isMirror"
                        "isCompress"
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

(defconstant month
  #(0 31 59 90 120 151 181 212 243 273 304 334 365))

(defconstant yzero 2000)

(make)
