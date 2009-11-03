(deftest prism-test()
  (let* ((data (xindex (discretize (make-data-k)))))
    (check
      (equal (car (make-rules-all-classes data))
             '(NO ((3 3) (2 0)) ((0 1) (1 8)) ((0 1) (2 0) (1 0) (3 1)) ((1 8) (0 0)) ((1 7) (0 0) (3 0) (2 0)) ((3 7) (0 8)) ((0 2) (2 0) (3 1) (1 0)))))))



(deftest bsquare-test()
  (let* ((data (shared_pc1)))
    (check
      (equal (car (table-egs-to-lists (bsquare data 5)))
             '(69 13 90.99 217 161 FALSE)))))
