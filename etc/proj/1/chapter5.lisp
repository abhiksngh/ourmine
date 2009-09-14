;;; 5.1 Control

(deftest dolisting ()
  (check (equalp
    '(A B C)
    (let ((returnme '()))
      (dolist (x '(A B C D E))
        (if (equalp x 'D)
          (return returnme)
          (setf returnme (append returnme `(,x)))))))))

;;; 5.2 Context

(deftest context ()
  (let ((n 1) (firstn nil) (secondn nil))
    (let ((n 2))
      (setf secondn n))
    (setf firstn n)
    (check (not (equalp firstn secondn)))
  )
)

;;; Figure 5.2 Date Arithmetic [Required]

;;; 5.3 Conditionals

(deftest conditionals ()
  (let ((wannapass t))
    (check (if wannapass
      t
      nil))))

;;; 5.4 Iteration

(deftest multiplyfive ()
  (check (equalp
    '(5 10 15)
    (let ((x '(1 2 3)))
      (mapcar #'(lambda (y) (setf y (* y 5))) x)))))

;;; 5.4 Iteration (Again)

(deftest fivefactorial ()
  (check (equalp
    120
    (let ((result 1))
      (dotimes (x 5 result)
        (setf result (* result (+ x 1))))))))
