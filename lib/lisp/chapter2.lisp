;;Group 21
;;Project 1
;;chapter2.lisp
;;Created 9/3/09
;;Last Modified 9/3/09

;2.2.1 Simple Evaluation

(deftest test-2_2-1 ()
  (check
    (eql (+ 40 40) '80)))

;2.2.2 Quote Function

(deftest test-2_2-2 ()
  (check
    (eql (quote (+ 10 10)) '(+ 10 10))))

;2.3.1 List Function

(deftest test-2_3-1 ()
  (check
    (equalp (list (+ 1 1 1) 'times 'the 'fun)
         '(3 TIMES THE FUN))))

;2.4.1 cons Function

(deftest test-2_4-1 ()
  (check
    (equalp (cons 'white (cons 'russians nil)) '(white russians))))

;2.4.2 car Function

(deftest test-2_4-2 ()
  (check
    (equalp (car '(10 9 8 7 6)) '10)))

;2.4.3 cdr function

(deftest test-2_4-3 ()
  (check
    (equalp (cdr '(1 2 3)) '(2 3))))

;2.4.4 nth function

(deftest test-2_4-4 ()
  (check
    (equalp (fourth '(4 3 2 1)) '1)))

;2.5.1 listp function

(deftest test-2_5-1 ()
  (check
    (eql (listp '(this is a list)) 't)))

;2.6 defun

(defun quickfun (x)
  (* x x))

(deftest test-2_6 ()
  (check
    (eql (quickfun 6) 36)))

;2.10 Variables (let statement)

(defun 2_10 (x)
  (let ((thisvar 1000))
    (+ x thisvar)))

(deftest test-2_10 ()
  (check
    (eql (2_10 -999) 1)))