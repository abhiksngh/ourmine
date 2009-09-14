(defun square(x)
  (* x x))

(deftest test-square()
  (check
    (= 4 (square 2))))

(defun add(x y)
  (+ x y))

(deftest test-add()
  (check
    (= 5 (subtract 3 2))))

(defun subtract(a b)
  (- a b))

(deftest test-subtract()
  (check
    (= 1 (subtract 3 2))))

(deftest test-third()
  (check
    (equal 'c (third '(a b c)))))

(deftest test-listp()
  (check
    (listp '(a b c))))

(deftest test-not()
  (check
    (not nil)))

(deftest test-and()
  (check
    (= 3 (and t (+ 1 2)))))

(defun sum-greater (x y z)
  (> (+ x y) z))

(deftest test-sum-greater()
  (check
    (sum-greater 1 4 3)))
