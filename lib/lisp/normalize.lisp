(defun test-data1 ()
  (data
   :name 'test
   :columns '($number1 symbol $number2 stuff)
   :egs '((2 hey 2 true)
          (1 hey 2 true)
          (3 hey 2 true)
          (4 hey 2 false)
          (4 bye 2 false)
          )))

(defun normalize ()
  (let ((tbl (xindex (test-data1)))
        (n 0))
    (dolist (col (table-columns tbl) tbl)
      (when (numericp (header-name col))
        (let ((n-normal (make-normal)))
        (dolist (row (table-all tbl))
          (when (numberp (nth n (eg-features row)))
              (add n-normal (nth n (eg-features row)))))
        (if (zerop (- (normal-max n-normal) (normal-min n-normal))) ;checks if max-min is zero to avoid dividing by 0
            (progn
              (dolist (row (table-all tbl)) ;loop through each row of data
                (if (numberp (nth n (eg-features row))) ;checks if that data is a number
                    (setf (nth n (eg-features row)) 1.0)))) ;sets that data to 1.0 instead of dividing by 0
            (progn
              (dolist (row (table-all tbl)) ;loop through each row of data
                (if (numberp (nth n (eg-features row))) ;checks if the data is a number
                    (setf (nth n (eg-features row)) (* (/ (- (nth n (eg-features row)) (normal-min n-normal)) (- (normal-max n-normal) (normal-min n-normal))) 1.0)))))))) ;normalizes the number
      (incf n)))) ;increment the counter of the column being altered
