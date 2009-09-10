; disable an irritating SBCL flag

(defparameter *files* '(
			"tests/deftest"  ; must be loaded first
			"deftest/chapt4/binsearch"
                        "deftest/chapt4/vector"
                        "deftest/chapt4/mirror"
                        "deftest/chapt4/strings"
                        "deftest/chapt4/tokens"
                        "deftest/chapt4/parsedate"
                        "deftest/chapt2/first"
                        "deftest/chapt2/first-copy"
                        "deftest/chapt4/bst"
                        "deftest/chapt14/evenodd"
                        ;"deftest/chapt2/third"
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
