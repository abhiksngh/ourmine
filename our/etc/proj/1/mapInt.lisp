(defun map-int (fn n)
  (let ((acc nil))
    (dotimes (i n)
      (push (funcall fn i) acc))
    (nreverse acc)))

(deftest mapInt ()
  (check
    (if (map-int #'identity 5) '(0 1 2 3 4))))
