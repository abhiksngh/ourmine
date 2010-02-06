(let 
    (_tests (_pass 0) (_fail 0))
 
  (defmacro deftest ((name params)  &body body)
    `(progn  (or (member ,name _tests) 
		 (push   ,name _tests))
	     (defun ,name ,params 
	       (format t "~a~%" ,name)
	       ,@body)))
 
  (defmacro test (&rest _forms)
    (let ((out (gensym)) (form (gensym)))
      ` (dolist (,form ',_forms ,out)
	  (if (setf ,out (eval ,form))
	      (incf _pass)
	      (format t "failure #~a...: ~a~%" 
		      (incf _fail) ,form)))))
 
  (defun tests ()
    (setf _fail 0)
    (dolist (one (reverse _tests))
      (funcall one))
    (if _tests
        (format t "~%PASSES: ~a (~a %)~%FAILS : ~a~%"
		_pass (* 100 (/ _pass (+ _pass _fail)))
		_fail)))
)
