(deftest test-comma()
  (check
    (equal '(1 2 3 4) `(1 2 3 ,(+ 2 2)))
  )
)

(defmacro in (obj &rest choices)
  (let ((insym (gensym)))
    `(let ((,insym ,obj))
       (or ,@(mapcar #'(lambda (c) `(eql ,insym ,c))
                     choices)))))


(deftest test-in ()
  (check
    (in '+ '% '- '+)
  )
)

(defmacro avg (&rest args)
  `(/ (+ ,@args) ,(length args)))


(deftest test-avg ()
  (check 
    (equal (avg 1 2 3) 2)
  )
)

