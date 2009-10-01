(defun test-data ()
  (data
   :name 'test
   :columns '($number1 symbol $number2 stuff)
   :egs '((1 hey 2 true)
          (2 hey 2 true)
          (3 hey 2 true)
          (4 hey 2 false)
          (4 bye 2 false)
)))

(defun normalize ()
  (let ((tbl (xindex (test-data))))
    (dolist (col (table-columns tbl))
      (if (numericp (header-name col)) ;checks if the current column is numeric
          (if (/= 0 ( )) ;checks if max-min is not 0
              (progn
                (dolist (row (tbl-f))
                  (if (numberp ) ;check if entry in the column and row is a number
                      ()))) ;setf data (/(- row min) (- max min))
             (progn
               (dolist (row (tbl-f))
                 (if (numberp ) ;check if entry in the colum and row is a number
                     ())))))))) ;setf data 1.0
