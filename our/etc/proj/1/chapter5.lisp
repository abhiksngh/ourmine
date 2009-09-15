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

(defun multiple-bind(x y) ;Chapter 5
  (multiple-value-bind (p1 p2) (values x y)
    (list p1 p2)))

(deftest test-mbind()
  (check
    (eql '2 (car (multiple-bind 2 5)))))

;Figure 5.1 & 5.2


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

(defun prog-block(x y z)
  (progn
    (+ x y)
    (+ y z)))

(deftest test-prog()
  (check
   (= 5 (prog-block 4 3 2))))
