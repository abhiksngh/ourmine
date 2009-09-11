(defmacro while (test &rest body)
  `(do ()
       ((not ,test))
     ,@body))


(defun quicksort (vec l r)
  (let ((i l) 
        (j r) 
        (p (svref vec (round (+ l r) 2))))    ; 1
    (while (<= i j)                           ; 2
      (while (< (svref vec i) p) (incf i))
      (while (> (svref vec j) p) (decf j))
      (when (<= i j)
        (rotatef (svref vec i) (svref vec j))
        (incf i)
        (decf j)))
    (if (> (- j l) 1) (quicksort vec l j))    ; 3
    (if (> (- r i) 1) (quicksort vec i r)))
  vec)

