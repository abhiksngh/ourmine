;;chapter 5 tests

;; fig 5.1 by Graham
(defparameter month #(0 31 59 90 120 151 181 212 243 273 304 334 365))

(defparameter yzero 2000)

(defun leap? (y)
  (and (zerop (mod y 4))
       (or (zerop (mod y 400))
	      (not (zerop (mod y 100))))))

(defun date->num (d m y)
  (+ (- d 1) (month-num m y) (year-num y)))

(defun month-num (m y)
  (+ (svref month (-  m 1))
     (if (and (> m 2)
	            (leap? y)) 1 0)))

(defun year-num (y)
  (let ((d 0))
    (if (>= y yzero)
	(dotimes (i (- y yzero) d)
	    (incf d (year-days (+ yzero i))))
	(dotimes (i (- yzero y) (- d))
	    (incf d (year-days (+ y i)))))))

(defun year-days (y) 
  (if (leap? y)
      366
      365))


;; fig 5.2 by Graham
(defun num->date (n)
  (multiple-value-bind (y left) (num-year n)
    (multiple-value-bind (m d) (num-month left y)
      (values d m y))))

(defun num-year (n)
  (if (< n 0)
      (do* ((y (- yzero 1) (- y 1))
	        (d (- (year-days y)) (- d (year-days y))))
	      ((<= d n) (values y (- n d ))))
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


;; testing progn
(deftest progn-test ()
  (progn
    (format t "a")
    (format t "b")
    (let ((res (+ 11 12)))
      (check 
	(equalp res 23)))))

;;testing return-from
(defun return-from-func ()
  (format t "goblins")
  (return-from return-from-func 'wizards)
  (format t "dragons"))

(deftest return-from-test ()
  (check 
    (equalp (return-from-func) 'wizards)))

;;testing let*
(deftest let-star-test ()
  (let* ((x 5)
	 (y 10))
    (check 
      (equalp (+ x y) 15))))


;;testing leap year
(deftest leap-test ()
  (check
    (equalp '(T NIL T)
	    (mapcar #'leap? '(1904 1900 1600)))))


;; testing date+ function
(deftest mult-val-list ()
  (check
    (equalp
     (multiple-value-list (date+ 17 12 1997 60))
     '(15 2 1998))))



