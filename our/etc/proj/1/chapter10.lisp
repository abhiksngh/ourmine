(defmacro avg (&rest args)
  `(/ (+ ,@args) ,(length args)))

(deftest test-avg ()
  (check 
    (equal 3 (avg 4 3 2))))


