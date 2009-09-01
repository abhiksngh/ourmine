 (defun square (x)
  (* x x))

(defun cube (y)
  (* y y y))

(deftest test-cube ()
  (check (= (cube 9) 729)
         (= (cube 10) 1000)))



