(deftest myStack ()
      (let (x a)
      (check
       (push 'b x)
       (pop x)
       (eql (pop x) nil))))
