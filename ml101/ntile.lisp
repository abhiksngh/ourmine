(defstruct bins breaks  positions key median)

(defun list-of-hashes->bins (lists > &key (width 50) (stretch 1) value details)
  (let ((min most-positive-fixnum)
	(max most-negative-fixnum)
	(numh (make-hash-table :test #'equal))
	(lineh (make-hash-table)))
    (labels ((norm (x) (/ (- x min)
			  (- max min)))
	     (value1 (x) (round
			  (* (norm x) width stretch)))
	     (value (x) (value1 (cdr x))))
      (dolist (hash (flatten lists))
	(dohash (klass result hash)
	  (declare (ignore klass))
	  ;(print result)
	  (let ((x  (funcall value result)))
	    (when (> x max) (setf max x))
	    (when (< x min) (setf min x))
	    (push x (gethash (funcall details result)
			     numh)))))
      (dohash (key alls  numh)
	(print keys)
	(let* ((nums   (sort  alls >))
	       (breaks (percentiles nums '(0 10 30 50 70 90 100))))
	  (print nums)
	  (setf (gethash key lineh)
		(make-bins :breaks  breaks
			   :positions (mapcar #'value breaks)
			   :key key
			   :median (cdr (assoc 50 breaks))))))
      lineh)))
;(values min max lineh))))

      
  