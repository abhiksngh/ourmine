(defparameter *tests* nil)
(defparameter *pass*  0)
(defparameter *fail*  0)

(defmacro deftest (name params  &body body)
  `(progn  
     (unless (member ',name *tests*) 
       (push ',name *tests*))
     (defun ,name ,params 
       (format t "; ~a~%" ',name)
       ,@body)))

(defmacro test (want got)
  `(if (samep ,want ,got)
       (incf *pass*)
       (format t "; failure #~a...: ~a~%" 
	       (incf *fail*) ',want)))

(defun tests ()
  (if (fboundp 'make) 
      (make))
  (when *tests*
    (format t "~%;;;;~%")
    (setf *fail* 0)
    (dolist (one (reverse *tests*))
      (funcall one))
    (format t "~&; pass : ~a = ~5,1f% ~%; fail : ~a = ~5,1f% ~%"
	    *pass* (* 100 (/ *pass* (+ *pass* *fail*)))
	    *fail* (* 100 (/ *fail* (+ *pass* *fail*))))))

(deftest !deftest ()
  (let ((a 1))
    (test
     (+ a 1) 2)))
