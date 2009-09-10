(defun our-list (x y z)
  (if (null x)
      nil
  (if (numberp x)
      (list y x z) "nonumber" )))
       
(deftest test-ourlist ()
  (let (L (our-list (+ 10 7) "My" "deftest"))
        (check (= (car(cdr(L))) 17))))
        
