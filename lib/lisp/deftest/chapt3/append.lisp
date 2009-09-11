(deftest test-append ()
  (check
    (equal '(1 2 3 4 5) (append '(1 2) '(3 4) '(5)))
  )
)

