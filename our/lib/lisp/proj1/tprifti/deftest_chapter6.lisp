(deftest test_single? ()
  (let* ((lst (cons 1 nil)))
    (check (single? lst))))

(deftest test_append1()
  (let* ((lst nil))
    (labels ((append_key (&key (x 1) (y 2) (z 3))
               (list x y z)))
      (dolist (obj (append_key))
        (setf lst (append1 lst obj))))
    (check (equal lst '(1 2 3)))))

(deftest test_map-int()
  (let* ((lst (map-int #'(lambda (x) (+ x 100)) 5)))
    (check (equal '(100 101 102 103 104) lst))))
             
 
(deftest test_filter ()
  (let* (( lst '(1 (2) (1 2) 3 4))
         ( lst1 (filter #'(lambda (x) (listp x)) lst)))
    (check (equal lst1 '(T T)))))

(deftest test_most ()
  (let* ((lst nil))
    (multiple-value-bind (elm score) (most #'length '((1) (1 2) (1 2 3)))
      (setf lst (list elm score)))
    (check (equal '((1 2 3) 3) lst))))
                          
