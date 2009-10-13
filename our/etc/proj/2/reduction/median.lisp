(defun median (num-set)
  (let* ((num-set (sort num-set #'<))
         (set-length (length num-set))
         (middle (truncate set-length 2)))
    (if (oddp set-length)
        (nth middle num-set)
        (/ (+ (nth middle num-set) (nth (- middle 1) num-set)) 2))))

(deftest test-median ()
    (check
        (and (equal (median (list 1 2 3 4 5)) 3)
             (equal (median (list 1 1 3 3)) 2))
    )
)
