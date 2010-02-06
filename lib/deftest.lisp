(defparameter *tests* nil)
(defparameter *pass* 0)
(defparameter *fail* 0)
 
 (defmacro deftest (name params  &body body)
   `(progn  (or (member ',name *tests*) 
		(push   ',name *tests*))
	    (defun ,name ,params 
	      (format t "~a~%" ',name)
	      ,@body)))
 
(defmacro test (&rest forms)
  (let ((form (gensym)) (out (gensym)))
    `(let (,out)
       (dolist (,form ',forms ,out)
	 (if (setf ,out (eval ,form))
	     (incf *pass*)
	     (format t "failure #~a...: ~a~%" 
		     (incf *fail*) ,form))))))

(defun tests ()
  (when *tests*
    (setf *fail* 0)
    (dolist (one (reverse *tests*))
      (funcall one))
    (format t "~%PASSES: ~a (~a %)~%FAILS : ~a~%"
	    *pass* (* 100 (/ *pass* (+ *pass* *fail*)))
	    *fail*)))

