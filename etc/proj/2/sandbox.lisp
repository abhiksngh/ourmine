;;; Delete this at your own peril, for it will beckon towards death. -Drew

(load "lib/loaddeps")
(load "utils/utils")
(load "d-data/mushroom")
(load "algos/genic")

(defparameter mushtable (mushroom))

(defun unnegitify (possibly-negative)
  (if (< possibly-negative 0)
    0
    possibly-negative
  )
)

(defun closest-member (table row-number find-same-class)
  (let ((target-class (eg-class (nth row-number (table-all table)))))
    (loop for i from 1 to (length (table-all table)) do
      (let ((left (nth (unnegitify (- row-number i)) (table-all table))) (right (nth (+ row-number i) (table-all table))))
        (if (and (not (null (eg-class left))) (equalp (eg-class left) target-class))
          (if find-same-class 
            (return (unnegitify (- row-number i)))
          )
          (if (and (not (null (eg-class right))) (not find-same-class))
            (return (unnegitify (- row-number i)))
          )
        )
        (if (and (not (null (eg-class right))) (equalp (eg-class right) target-class))
          (if find-same-class
            (return (+ row-number i))
          )
          (if (and (not (null (eg-class right))) (not find-same-class))
            (return (+ row-number i))
          )
        )
      )
    )
  )
)

(defun relief-diff (column-num target neighbor &optional (divisor-n 1))
  (let* ((score 0) (target-feature (nth column-num (eg-features target))) (neighbor-feature (nth column-num (eg-features neighbor))))
    (if (and (realp target-feature) (realp neighbor-feature))
      (setf score (+ score (/ (abs (- target-feature neighbor-feature)) (+ target-feature neighbor-feature))))
      (if (equalp target-feature neighbor-feature)
        (setf score (+ score 1))
      )
    )
    (/ score divisor-n)
  )
)

(defun relief (table &optional (iterations nil))
  (if (null iterations)
    (setf iterations 250)
  )
  (let ((column-weights (make-list (length (eg-features (first (table-all table)))) :initial-element 0)))
    (loop for i from 0 to iterations do
      (let* ((record-num (random (length (table-all table)))) (hit (closest-member table record-num t)) (miss (closest-member table record-num nil)))
        (loop for j from 0 to (- (length column-weights) 1) do
          (let 
              ((round-score-hit (relief-diff j (nth record-num (table-all table)) (nth hit (table-all table)) iterations)) 
               (round-score-miss (relief-diff j (nth record-num (table-all table)) (nth miss (table-all table)) iterations)))
            (setf (nth j column-weights) (- (+ (nth j column-weights) round-score-miss) round-score-hit))
          )
        )
      )
    )
    column-weights
  )
)
