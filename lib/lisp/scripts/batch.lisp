(defun batch(&optional (datafile "letter"))
  (load "miner.lisp")
  (demohyperpipesnew datafile 0 0 0 0 0) ; disjunction
  (demohyperpipesnew datafile 0 1 0 0 0) ; mean max-min
  (demohyperpipesnew datafile 0 1 1 0 0) ; mean largestgap
  (demohyperpipesnew datafile 0 0 0 1 0) ; original
  (demohyperpipesnew datafile 0 0 0 0 1) ; centroids  
  (dotimes (i 10)
    (demohyperpipesnew datafile (* 0.05 (+ i 1)) 0 0 0 0) 
  )
  (quit)
)
