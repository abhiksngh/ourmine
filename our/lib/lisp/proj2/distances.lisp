(defun euc (a b)
  (let ((tmp 0))
    (dotimes (i (length a) (sqrt tmp))
      (if (and (numberp (nth i a)) (numberp (nth i b)))
          (setf tmp (+ tmp (* (- (nth i a) (nth i b))
                              (- (nth i a) (nth i b)))))
          (if (not (equal (nth i a) (nth i b)))
              (setf tmp (+ tmp 1)))))))

                
                
