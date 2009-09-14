;Test Count: 7

;6.1 Global Functions

(setf (symbol-function 'times5) 
      #'(lambda (x)  (* x 5)))

(deftest test-6_1 ()
  (check
    (eql (times5 9) (* 5 9))))


;6.2 Local Functions

(deftest test-6_2 ()
  (check
    (labels ((times5 (x) (* x 5))
             (consa (x) (cons 'a x)))
      (consa (eql (times5 5) (* 5 5))))))

 ;6.3 Parameter Lists

(defun interestingfact (subject &optional fact)
  (list subject 'is fact))

(deftest test-6_3 ()
  (check
    (equalp (interestingfact 'emacs 'terrible) '(emacs is terrible))))

 ;6.4 Utility Functions
(defun combinelists (1st 2nd &optional 3rd)
  (append 1st 2nd 3rd))

(deftest test-6_4_1 ()
  (setf x '(THIS IS A LIST))
  (setf y '(IN LISP))
  (setf xy (combinelists x y))
  (check
    (equal xy '(THIS IS A LIST IN LISP))))

(defun multipleElements? (someList)
  (not (null (cdr someList))))

(deftest test-6_4_2 ()
  (setf x '(THIS IS))
  (check
    (equalp (multipleelements? x) T)))

;6.5 Closures ( A little confused on this section )

(defun addnumbers (x y)
  (+ x y))

;(deftest test-6_5 ()
;  (setf b (add ))
;  (check
;    (eql (funcall b 10) (+ (+ 55 55) 55))))

;6.9 Recursion

(defun recurseFactorial(n)
  (if (<= n 1)
      1
      (* n (recurseFactorial (- n 1)))))

(deftest test-6_9 ()
  (check
    (equal (recurseFactorial 3) 6)))
