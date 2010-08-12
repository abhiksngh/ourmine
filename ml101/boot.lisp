;;;; config
;;;; start slime (M-x slime <RET>)
;;;; go to this buffer and load it  (C-c C-l <RET>)
(let (files)
  (defun make  (&optional verbosep &rest new )
    (labels ((make0 (x)
	       (format t "~&; [~a] ~%" x) (load x)))
      (if new
	  (setf files new))
      (if verbosep
	  (mapcar #'make0 files)
	  (handler-bind ; SBCL-specific
	      ((style-warning #'muffle-warning)) 
	    (mapcar #'make0 files)))
      t))
 )
	
(make nil
      "deftest.lisp"
      "macros.lisp"
      "lib.lisp"
      "hash.lisp"
      "bestof.lisp"
      "structs.lisp"
      "random.lisp"
      "profile.lisp"
      "data.lisp"
      "experiment.lisp"
      "abcd.lisp"
      "zeror.lisp"
      "nb.lisp"
      "ntile.lisp"
      "line.lisp"
      "rankstats.lisp"
      )
