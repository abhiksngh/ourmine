;Test Count: 1
;Required: 14.5, figure 14.2


;14.5  Iteration with loop

(deftest test-14_5 ()
  (check
    (equalp (loop for x in '(11 12 13 14)
                 collect (1+ x)) '(12 13 14 15))))
