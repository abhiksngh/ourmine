;;; Delete this at your own peril, for it will beckon towards death. -Drew

(load "lib/loaddeps")
(load "utils/utils")
(load "d-data/mushroom")

(defparameter mushtable (mushroom))

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
