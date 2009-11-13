(defstruct normal 
  (max (* -1 most-positive-single-float))
  (min       most-positive-single-float)
  (n 0)
  (sum 0)
  (sumSq 0))

(defstruct (bin (:include normal)) name)

;initailizes n amount of bins into an array
;used in Normal Chops
(defun init-bins (bins n)
  (dotimes (i n)
     (setf (aref bins i) (make-bin :name (- i 3)))))

;Builds a list of bins
;used in Normal Chops
(defun build-bin-list (bins)
  (let (alist)
    (dotimes (i (length bins))
      (push (aref bins i) alist))
   (reverse alist)))

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
    (sqrt (/ (- sumSq(/ (square sum) n)) (- n 1)))))

(defmethod pdf ((n normal) x)
  (let ((mu     (mean n))
	(sigma  (stdev n)))
    (* (/ (* (sqrt (* 2 pi)) sigma))
       (exp (* (- (/ (* 2 (square sigma)))) (square (- x mu)))))))

(defmethod normalize ((n normal) x)
  (/ (- x (normal-min n)) (- (normal-max n) (normal-min n))))

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
