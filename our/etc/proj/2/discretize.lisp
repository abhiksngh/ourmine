;;Returns a copy of tbl with the values of each numeric column divided
;;into n bins.  Each bin covers an equal part of the range between the
;;max and min values of each column.
(defun nbins-eq-width (tbl n)
  (setf tbl (table-deep-copy tbl))
  (let ((max-array (make-array (length (table-columns tbl)) :initial-element 0))
        (min-array (make-array (length (table-columns tbl)) :initial-element most-positive-fixnum)))
    (doitems (column-header columni (get-table-column-headers tbl))
      (if (column-header-numericp column-header)
        (setf (aref max-array columni) (apply #'max (remove-if #'ignorep (get-table-column tbl columni)))
              (aref min-array columni) (apply #'min (remove-if #'ignorep (get-table-column tbl columni))))))
    (dolist (row (get-table-feature-lists tbl))
      (doitems (feature columni row)
        (unless (unknownp feature)
          (if (table-column-numericp tbl columni)
            (setf (nth columni row) (min (1- n) (floor (* (/ (- feature (aref min-array columni)) (- (aref max-array columni) (aref min-array columni))) n))))))))
    (doitems (column-header columni (get-table-column-headers tbl))
      (if (column-header-numericp column-header)
        (numeric2discrete tbl columni)))
     tbl))

;;Returns a copy of tbl with the values of each numeric column divided
;;into 10 equal width bins.
(defun 10bins-eq-width (tbl)
  (nbins-eq-width tbl 10))

(deftest 10bins-eq-width-test ()
  (check
    (equalp
      (10bins-eq-width (numeric-test-tbl))
      (eq-width-discretized-test-tbl))))

;;Returns a copy of tbl with the values of each numeric column divided 
;;into n bins.  Each bin contains approximately the same number of elements.
(defun nbins-eq-freq (tbl n)
  (setf tbl (table-deep-copy tbl))
  (doitems (column-header columni (get-table-column-headers tbl))
    (if (column-header-numericp column-header)
      (let ((column (sort (get-table-column tbl columni) #'<)))
        (dolist (row (get-table-feature-lists tbl))
          (setf (nth columni row) (min (1- n) (floor (* (/ (position (nth columni row) column) (1- (length column))) n)))))))) 
  (doitems (column-header columni (get-table-column-headers tbl))
    (if (column-header-numericp column-header)
      (numeric2discrete tbl columni)))
  tbl)  

;;Returns a copy of tbl with the values of each numeric column divided
;;into 10 equal frequency bins.
(defun 10bins-eq-freq (tbl)
  (nbins-eq-freq tbl 10))

(deftest 10bins-eq-freq-test ()
  (check
    (equalp
      (10bins-eq-freq (numeric-test-tbl))
      (eq-width-discretized-test-tbl))))

