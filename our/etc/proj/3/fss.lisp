(defun utility (class)
  (if (equalp class 'true)
    0
    0))

(defun utility1 (class)
  (if (equalp class 'true)
    1
    0))

(defun utility2 (class)
  (if (equalp class 'true)
    0
    1))

(defun utilityr (class)
  (nth (random 2) '(0 1)))

(defun get-b-squared-score (tbl best rest columni row)
  (let ((b (/ (get-table-value-frequency best columni (nth columni (eg-features row)))
              (get-table-size best)))
        (r (/ (get-table-value-frequency rest columni (nth columni (eg-features row)))
              (get-table-size rest))))
    (if (< b r)
      0
      (/ (square b) (+ b r)))))

(defun b-squared (tbl &optional (utility #'utility))
  (setf (table-all tbl) (sort (get-table-rows tbl) #'> :key #'(lambda (row) (funcall utility (eg-class row)))))
  (let ((best (table-blank-copy tbl))
        (rest (table-blank-copy tbl))
        (rown (get-table-size tbl))
        (column-scores nil))
    (doitems (row rowi (get-table-rows tbl))
      (if (< rowi (floor (* rown 0.2)))
        (push row (table-all best))
        (push row (table-all rest))))
    (table-update best)
    (table-update rest)
    (doitems (column-header columni (get-table-column-headers tbl))
      (push 0 column-scores)
      (unless (column-header-classp column-header)
        (setf (table-all tbl) 
              (sort (get-table-rows tbl) 
                    #'< 
                    :key #'(lambda (row) (get-b-squared-score tbl best rest columni row))))
        (if (oddp (get-table-size tbl))
          (setf (car column-scores) (get-b-squared-score tbl best rest columni (nth (floor (/ (get-table-size tbl) 2)) (get-table-rows tbl))))
          (setf (car column-scores) (/ (+ (get-b-squared-score tbl best rest columni (nth (1- (/ (get-table-size tbl) 2)) (get-table-rows tbl)))
                                          (get-b-squared-score tbl best rest columni (nth (/ (get-table-size tbl) 2) (get-table-rows tbl))))
                                       2)))))
    (setf column-scores (nreverse column-scores))
    (print "selected columns")
    (doitems (score columni column-scores)
      (if (> score 0)
        (print (header-name (get-table-column-header tbl columni)))))))

(defun b-squared-demo (&optional (tbl (shared_pc1)))
  (b-squared (10bins-eq-freq tbl))
  (b-squared (10bins-eq-freq tbl) #'utility1)
  (b-squared (10bins-eq-freq tbl) #'utility2)
  (b-squared (10bins-eq-freq tbl) #'utilityr))

