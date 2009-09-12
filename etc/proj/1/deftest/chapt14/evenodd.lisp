(defun even/odd (ns)
  (loop for n in ns
       if (evenp n)
       collect n into evens
       else collect n into odds
   finally (return (values evens odds))))

(deftest test-evenodd ()
  (check (compare-lists (even/odd '(4 5 6 7)) '(4 6))))
