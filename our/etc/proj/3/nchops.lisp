(defun nchops (n table)
  (let ((newtable (transpose (get-data table))))
    (dolist (column newtable)
      (if (typep (first column) 'number)
          (let* ((sorted-col (sort column #'<))
                (col-size (length column))
                (chop-size (+ 1 (floor (/ n col-size))))
                (loop-count 1))
            (


             ;
             ;obviously not done yet, i'll finish this afternoon
             ;i just want to commit this for the sake of committing
             ;
