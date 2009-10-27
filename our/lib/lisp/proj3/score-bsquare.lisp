
(defun score-bsquare (best rest attr range)
  (let* ((min (car range))
         (max (car (last range)))  
         (total-best (f best))
         (total-rest (f rest))
         (total (+ total-best total-rest))
         (freq-best (calc-freq best attr min max))
         (freq-rest (calc-freq rest attr min max))
         (b (* freq-best (float (/ total-best total))))
         (r (* freq-rest (float (/ total-rest total)))))
    (format t "~a ~a ~%" min max)
    (format t "~a ~a ~%" freq-best freq-rest)
    (/ (* b b) (+ b r))))




(defun calc-freq (tbl attr min max)
  (let ((freq 0)
        (instances (get-features (table-all tbl)))
        (total-size (f tbl)))
    (dolist (inst instances)
       (let ((val (nth attr inst)))
        (if (and (<= val max) (>= val min))
            (incf freq))))
    (float (/ freq total-size))))
