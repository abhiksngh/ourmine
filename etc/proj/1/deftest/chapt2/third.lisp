(defun our-forth(x)
       (car(cdr(cdr(cdr x)))))
(deftest test-forth ()
  (check (= (our-forth (list 1 7 8 2 6)) 2)))
