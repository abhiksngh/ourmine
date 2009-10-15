(defun bayesies (one tbl)
  (if (eql (bayes-classify (eg-features one) (xindex tbl)) (eg-class one))
    1.0
    0.0))

(defun b-squared (tbl &key (percentile .20) (score (lambda (b r) (/ (* b b) (+ b r)))))
  (multiple-value-bind (tbl-best tbl-rest) (bore tbl percentile)
    (let* ((acc-best 0)
           (acc-rest 0)
           (range-accs-best (make-hash-table))
           (range-accs-rest (make-hash-table)))
      (macrolet ((bayes-go (which-tbl which-acc)
                   `(dolist (one (table-all ,which-tbl))
                      (let ((value (bayesies one ,which-tbl)))
                        (incf ,which-acc val)
                        (incf (gethash (eg-class one) ,which-range) val)))))
        (bayes-go tbl-best acc-best range-accs-best)
        (bayes-go tbl-rest acc-rest range-accs-rest))
      (
