(defparameter *tests* nil)
(defparameter *pass* 0)
(defparameter *fail* 0)
 
 (defmacro deftest (name params  &body body)
   `(progn  (or (member ',name *tests*) 
		(push   ',name *tests*))
	    (defun ,name ,params 
	      (format t "; ~a~%" ',name)
	      ,@body)))
 
(defmacro test (&rest forms)
  (let ((out (gensym)) (form (gensym)))
    `(let (,out)
       (dolist (,form ',forms)
	 (if (setf ,out (eval ,form))
	     (incf *pass*)
	     (format t "; failure #~a...: ~a~%" 
		     (incf *fail*) ,form))))))
    
(defun tests ()
  (if (fboundp 'make) (make))
  (when *tests*
    (format t "~%;;;;~%")
    (setf *fail* 0)
    (dolist (one (reverse *tests*))
      (funcall one))
    (format t "~%; passes: ~a (~a %)~%; fails : ~a~%"
	    *pass* (* 100 (/ *pass* (+ *pass* *fail*)))
	    *fail*)))

(defun !deftest ()
  (let ((a 1))
    (print (macroexpand 
	    '(test
	      (= a 1)
	      (= (+ a 1) 2))))))

(defun oops ()
  (let ((A 1))
    (LET (G3744)
      (DOLIST (G3745 '((= A 1) (= (+ A 1) 2)))
	(print G3745)
	(IF (SETF G3744 (EVAL G3745)) (INCF *PASS*)
	    (FORMAT T "; failure #~a...: ~a~%" 
		    (INCF *FAIL*) G3745)))))) 
