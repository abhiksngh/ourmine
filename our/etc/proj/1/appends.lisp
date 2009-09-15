;;;;deftest to ensure that the user written appends function works

(defun append1 (lst obj)
  (append lst (list obj)))

(deftest appends ()
  (check
    (equal (append1 '(a b c) 'd) '(a b c d))))
