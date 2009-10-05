(defun test-data ()
  (data
   :name 'test
   :columns '($number1 symbol $number2 stuff)
   :egs '((2 hey 2 true)
          (1 hey 2 true)
          (3 hey 2 true)
          (4 hey 2 false)
          (4 bye 2 false)
          )))

;(defun normalize ()
;  (let* ((tbl (xindex (test-data)))
;         (n 0))
;    (dolist (col (table-columns tbl) tbl)
;      (if (numericp (header-name col))
;          (progn
;            (if (zerop (max-min)) ;checks if max-min is zero to avoid dividing by 0
;                (progn
;                  (dolist (row (table-all tbl)) ;loop through each row of data
;                    (if (numberp (nth n (eg-features row))) ;checks if that data is a number
;                        (setf (nth n (eg-features row)) 1.0)))) ;sets that data to 1.0 instead of dividing by 0
;                (progn
;                  (dolist (row (table-all tbl)) ;loop through each row of data
;                    (if (numberp (nth n (eg-features row))) ;checks if the data is a number
;                        (setf (nth n (eg-features row)) (/ (- (nth n (eg-features row)) min) (- max min))))))))) ;normalizes the number
;      (setf n (+ n 1))))) ;increment the counter of the column being altered
