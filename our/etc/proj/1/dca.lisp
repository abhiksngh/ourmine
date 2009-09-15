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

(defun blocktest(x y) ;Chapter 5
  (block head
    (let ((value (+ x y)))
          (return-from head value)
          (setf value 0))))

(deftest test-block()
  (check
    (= 15 (blocktest 10 5))))

(defun whentest(x y) ;Chapter 5
  (when (not nil)
    (let ((newx (* x 2))
          (newy (* y 2)))
      (* newx newy))))

(deftest test-when()
  (check
    (= 100 (whentest 5 5))))

(deftest test-dotimes() ;Chapter 5
  (check
    (eql 'finished (dotimes (x 2 'finished)))))

(deftest test-eval() ;Chapter 10
  (check
    (= 20 (eval '(+ 5 5 10)))))

(defun multiple-bind(x y) ;Chapter 5
  (multiple-value-bind (p1 p2) (values x y)
    (list p1 p2)))

(deftest test-mbind()
  (check
    (eql '2 (car (multiple-bind 2 5)))))

(defmacro nil! (x) ;Chapter 10
  (list 'setf x nil))

(deftest test-macro()
  (check
    (macroexpand-1 '(nil! x))))

(defun my-backquote (x  y) ;Chapter 10
  `(X + Y = ,(+ x y)))

(deftest test-backquote()
  (check
    (= 3 (car (last (my-backquote 1 2))))))

;Figure 5.1 & 5.2

(defconstant month
  #(0 31 59 90 120 151 181 212 243 273 304 334 365))

(defconstant yzero 2000)

(defun leap? (y)
  (and (zerop (mod y 4))
       (or (zerop (mod y 400))
           (not (zerop (mod y 100))))))

(defun date->num (d m y)
  (+ (- d 1) (month-num m y) (year-num y)))

(defun month-num (m y)
  (+ (svref month (- m 1))
     (if (and (> m 2) (leap? y)) 1 0)))

(defun year-num (y)
  (let ((d 0))
    (if (>= y yzero)
        (dotimes (i (- y yzero) d)
          (incf d (year-days (+ yzero i))))
        (dotimes (i (- yzero y) (- d))
          (incf d (year-days (+ y i)))))))

(defun year-days (y) (if (leap? y) 366 365))


(defun num->date (n)
  (multiple-value-bind (y left) (num-year n)
    (multiple-value-bind (m d) (num-month left y)
      (values d m y))))

(defun num-year (n)
  (if (< n 0)
      (do* ((y (- yzero 1) (- y 1))
            (d (- (year-days y)) (- d (year-days y))))
           ((<= d n) (values y (- n d))))
      (do* ((y yzero (+ y 1))
            (prev 0 d)
            (d (year-days y) (+ d (year-days y))))
           ((> d n) (values y (- n prev))))))

(defun num-month (n y)
  (if (leap? y)
      (cond ((= n 59) (values 2 29))
            ((> n 59) (nmon (- n 1)))
            (t        (nmon n)))
      (nmon n)))

(defun nmon (n)
  (let ((m (position n month :test #'<)))
    (values m (+ 1 (- n (svref month (- m 1)))))))

(defun date+ (d m y n)
  (num->date (+ (date->num d m y) n)))

(deftest test-date()
  (check
    (let ((l (multiple-value-list (date+ 1 1 2000 31))))
      (and (= 1 (car l))
           (= 2 (car (cdr l)))
           (= 2000 (car (cdr (cdr l))))))))

;fig 10.2

(defmacro for (var start stop &body body)
  (let ((gstop (gensym)))
    `(do ((,var ,start (1+ ,var))
          (,gstop ,stop))
         ((> ,var ,gstop))
       ,@body)))

(defmacro in (obj &rest choices)
  (let ((insym (gensym)))
    `(let ((,insym ,obj))
       (or ,@(mapcar #'(lambda (c) `(eql ,insym ,c))
                     choices)))))

(defmacro random-choice (&rest exprs)
  `(case (random ,(length exprs))
     ,@(let ((key -1))
         (mapcar #'(lambda (expr)
                     `(,(incf key) ,expr))
                 exprs))))

(defmacro avg (&rest args)
  `(/ (+ ,@args) ,(length args)))

(defmacro with-gensyms (syms &body body)
  `(let ,(mapcar #'(lambda (s)
                     `(,s (gensym)))
                 syms)
     ,@body))

(defmacro aif (test then &optional else)
  `(let ((it ,test))
     (if it ,then ,else)))

(deftest test-for()
  (check
    (let ((y 0))
      (for x 1 8
        (setf y x))
      (= 8 y))))

(deftest test-avg()
  (check
    (= 12 (avg 10 14))))
