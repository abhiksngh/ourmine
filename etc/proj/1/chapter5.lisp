;;; 5.1 Control

(deftest dolisting ()
  (check (equalp
    '(A B C)
    (let ((returnme '()))
      (dolist (x '(A B C D E))
        (if (equalp x 'D)
          (return returnme)
          (setf returnme (append returnme `(,x)))))))))

;;; 5.2 Context [Required]

(deftest context ()
  (let ((n 1) (firstn nil) (secondn nil))
    (let ((n 2))
      (setf secondn n))
    (setf firstn n)
    (check (not (equalp firstn secondn)))
  )
)


