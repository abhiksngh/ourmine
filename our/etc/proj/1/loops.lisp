(deftest loops ()
  (check
    (if (loop for x in '(1 2 3 4) collect (+ x 2)) '(3 4 5 6))))
