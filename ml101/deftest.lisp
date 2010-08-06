;;; test engine
(defparameter *tests* nil)
(defmacro deftest (name params  &body body)
  `(progn (unless (member ',name *tests*) (push ',name *tests*))
	  (defun ,name ,params ,@body)))

(let ((pass 0) 
      (fail 0))
  (defun test (want got)
    (labels  
	((white    (c)   (member c '(#\# #\\ #\Space #\Tab #\Newline
				     #\Linefeed #\Return #\Page) :test #'char=))
	 (whiteout (s)   ;(print (remove-if #'white s))
		         (remove-if #'white s))
	 (samep    (x y) (string= (whiteout (format nil "~(~a~)" x))
				  (whiteout (format nil "~(~a~)" y)))))
      (cond ((samep want got) (incf pass))
	    (t                (incf fail)
			      (format t "~&; fail : expected ~a~%" want)))
      got))
  (defun tests ()
    (labels ((run (x) (format t "~&;testing  ~a~%" x) (funcall x)))
      (when *tests*
	(setf fail 0 pass 0)
	(mapcar #'run (reverse *tests*))
	(format t "~&; pass : ~a = ~5,1f% ~%; fail : ~a = ~5,1f% ~%"
		pass (* 100 (/ pass (+ pass fail)))
		fail (* 100 (/ fail (+ pass fail)))))))
)

(deftest !deftest1 (&aux (a 1))
  (test (+ a 1) 2))

(deftest !deftest2 (&aux (a 1))
  (test (+ a 1) 3))
