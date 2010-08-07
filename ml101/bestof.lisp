(defun maxof (l &key (test #'>) (key #'identity) (result #'identity))
  (bestof l test key result most-negative-fixnum nil))

(defun minof (l &key (test #'<) (key #'identity) (result #'identity))
  (bestof l test key result most-positive-fixnum nil))

(defun bestof (l > key result max out)
  (if (null l)
      (values out max)
      (let* ((head (first l))
	     (max1 (funcall key head)))
	(if (funcall > max1 max)
	    (bestof (rest l) > key result max1 (funcall result head))
	    (bestof (rest l) > key result max  out)))))

(defun best-worst-of (l &key (key #'identity) (result #'identity))
  (if (null l)
      (values)
      (let* (min-ist
	     max-ist
	     (min most-positive-fixnum)
	     (max most-negative-fixnum))
	(labels ((best-worst (one)
		   (let ((x (funcall key one)))
		     (when (< x min)
		       (setf min x
			     min-ist (funcall result one)))
		     (when (> x max)
		       (setf max x
			     max-ist (funcall result one))))))
	  (visit #'best-worst l)
	  (values min-ist max-ist min max)))))

	