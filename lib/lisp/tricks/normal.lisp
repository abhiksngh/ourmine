(defstruct normal 
  (max (* -1 most-positive-single-float))
  (min       most-positive-single-float)
  (n 0)
  (sum 0)
  (sumSq 0))

(defmethod add ((n normal) x)
  (incf (normal-n     n) 1)
  (incf (normal-sum   n) x)
  (incf (normal-sumSq n) (square x))
  (setf (normal-max   n) (max (normal-max n) x))
  (setf (normal-min   n) (min (normal-min n) x))
  x)

(defmethod mean ((n normal))
  (/  (normal-sum n) (normal-n n)))

(defmethod stdev ((n normal))
  (let ((sum   (normal-sum n)) 
	(sumSq (normal-sumSq n))
	(n     (normal-n n)))
	  ;;Added call to max because sumsQ - sum^2 should return 0 for 
	  ;;distributions that contain only one unique value, but it returns
	  ;;some small negative value instead.
	  ;;Added a second call to max for cases when there is only 1 sample.
    (sqrt (max 0 (/ (- sumSq(/ (square sum) n)) (max 1 (- n 1)))))))

(defmethod pdf ((n normal) x)
  (let ((mu     (mean n))
	      (sigma  (stdev n)))
	  ;;Added call to zerop, to avoid divide by zero for sigma = 0.
	  ;;This happens with distributions that contain only one unique value.
	  (if (not (zerop sigma))
      (* (/ (* (sqrt (* 2 pi)) sigma))
            (exp (* (- (/ (* 2 (square sigma)))) (square (- x mu)))))
      ;;For sigma = 0, return 1 if x = the only value in n, 0 otherwise.
      (if (= mu x) 1 0))))

(deftest test-normal ()
  (let ((n (make-normal)))
    (dolist (x '( 1 2 3 4 5 4 3 2 1))
      (add n x))
    (check 
      (samep n "#S(NORMAL :MAX 5 :MIN 1 :N 9 :SUM 25 :SUMSQ 85)")
      (equal (mean n) (/ 25 9))
      (equal (stdev n) 1.3944334)
      (samep (format nil "~10,9f" (pdf n 5))  ".080357649")
    )))
