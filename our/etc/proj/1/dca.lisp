(defun cube(x)
  (* x x x))

(deftest test-cube()
  (check
    (= 27 (cube 3))))

(defun subtract(x y)
  (- x y))

(deftest test-subtract()
  (check
    (= 1 (subtract 2 1))))

(defun our-second(l)
  (car (cdr l)))

(deftest test-second()
  (check
    (eql 'b (our-second '(a b c)))))

(defun my-assign()
  (let ((value 10))
    value))

(deftest test-assign()
  (check
    (= 10 (my assign))))

(defun change-variable(x)
  (let ((value 42))
    (setf value x)
    x))

(deftest test-change()
  (check
    (= 1 (change-variable 1))))

(defun pow-two-iter(x)
  (let ((value 1))
    (do ((i 0 (+ i 1)))
        ((<= i x) value)
      (setf value (+ value value)))))

(deftest test-iter()
  (check
    (= 16 (pow-two-iter 4))))

(defun recurse-fib(x)
  (if (<= x 2)
      1
      (+ (recurse-fib (- x 1)) (recurse-fib (- x 2)))))

(deftest test-recurse()
  (check
    (= 2 (recurse-fib 3))))

(defun not-list(l)
  (listp l))

(deftest test-not-list()
  (check
    (not (not-list 5))))

(defun my-cons(l x)
  (cons x l))

(deftest test-cons()
  (check
    (eql 'a (car (add-to-list '(b c d) 'a)))))

(defun type-real(x)
  (typep x 'real))

(deftest test-type()
  (check
    (type-real 5)))

(defun blocktest(x y)
  (block head
    (let ((value (+ x y)))
          (return-from head value)
          (setf value 0))))

(deftest test-block()
  (check
    (= 15 (blocktest 10 5))))

(defun whentest(x y)
  (when (not nil)
    (let ((newx (* x 2))
          (newy (* y 2)))
      (* newx newy))))

(deftest test-when()
  (check
    (= 100 (whentest 5 5))))

(deftest test-dotimes()
  (check
    (eql 'finished (dotimes (x 2 'finished)))))

(deftest test-eval()
  (check
    (= 20 (eval '(+ 5 5 10)))))

(defun multiple-bind(x y)
  (multiple-value-bind (p1 p2) (values x y)
    (list p1 p2)))

(deftest test-mbind()
  (check
    (eql '2 (car (multiple-bind 2 5)))))
