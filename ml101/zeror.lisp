
(defun zeror (&key f (bins 3))
  (let (majority results klasses)
    (labels ((ready (tbl)
	       (setf klasses  (klass.all tbl)
		     majority (klass.majority tbl)
		     results  (klasses->results tbl)))
	     (train (tbl row i)
	       (declare (ignore i))
	       (defrow (row-cells row) tbl))
	     (classify (tbl row)
	       (declare (ignore tbl))
	       (let* ((actual     (row-class row))
		      (predicted  majority))
		 (print `(,(row-cells row) ,predicted))
		 (results-add results actual predicted)))
	     (reporter (tbl)
	       (declare (ignore tbl))
	       (results-report results)))
      (data f)
      (traintest 0
		 :bins bins
		 :train #'train
		 :ready #'ready
		 :tester #'classify
		 :reporter #'reporter))))


