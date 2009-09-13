;;; 4.2 Binary Search [Required]

(defun binsearch (item vector &optional (start 0) (end (length vector)))
  (let ((pivot (round (/ (+ start end) 2))))
    (if (and (listp vector) (> (length vector) 0))
      (if (equalp item (nth pivot vector))
        pivot
        (if (not (zerop (- start end)))
          (if (> item (nth pivot vector))
            (binsearch item vector pivot end)
            (binsearch item vector start pivot)
          )
          nil
        )
      )
      nil
    )
  )
)

(deftest testbinsearch ()
  (check (equalp
    2
    (binsearch 3 '(1 2 3 4 5 6 7 8)))))

;;; 4.5 Parsing Dates [Required]
