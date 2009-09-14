;;; 2.3 Data

(deftest listbuilder ()
  (check (equalp
    '(A B C)
    (list 'A 'B 'C))))

;;; 2.4 List Operations

(deftest listops () 
  (check (equalp
    '(A B C)
    (cons (car '(A nil)) (cdr '(nil B C))))))


