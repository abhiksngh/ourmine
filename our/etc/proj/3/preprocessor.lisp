;;Takes a table structure and replaces all of the values in each numeric column
;;with log(value).  If the value is less than 0.0001, it is replaced with log(0.0001).
;;Modifieds tbl.
(defun numeric-preprocessor (tbl)
  (dolist (row (get-table-feature-lists tbl))
    (doitems (column-header columni (get-table-column-headers tbl))
      (if (and (column-header-numericp column-header)
               (not (column-header-classp column-header)))
        (setf (nth columni row) (log (max 0.0001 (nth columni row)))))))
  (table-update tbl))

(deftest numeric-preprocessor-test ()
  (check
    (and 
      (equalp (first (eg-features (first (egs (numeric-preprocessor (ar3))))))
              (log (first (eg-features (first (egs (ar3)))))))
      (equalp (second (eg-features (first (egs (numeric-preprocessor (ar3))))))
              (log (second (eg-features (first (egs (ar3))))))))))

;;Combines multiple table structures into one.
;;Modifies tables in tbls.
(defun combine-preprocessor (&rest tbls)
  (dolist (tbl (cdr tbls))
    (setf (table-all (car tbls)) (nconc (table-all tbl) (table-all (car tbls)))))
  (table-update (car tbls)))

(deftest combine-preprocessor-test ()
  (check
    (and
      (equalp (+ (length (table-all (ar3))) (length (table-all (ar4))) (length (table-all (ar5))))
              (length (table-all (combine-preprocessor (ar3) (ar4) (ar5)))))
      (equalp nil 
              (set-difference (union (table-all (ar3)) (table-all (ar4)) :test #'equalp)
                              (table-all (combine-preprocessor (ar3) (ar4))) :test #'equalp)))))

;;Takes a table structure and splits it into n new table structures, each with
;;1/n of the rows from the original table.  The frequency of each class in the each of 
;;the new tables is approximately the same as in the original table.  
(defun split-preprocessor (tbl &optional (n 10))
  (let ((class-rows-lst nil)
        (bins nil))
    (setf n (min n (get-table-class-frequency tbl (get-defect-class tbl))))
    (dotimes (i n)
      (push (table-blank-copy tbl) bins))
    (dolist (class (get-table-classes tbl))
      (let ((class-rows (get-table-class-rows tbl class))
            (n-class-rows (get-table-class-frequency tbl class)))
        (dotimes (i n-class-rows)
          (let* ((randomi (random (- n-class-rows i)))
                 (random-row (nth randomi class-rows)))
            (push random-row (table-all (nth (mod i n) bins)))
            (setf class-rows (remove random-row class-rows))))))
    (mapc #'table-update bins)))

(deftest split-preprocessor-test ()
  (check
    (and
      (equalp nil (set-difference (table-all (ar3)) (reduce #'union (mapcar #'table-all (split-preprocessor (ar3)))) :test #'equalp))
      (equalp (length (table-all (ar3))) (apply #'+ (mapcar #'length (mapcar #'table-all (split-preprocessor (ar3)))))))))

;;Takes a table structure and returns a copy with each numeric column normalized between 0
;;and 1.
(defun normalize-preprocessor (tbl)
  (doitems (column-header columni (get-table-column-headers tbl))
    (if (column-header-numericp column-header)
      (let ((col-max (apply #'max (get-table-column tbl columni)))
            (col-min (apply #'min (get-table-column tbl columni))))
        (dolist (features (get-table-feature-lists tbl))
          (setf (nth columni features) (/ (- (nth columni features) col-min) (- col-max col-min)))))))
  (table-update tbl))

(deftest normalize-preprocessor-test ()
  (check
    (equalp
      (get-table-column (normalize-preprocessor (numeric-test-tbl)) 0)
      '(1 18/19 17/19 16/19 15/19 14/19 13/19 12/19 11/19 10/19 9/19 8/19 7/19 6/19 5/19 4/19 3/19 2/19 1/19 0))))

