;MP
; Fig. 5.1/ 5.2
(defconstant month
  #(0 31 59 90 120 151 181 212 243 273 304 334 365))

(defconstant yzero 2000)

(defun leap? (y)
  (and (zerop (mod y 4))
       (or (zerop (mod y 4))
	   (or (zerop (mod y 400))
	       (not (zerop (mod y 100)))))))

(defun date->num (d m y)
  (+ (- d 1) (month-num m y) (year-num y)))

(defun month-num (m y)
  (+ (svref month (- m  1))
     (if (and (> m 2) (leap? y)) 1 0)))

(defun year-num (y)
  (let ((d 0))
    (if (>= y yzero)
	(dotimes (i (- y yzero) d)
	  (incf d (year-days (+ yzero i))))
	(dotimes (i (- yzero y) (- d))
	  (incf d (year-days (+ y i)))))))

(defun year-days (y) (if (leap? y) 366 365))

; 5.2
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
    (values m (+ 1 (- n (svref month  (- m 1)))))))

(defun date+ (d m y n)
  (num->date (+ (date->num d m y) n)))

; 5.1 (5 tests)
; 2000 was a leap year.
(deftest test-leap? ()
  (check
   (equal T (leap? 2000))))

; Let's hope I can count for the next four...
(deftest test-year-days ()
  (check
   (equal 365 (year-days 2002))))

(deftest test-year-num ()
  (check
   (equal 731  (year-num 2002))))

; Days in month prior.
(deftest test-month-num ()
  (check
   (equal 31 (month-num 2 2001))))

(deftest test-date-num ()
  (check
   (equal 1494 (date->num 3 2 2004))))

; 5.2 (5 tests)
(deftest test-date+ ()
  (check
   (equal (values 4 1 2001) (date+ 1 1 2001 3))))

; Look for the first position in month where n is less than value.
; Basically, return and days where days is (value [days] passed in = time [days] in earlier months).
(deftest test-nmon ()
  (check
   (equal (values 2 5) (nmon 37))))

; Basically just nmon but we account for leap years.
(deftest test-num-month ()
  (check
   (equal (values 2 29) (num-month 59 2000))))

;
(deftest test-num-year ()
  (check
   (equal 1999 (num-year -1))))

;
(deftest test-num-date ()
  (check
   (equal (values 2 4 2002) (num->date (date->num 2 4 2002)))))
