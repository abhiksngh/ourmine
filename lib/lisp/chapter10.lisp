;;Group 21
;;Project 1
;;chapter10.lisp
;;Created 9/3/09
;;Last Modified 9/3/09

;10.1 Eval function
;Forces LISP to evaluate a list as code

(deftest test-10_1 ()
  (check
    (eql (eval '(* 8 8 8)) 512)))