(deftest test-vector ()
  (let ((vec (vector 1 2 3)))
    (check (= (svref vec 0) 1))))
