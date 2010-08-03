(defun maxof (l &key (test #'>) (key #'identity) (result #'identity))
  (bestof l test key result most-negative-fixnum nil))

(defun minof (l &key (test #'<) (key #'identity) (result #'identity))
  (bestof l test key result most-positive-fixnum nil))

(defun bestof (l > key result max out)
  (if (null l)
      (values max out)
      (let* ((head (first l))
	     (max1 (funcall key head)))
	(if (funcall > max1 max)
	    (bestof (rest l) > key result max1 (funcall result head))
	    (bestof (rest l) > key result max  out)))))
	