(deftest testCarCdr()
  (check
    (eql 'c (car(cdr(cdr '(a b c d e f)))))))


(deftest testCar()
  (check
    (eql 'a (car '(a b c d e f)))))

(deftest testCdr()
  (check
    (equalp '(b c d e f) (cdr '(a b c d e f)))))


(deftest testthird()
  (check (equalp 'c (third'(a b c d e f)))))


(defun myfunction (x)
  (+ x 10))

(deftest testmyfunction()
  (check
    (eql 14 (myfunction 4))))


(deftest testcons()
  (check (equalp '(4)
                 (cons '4 nil))))

(deftest testsetf()
  (check
    (equalp (setf x 10) 10)))


(deftest testappend()
  (check
    (equalp '(a b c d e f) (append '(a b c d e) '(f)))))


(deftest testnth()
  (check
    (equalp 'e (nth 4 '(a b c d e f)))))

(deftest testnthcdr()
  (check
    (equalp '(e f) (nthcdr 4 '(a b c d e f)))))
