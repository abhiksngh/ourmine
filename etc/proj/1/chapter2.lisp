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

;;; 2.5 Truth

(deftest islist ()
  (check (listp '(a b c))))

;;; 2.6 

(defun fibonacci (N)
  (if (or (zerop N) (= N 1))
    1
    (+ (fibonacci (- N 1)) (fibonacci (- N 2)))))

(deftest examlerecursion ()
  (check (equalp (fibonacci 5) 8)))

