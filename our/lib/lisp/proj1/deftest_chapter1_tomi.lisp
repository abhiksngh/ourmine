(deftest test_eval ()
  (check (equal (+ 1 3) (/ (* 2 4) 2))))

(deftest test_cons ()
  (check (equal (cons '(1 2) '(3 4 5)) (list '(1 2) 3 4 5))))

(deftest test_list 
(deftest test_lambda ()
  (check (equal (list 1 4 9)
         (mapcar #'(lambda (x) (* x x)) (list 1 2 3)))))

(deftest test_apply ()
  (let ((a 1)
        (b 2)
        (c 3))
  (check (equal (+ a b c)
                (apply #'+ '(1 2 3))))))

(deftest test_do()
  (let* ((start 1)
         (end 5)
         (lst nil))
    (do ((i start (+ i 1)))
        ((> i end) )
      (setf lst (cons (* i i) lst)))
    (check (equal (reverse lst) '(1 4 9 16 25)))))
    
