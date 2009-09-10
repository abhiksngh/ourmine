 (defun square (x)
  (* x x))

(defun cube (y)
  (* y y y))

(deftest test-cube ()
  (check (= (cube 9) 729)
         (= (cube 10) 1000)))
(defun ratio1 (x y)
  (/ x y))
(deftest test-ratio ()
  (check (= (ratio1 6 3) 2)
         (= (ratio1 10 2) 5)))




