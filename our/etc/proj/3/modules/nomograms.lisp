(defun nomograms (tbl &key (percentile .20) (threshold .25))
  (b-squared tbl :percentile percentile :threshold threshold
             :score (lambda (b r) (/ (log b) (log r)))))


(defun nomograms1 (tbl &key (percentile .20) (threshold .25))
  (b-squared tbl :percentile percentile :threshold threshold
             :score (lambda (b r) (if (> b r) 
				      (log (/ b r))
				      0))))

(defun nomograms2 (tbl &key (percentile .20) (threshold .25))
  (b-squared tbl :percentile percentile :threshold threshold))
