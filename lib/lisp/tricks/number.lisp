
(defun square (x) (* x x))

(defun cube (x)
  (* x x x))

(deftest testcube ()
  (check
    (= 27 (cube 3))))
