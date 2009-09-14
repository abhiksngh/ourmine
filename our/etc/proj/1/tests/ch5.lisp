;; chapter 5.1
(defun squarea(x)
  (if (or (floatp x) (integerp x))
      (* x x)
      (return-from squarea nil)))

(deftest test-square()
  (let (( n (squarea 'a)))
    (check
      (samep n nil))))


;; chapter 5.2

(defun parlet (n)
  (let* ((x 1)
         (y (+ x 1)))
    (+ x y n)))

(defun longparlet (n)
  (let ((x 1))
    (let ((y (+ x 1)))
      (+ x y n))))

(deftest test-nesting()
  (check
    (equalp (parlet 1) (longparlet 1))))
  
;; chapter 5.3
(defun isnumber (x)
  (cond ((integerp x) x)
	((floatp x) x)
	((complexp x) x)
	(t nil)))

(deftest test-isnumber ()
  (check 
    (eql (isnumber 'a) nil)
    (eql (isnumber 3/8) nil)))

;; chapter 5.4
(deftest test-seqdo ()
  (let ((x 'a))
    (do ((x 1 (+ x 1))
         (y x x))
        ((> x 1) t)
      (check
        (samep (format nil "~a ~a " x y) "1 a")))))

;; chapter 5.5
(defun listargs (&rest args)
    (multiple-value-list args))

(deftest test-listargs()
    (check
      (samep (format nil "~a" (listargs 1 'to 3)) "((1 to 3))")))



