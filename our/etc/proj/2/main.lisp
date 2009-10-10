(defun learn (&key (k 8)
	      (prep #'bore)
	      (discretizer #'normalChops)
	      (cluster #'(lambda (data) (genic2 data))) ; May need to correct this.
	      (fss #'nomograms)
	      (classify #'oner) ; Need to do naivebayes too.
	      (train "train.lisp")
	      (test "test.lisp"))
  (let ((training (load train))
	(testing  (load test)))
    ; Code.
    )
