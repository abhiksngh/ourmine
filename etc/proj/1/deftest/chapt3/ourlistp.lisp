; this functions returns true if the arg is a list or nil
(defun our-listp (x)
  (or (null x) (consp x))
)

(deftest test-our-listp ()
  (check
    (or (our-listp(list 'a 'b 'c)))
  )
)
   
