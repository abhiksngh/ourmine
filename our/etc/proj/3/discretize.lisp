;;Returns a table with the values of each numeric column divided
;;into n bins.  Each bin covers an equal part of the range between the
;;max and min values of each column.
;;Modifies tbl.
(defun nbins-eq-width (tbl n)
  (doitems (column-header columni (get-table-column-headers tbl))
    (if (column-header-numericp column-header)
      (let ((col-max (apply #'max (get-table-column tbl columni)))
            (col-min (apply #'min (get-table-column tbl columni))))
        (dolist (features (get-table-feature-lists tbl))
          (setf (nth columni features) 
                (min (1- n) (floor (* (/ (- (nth columni features) col-min) (- col-max col-min)) n)))))
        (numeric2discrete tbl columni))))
  (table-update tbl))

;;Returns a table with the values of each numeric column divided
;;into 10 equal width bins.
(defun 10bins-eq-width (tbl)
  (nbins-eq-width tbl 10))

(deftest 10bins-eq-width-test ()
  (check
    (equalp
      (10bins-eq-width (numeric-test-tbl))
      (table-update (eq-width-discretized-test-tbl)))))

;;Returns a table with the values of each numeric column divided 
;;into n bins.  Each bin contains approximately the same number of elements.
(defun nbins-eq-freq (tbl n)
  (doitems (column-header columni (get-table-column-headers tbl))
    (if (column-header-numericp column-header)
      (let ((column (sort (get-table-column tbl columni) #'<))
            (n-column (get-table-size tbl)))
        (dolist (features (get-table-feature-lists tbl))
          (setf (nth columni features) (min (1- n) (floor (* (/ (position (nth columni features) column) (1- n-column)) n)))))
        (numeric2discrete tbl columni))))
  (table-update tbl))

;;Returns a table with the values of each numeric column divided
;;into 10 equal frequency bins.
(defun 10bins-eq-freq (tbl)
  (nbins-eq-freq tbl 10))

(deftest 10bins-eq-freq-test ()
  (check
    (equalp
      (10bins-eq-freq (numeric-test-tbl))
      (table-update(eq-width-discretized-test-tbl)))))

