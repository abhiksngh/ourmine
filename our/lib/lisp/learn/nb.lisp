
(defun bayes-classify (one x &optional (m 2) (k 1))
  (let* ((classes        (xindex-classes-all x))
         (nclasses       (xindex-classes-n   x))
         (n              (xindex-n x))
         (classi         (xindex-classi x))
         (like           most-negative-fixnum)
         (classification (first classes)))
    (dolist (class classes)
      (let* ((prior (/ (+ (f x class) k)
                       (+  n (* k nclasses))))
             (tmp   (log prior)))
        (doitems (feature i one)
          (unless (= classi i)
            (unless (unknownp feature)
              (let ((delta (/ (+ (f x class i feature)
                                 (* m prior))
                              (+ (f x class) m))))
                (incf tmp (log delta))))))
        (when (> tmp like)
          (setf like tmp
                classification class))))
    classification))

(deftest test-nb ()
  (unless (fboundp 'weather2) (loaddata 'weather2))
  (let ((tmp (naiveBayes 1 (weather2) :verbose nil)))
    (check
      (samep tmp "
    (#(ABCD :FOR NO
       :A 9 :B 2 :C 0 :D 3
       :ACC .86 :PD .60 :PF .00 :PREC 1.00
       :F .00 :BAL .72)
    #(ABCD :FOR YES
       :A 3 :B 0 :C 2 :D 9
       :ACC .86 :PD 1.00 :PF .40 :PREC .82
       :F .57 :BAL .72))"))))
