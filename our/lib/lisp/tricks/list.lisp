(defun shuffle (l)
  (dotimes (i (length l) l)
    (rotatef
     (elt l i)
     (elt l (random (length l))))))

(defun head (l) (car l))
(defun tail (l) (first (last l)))


(deftest  test-head ()
  (check
    (eql (head '(aa bb cc)) 'aa)))

(defun ourmember (x l)
  (if (null l)
      nil
      (or (eql x (first l))
	  (ourmember x (rest l)))))

(defun ourmember1 (x l)
  (and l
       (or 
	(eql x (first l))
	(ourmember x (rest l)))))


