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

;;; 2.7 Recursion 

(defun fibonacci (N)
  (if (or (zerop N) (= N 1))
    1
    (+ (fibonacci (- N 1)) (fibonacci (- N 2)))))

(deftest examlerecursion ()
  (check (equalp (fibonacci 5) 8)))

;;; 2.13 Iteration

(defun addup (n)
  (let (( p 0 ))
  (do ((i 1 (+ i 1)))
      ((> i n) p)
    (setf p (+ p i))
	p)))
(deftest exampleiteration ()
  (check (equalp (addup 5) 15)))
     
