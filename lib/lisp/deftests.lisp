;simple car and cdr test
(deftest test-3-1-1() (check (eql 'c (car(cdr(cdr '(a b c d e f)))))))

;simple car test
(deftest test-3-1-2() (check (eql 'a (car '(a b c d e f)))))

;simple cdr test
(deftest test-3-1-3() (check (equalp '(b c d e f) (cdr '(a b c d e f)))))

;test for third function
(deftest test-3-1-4() (check (equalp 'c (third'(a b c d e f)))))

(defun myfunction (x) (+ x 10))
;test for simple user defined function
(deftest test-3-1-5() (check (eql 14 (myfunction 4))))

;cons test
(deftest test-3-1-6() (check (equalp '(4) (cons '4 nil))))

;setf test
(deftest test-3-4-1() (check (equalp (setf x 10) 10)))

;test for append function
(deftest test-3-4-2() (check (equalp '(a b c d e f) (append '(a b c d e) '(f)))))

;test for nth function
(deftest test-3-6-1() (check (equalp 'e (nth 4 '(a b c d e f)))))

;test for nthcdr function
(deftest test-3-6-2() (check (equalp '(e f) (nthcdr 4 '(a b c d e f)))))

