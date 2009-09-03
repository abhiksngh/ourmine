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