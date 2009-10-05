;;; Claimee: Drew

;;; Run a trial of n comparisons and weight the importance of each column.

(print " - Loading Relief") ;; Output for a pretty log

;;; Find closest neighbor.  Find-same-class is for locating closest hit and closest miss.

(defun closest-member (table row-number find-same-class)
  (let ((target-class (eg-class (nth row-number (table-all table)))))
    (loop for i from 1 to (length (table-all table)) do
      (let ((left (nth (- row-number i) (table-all table))) (right (nth (+ row-number i) (table-all table))))
        (if (equalp (eg-class left) target-class)
          (if find-same-class
            (return (- row-number i))
          )
          (if (not find-same-class)
            (return (- row-number i))
          )
        )
        (if (equalp (eg-class right) target-class)
          (if find-same-class
            (return (+ row-number i))
          )
          (if (not find-same-class)
            (return (+ row-number i))
          )
        )
      )
    )
  )
)

;;; Find difference metric.

(defun relief-diff (column-num target neighbor &optional (divisor-n 1))
  (let ((score 0) (target-feature (nth column-num (eg-features target))) (neighbor-feature (nth column-num (eg-features neighbor))))
    (if (and (realp target-feature) (realp neighbor-feature))
      (setf score (+ score (/ (abs (- target-feature neighbor-feature)) (+ target-feature neighbor-feature))))
      (if (equalp target-feature neighbor-feature)
        (setf score (+ score 1))
      )
    )
    (/ score divisor-n)
  )
)

;;; Run loop n times, return list of weights.
