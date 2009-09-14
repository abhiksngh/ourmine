;;; 5.2 Context [Required]

(deftest context ()
  (let ((n 1) (firstn nil) (secondn nil))
    (let ((n 2))
      (setf secondn n))
    (setf firstn n)
    (not (equalp firstn secondn))
  )
)
