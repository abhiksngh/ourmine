;(deftest test-true ()
;  (check T))

;=================================
;Chapter 2
;=================================
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
;2.13 deftest
(let ((L 1))
(defun iteration (first last)
  (do ((i first (+ i 1)))
      ((> i last) 'GO)
    (setf L (+ L 1))) L))
(deftest test-iteration ()
    (check (= (iteration 1 5) 6)))

;=================================
;CHAPTER 5
;=================================
;5.2 deftest
(let* ((x 5) (y (* x x)) (z (* y x)))
  (deftest test-nestlet ()
  (check (equal (list x y z) '(5 25 125)))))

;=================================
;5.3 deftest
(defun Odd-Even (x)
  (when (oddp x) 'True)
  )
(deftest test-OddEven ()
  (check (equal (Odd-Even 7) 'True)))

;================================
;5.3 deftest2
(defun month-length (mon)
  (case mon
    ((jan mar may jul aug oct dec) 31)
    ((apr jun sept nov) 30)
    (feb 28)
    (otherwise "wrong month")))
(deftest test-month ()
  (check (= (month-length 'sept) 30)))
;=================================
;5.1 figure
;(defconstant month
;    #(0 31 59 90 120 151 181 212 243 273 304 334 365))

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

;==================================
;deftest
(deftest test-datenum ()
  (check (equal (date->num 6 2 2000) 36)))
;==================================
;5.2 figure
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
;==================================
;deftest
(deftest test-numdate ()
  (check (equal (multiple-value-list (num->date 36)) '(6 2 2000))))

;=================================
;CHAPTER 10
;=================================
;10.2 deftest
(defmacro nill (p)
  (list 'setf p nil))

(deftest nill-test ()
  (let ((x 10))
  (check (equal (nill x) nil))))

;=================================
;10.4 deftest
(defmacro while (test &rest body)
  `(do ()
    ((not , test))
    ,@body))
    
(defun quicksort (vec l r)
  (let ((i l)
        (j r)
        (p (svref vec (round (+ l r) 2))))
    (while (<= i j)
      (while (< (svref vec i) p) (incf i))
      (while (> (svref vec j) p) (decf j))
      (when (<= i j)
        (rotatef (svref vec i) (svref vec j))
        (incf i)
        (decf j)))
    (if (> (- j l) 1) (quicksort vec l j))
    (if (> (- r i) 1) (quicksort vec i r)))
  vec)

(deftest test-sort ()
  (let* ((ourvec  #(4 3 6 7 1 6 8 9))
         (sortvec (quicksort ourvec 0 7)))
    (check (equal (svref sortvec 0) 1))))

;=================================
;10.6 deftest
(defmacro cah (lst) `(car ,lst))

(deftest test-cah()
  (let ((lst '(3 5 7 1)))
    (check (equal (cah lst) 3))))

;=================================
;
