;;; Claimee: Drew

;;; Run a trial of n comparisons and weight the importance of each column.

(print " - Loading Relief") ;; Output for a pretty log

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

;;; Run loop n times, return list of weights.
