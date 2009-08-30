(defun shuffle (l)
  (dotimes (i (length l) l)
    (rotatef
     (elt l i)
     (elt l (random (length l))))))

(defun head (l) (car l))
(defun tail (l) (first (last l)))
