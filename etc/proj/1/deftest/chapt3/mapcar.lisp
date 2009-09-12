(deftest test-mapcar ()
  (check
    (equal '(11 12 13) (mapcar #'(lambda (x) (+ x 10)) '(1 2 3)))
  )
)
