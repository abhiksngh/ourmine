; Figure 6.1 
(defun single? (1st)
  (and (consp 1st) (null (cdr 1st)))
)


(deftest test-single? ()
  (check
    (let* ((1st (cons 1 nil)))
    (single? 1st))
  )
)

(defun append1 (1st obj)
  (append 1st (list obj))
)

(deftest test-append1 ()
  (check
    (equal '(1 2 3 4) (append1 '(1 2 3) '4))
  )
)

(defun combiner (x)
  (typecase x
    (number #'+)
    (list   #'append)
    (t      #'list))
)

(defun combine (&rest args)
  (apply (combiner (car args)) args)
)

(deftest test-combine ()
  (check
    (equal '(A B C D) (combine '(a b) '(c d)))
  )
)

