
(defcache fib (x)
  (case x
    (0 0)
    (1 1)
    (t (+ (fib (- x 1))
	  (fib (- x 2))))))
