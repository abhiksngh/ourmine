(defun nb (&key f (bins 3) debug )
  (let (tbl results  (n 0))
    (labels ((preprocess (tbl0)
	       (setf tbl (clone-table tbl0)))
	     (trains (row i &aux (klass (row-class row)))
	       (incf n)
	       (incf (klass-n (defklass klass tbl)))
	       (if debug (print `(,i ,(row-cells row)) debug))
	       (mapcar #'(lambda (col value) (train col value (row-class row)))
		       (table-cols tbl) (row-cells row)))
	     (train (col value klass)
	       (if (knownp value)
		   (counts col klass value)))
	     (ready ()
	       (setf results  (klasses->results tbl)))
	     (classify (row)
	       (let* ((actual     (row-class row))
		      (predicted  (most-likely-klass tbl row n)))
		 (if debug
		     (print `(prediction= ,predicted for ,(row-cells row)) debug))
		 (results-add results actual predicted)))
	     (reporter ()
	       (if debug
		   (terpri debug))
	       (results-report results)))
      (data f)
      (traintest 0
		 :bins       bins
		 :preprocess #'preprocess
		 :train      #'trains
		 :ready      #'ready
		 :tester     #'classify
		 :reporter   #'reporter)
      ;(terpri) (dolist (col (table-cols tbl)) (showh (sym-counts col)))
      results
      )))

(defmethod counts ((col sym) klass value)
  (incf
   (gethash `(,klass ,(col-name col) ,value)
	    (sym-counts col)
	    0)))

; wrong- need different counts per class
(defmethod counts ((col num) klass value)
  (with-slots (n sum sumsq min max) col
    (incf n)
    (incf sum value)
    (incf sumsq (* value value))
    (setf min (min min value)
	  max (max max value))))

(defun most-likely-klass (tbl row n &optional (m 2) (k 1))
  (let* ((klasses        (table-klasses tbl))
	 (nklasses       (1+ (length klasses)))
         (like           most-negative-fixnum)
         (classification (klass-name (first klasses))))
    (dolist (klass klasses classification)
      (let* ((prior (/ (+ (klass-n klass)  k)
                       (+  n (* k nklasses))))
             (tmp   prior))
	;(o (klass-name klass) prior (row-cells row))
	(mapcar #'(lambda (col value)
		    (unless (col-goalp col)
		      (unless (not (knownp value))
			(let* ((key    `(,(klass-name  klass) ,(col-name col) ,value))
			       (peh    (gethash key (sym-counts col) 0))
			       (ph     (klass-n klass))
			       (delta  (/ (+ peh (* m prior))
					  (+ ph m))))
			  ;(o key value delta)
			  (setf tmp (* tmp delta))))))
		(table-cols tbl)
		(row-cells row))
	(when (> tmp like)
          (setf like tmp
                classification (klass-name klass)))))))

