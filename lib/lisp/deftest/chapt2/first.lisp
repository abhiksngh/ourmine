(deftest test-true ()
  (check T))

;=================================
;Starting Chapter 2
;2.2 deftest

(deftest test-evaluation ()
  (check (= (* (/ 6 2) (- 9 2)) 21)))

;=================================
;2.3 deftest
(deftest test-listData ()
  (check (equal (list 2 76 (* 5 6)) '(2 76 30))))

;=================================
;2.4 deftest
(deftest test-operations ()
  (check (equal (cons 'a '(1 4 7)) '(a 1 4 7))))

;=================================
;2.5 deftest

(deftest test-truth ()
  (check (string-equal "Tehran" "tehRan" )))
;=================================
;2.6 deftest
(defun our-forth(x)
  (car(cdr(cdr(cdr x)))))
(deftest test-forth ()
  (check (= (our-forth (list 1 7 8 2 5)) 2)))
;=================================
;2.7 deftest
(defun factorial(x)
  (if (x 1)
      1
  (* x (factorial (- x 1))))
(deftest test-factorial ()
  (check (= (factorial 4) 24))))
;=================================
;2.10 deftest
(let ((x 1) (y 5) (z 7))
  (deftest test-let ()
    (check (= (* x y z) 35))))
;=================================
;2.11 deftest
(let ((x 0))
  (setf x 1)
(let ((y 0))
  (setf y 5)
(deftest test-global ()
  (check (equal (list x y) '(1 5))))))
;=================================
;2.12 deftest
(deftest test-remove ()
  (let ((L  '(Y A S A M A N)))
  (setf L (remove 'A L))
  (check (equal L '(Y S M N)))))
;=================================
