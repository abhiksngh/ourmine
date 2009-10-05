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
