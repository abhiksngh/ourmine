;;; 2.3 Data

(deftest listbuilder ()
  (check (equalp
    '(A B C)
    (list 'A 'B 'C))))
