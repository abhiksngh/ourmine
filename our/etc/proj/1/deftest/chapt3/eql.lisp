(deftest test-eql ()
  (check
    (not(eql (cons 'a nil) (cons 'a nil)))
  )
)

