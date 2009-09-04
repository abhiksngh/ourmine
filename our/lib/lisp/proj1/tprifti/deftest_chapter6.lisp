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
             
 
