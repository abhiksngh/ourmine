(defun timm-tests () 
  (tests
    (timm-test1)
    ))

(deftest timm-test1 ()
  (check (+ 1 2))
)
(deftest timm-test2 ()
  (check (+ 1 3))
)
 


