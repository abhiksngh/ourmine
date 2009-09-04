(deftest test_eval ()
  (check (equal (+ 1 3) (/ (* 2 4) 2))))

(deftest test_list ()
  (check (equal
          (list (and (listp 3) t) (+ 1 3))
          '(nil 4))))

(deftest test_list1 ()
  (let* ((lst '(1 2 '(2 3) 4)))
    (labels ((listElem (x) (and (not (null x))
                                (or (listp (car x))
                                    (listElem (cdr x))))))
      (check (listElem lst)))))
                            
                            
(deftest test_cons ()
  (check (equal (cons '(1 2) '(3 4 5)) (list '(1 2) 3 4 5))))


(deftest test_lambda ()
  (check (equal (list 1 4 9)
                (mapcar #'(lambda (x) (* x x)) (list 1 2 3)))))

(deftest test_apply ()
  (let ((a 1)
        (b 2)
        (c 3))
    (check (equal (+ a b c)
                  (apply #'+ '(1 2 3))))))

(deftest test_assignment ()
  (let* ((lst (list nil 2 3 4)))
    (funcall #'(lambda (x) (setf  (car x) (apply #'+ (cdr lst))))
             lst)
    (check (equal (car lst) 9))))
                      

(deftest test_do()
  (let* ((start 1)
         (end 5)
         (lst nil))
    (do ((i start (+ i 1)))
        ((> i end) )
      (setf lst (cons (* i i) lst)))
    (check (equal (reverse lst) '(1 4 9 16 25)))))

