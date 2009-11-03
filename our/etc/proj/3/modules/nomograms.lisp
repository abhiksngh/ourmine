(defun nomograms (tbl &key (percentile .20) (threshold .25))
  (b-squared tbl :percentile percentile :threshold threshold
             :score (lambda (b r) (/ (log b) (log r)))))
