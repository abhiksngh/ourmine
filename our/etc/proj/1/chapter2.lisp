(defun cube(x) ;Chapter 2
  (* x x x))

(deftest test-cube()
  (check
    (= 27 (cube 3))))

(defun subtract(x y) ;Chapter 2
  (- x y))

(deftest test-subtract()
  (check
    (= 1 (subtract 2 1))))

(defun our-second(l) ;Chapter 2
  (car (cdr l)))

(deftest test-second()
  (check
    (eql 'b (our-second '(a b c)))))

(defun my-assign() ;Chapter 2
  (let ((value 10))
    value))

(deftest test-assign()
  (check
    (= 10 (my-assign))))

(defun change-variable(x) ;Chapter 2
  (let ((value 42))
    (setf value x)
    x))

(deftest test-change()
  (check
    (= 1 (change-variable 1))))

(defun pow-two-iter(x) ;Chapter 2
  (let ((value 1))
    (do ((i 0 (+ i 1)))
        ((>= i x) value)
      (setf value (+ value value)))))

(deftest test-iter()
  (check
    (= 16 (pow-two-iter 4))))

(defun recurse-fib(x) ;Chapter 2
  (if (<= x 2)
      1
      (+ (recurse-fib (- x 1)) (recurse-fib (- x 2)))))

(deftest test-recurse()
  (check
    (= 2 (recurse-fib 3))))

(defun not-list(l) ;Chapter 2
  (listp l))

(deftest test-not-list()
  (check
    (not (not-list 5))))

(defun my-cons(l x) ;Chapter 2
  (cons x l))

(deftest test-cons()
  (check
    (eql 'a (car (my-cons '(b c d) 'a)))))

(defun type-real(x) ;Chapter 2
  (typep x 'real))

(deftest test-type()
  (check
    (type-real 5)))
