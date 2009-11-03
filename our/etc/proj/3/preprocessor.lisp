;;Takes a table structure and replaces all of the values in each numeric column
;;with log(value).  If the value is less than 0.0001, it is replaced with log(0.0001).
;;Returns a modified copy of the table structure.
(defun numeric-preprocessor (tbl)
  (setf tbl (table-deep-copy tbl))
  (dolist (row (get-table-feature-lists tbl))
    (doitems (column-header columni (get-table-column-headers tbl))
      (if (and (column-header-numericp column-header)
               (not (column-header-classp column-header))
               (not (unknownp (nth columni row))))
        (setf (nth columni row) (log (max 0.0001 (nth columni row)))))))
  tbl)

(deftest numeric-preprocessor-test ()
  (check
    (and 
      (equalp (first (eg-features (first (egs (numeric-preprocessor (ar3))))))
              (log (first (eg-features (first (egs (ar3)))))))
      (equalp (second (eg-features (first (egs (numeric-preprocessor (ar3))))))
              (log (second (eg-features (first (egs (ar3))))))))))

;;Combines multiple table structures into one.
(defun combine-preprocessor (tbl1 &rest tbls)
  (setf tbl1 (table-deep-copy tbl1))
  (dolist (tbl tbls)
    (setf (table-all tbl1) (append (table-all tbl) (table-all tbl1))))
  (table-update-discrete-uniques tbl1)
  tbl1)

(deftest combine-preprocessor-test ()
  (check
    (and
      (equalp (+ (length (table-all (ar3))) (length (table-all (ar4))) (length (table-all (ar5))))
              (length (table-all (combine-preprocessor (ar3) (ar4) (ar5)))))
      (equalp nil 
              (set-difference (union (table-all (ar3)) (table-all (ar4)) :test #'equalp)
                              (table-all (combine-preprocessor (ar3) (ar4))) :test #'equalp)))))

;;Takes a table structure and returns two table structures, a train table with
;;90% of the instances from the original table and a test table with 10% of the
;;instances from the original table.  The two new tables have approximately the
;;same frequency of each class as the original table.
(defun split-preprocessor (tbl)
  (setf tbl (table-deep-copy tbl))
  (let* ((train (table-deep-copy tbl))
         (test (table-deep-copy tbl)))
    (setf (table-all train) nil)
    (setf (table-all test) nil)
    (dolist (class (get-table-classes tbl))
      (let ((class-rows (get-table-class-rows tbl class)))
        (do ((test-rows-count (ceiling (* (length class-rows) 0.25))))
            ((= test-rows-count 0))
          (let ((random-row (nth (random (length class-rows)) class-rows)))
            (setf class-rows (delete random-row class-rows))
            (push random-row (table-all test)))
          (decf test-rows-count))
      (setf (table-all train) (append class-rows (table-all train)))))
    ;(table-update-discrete-uniques train)
    ;(table-update-discrete-uniques test)
    (values train test)))

(defun split-preprocessor25 (tbl)
  (setf tbl (table-deep-copy tbl))
  (let* ((train (table-deep-copy tbl))
         (test (table-deep-copy tbl)))
    (setf (table-all train) nil)
    (setf (table-all test) nil)
    ;(dolist (class (get-table-classes tbl))
      (let ((rows (get-table-rows tbl)))
        (do ((test-rows-count (ceiling (* (length rows) 0.25))))
            ((= test-rows-count 0))
          (let ((random-row (nth (random (length rows)) rows)))
            (setf rows (delete random-row rows))
            (push random-row (table-all test)))
          (decf test-rows-count))
      (setf (table-all train) (append rows (table-all train))))
	(values train test)))	

(deftest split-preprocessor-test ()
  (check
    (multiple-value-bind (train test) (split-preprocessor (ar3))
      (and
        (equalp nil (set-difference (table-all (ar3)) (union (table-all train) (table-all test) :test #'equalp) :test #'equalp))
        (equalp nil (intersection (table-all train) (table-all test) :test #'equalp))))))

;;Takes a table structure and returns a copy with each numeric column normalized between 0
;;and 1.
(defun normalize-preprocessor (tbl)
  (setf tbl (table-deep-copy tbl))
  (doitems (column-header columni (get-table-column-headers tbl))
    (if (column-header-numericp column-header)
      (let ((col-max (apply #'max (get-table-column tbl columni)))
            (col-min (apply #'min (get-table-column tbl columni))))
        (dolist (features (get-table-feature-lists tbl))
          (setf (nth columni features) (/ (- (nth columni features) col-min) (- col-max col-min)))))))
  tbl)

(deftest normalize-preprocessor-test ()
  (check
    (equalp
      (get-table-column (normalize-preprocessor (numeric-test-tbl)) 0)
      '(1 18/19 17/19 16/19 15/19 14/19 13/19 12/19 11/19 10/19 9/19 8/19 7/19 6/19 5/19 4/19 3/19 2/19 1/19 0))))

