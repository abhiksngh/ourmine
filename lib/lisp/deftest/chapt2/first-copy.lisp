(defun our-list (x y z)
  (if (null x)
      nil
  (if (numberp x)
      (list y x z) "nonumber" )))
       
(deftest test-ourlist ()
  (let ((l (our-list (+ 10 7) "My" "deftest" )))
        (check (= (car(cdr l)) 17))))
        
