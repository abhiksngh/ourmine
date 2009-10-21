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
        (do ((test-rows-count (ceiling (* (length class-rows) 0.1))))
            ((= test-rows-count 0))
          (let ((random-row (nth (random (length class-rows)) class-rows)))
            (setf class-rows (delete random-row class-rows))
            (push random-row (table-all test)))
          (decf test-rows-count))
      (setf (table-all train) (append class-rows (table-all train)))))
    (table-update-discrete-uniques train)
    (table-update-discrete-uniques test)
    (values train test)))

(deftest split-preprocessor-test ()
  (check
    (multiple-value-bind (train test) (split-preprocessor (ar3))
      (and
        (equalp nil (set-difference (table-all (ar3)) (union (table-all train) (table-all test) :test #'equalp) :test #'equalp))
        (equalp nil (intersection (table-all train) (table-all test) :test #'equalp))))))

;;Takes a table structure and returns the symbol representing the minority class and 
;;the number of instances of the minority class.
(defun find-minority-class (tbl)
  (xindex tbl)
  (let ((minority-class nil)
        (minority-class-count most-positive-fixnum))
    (maphash #'(lambda (k v)
                (cond ((< v minority-class-count)
                      (setf minority-class k)
                      (setf minority-class-count v))))
             (header-f (table-class-header tbl)))
    (values (car minority-class) minority-class-count)))

(deftest find-minority-class-test ()
  (check
    (and
      (equalp (find-minority-class (ar3)) 'true)
      (equalp (find-minority-class (ar4)) 'true)
      (equalp (find-minority-class (ar5)) 'true))))

;;Takes a table structure and randomly removes instances from the non-minority classes
;;until all classes have the same frequency.
;;Returns a modified copy of the table structure.
(defun sub-sample (tbl)
  (setf tbl (table-deep-copy tbl))
  (multiple-value-bind (mclass mcount) (find-minority-class tbl)
    (dolist (klass (remove mclass (klasses tbl)))
      (do ((rows-removed 0)
           (classi (table-class tbl)))
          ((>= rows-removed (- (gethash (list klass klass) (header-f (table-class-header tbl))) mcount)))
          (let ((randomi (random (length (table-all tbl)))))
            (cond ((equalp klass (nth classi (eg-features (nth randomi (table-all tbl)))))
                    (setf (table-all tbl) (delete (nth randomi (table-all tbl)) (table-all tbl)))
                    (incf rows-removed))))))
    tbl))

(deftest sub-sample-test ()
  (check
    (and
      (equalp (length (egs (sub-sample (ar3)))) 16)
      (equalp (length (egs (sub-sample (ar4)))) 40)
      (equalp (length (egs (sub-sample (ar5)))) 16))))

;;Takes a table structure of training data and a table structure of test data and
;;returns a table structure of training data consisting of the 10 nearest neighbors
;;from the original training set of each instance in the test set, with duplicates
;;removed.
(defun burak-filter (train test)
  (setf train (table-deep-copy train))
  (let ((train-instances nil))
    (dolist (row (get-table-rows test))
      (setf train-instances (append (knn row train 10) train-instances)))
    (setf (table-all train) (remove-duplicates train-instances :test #'equalp))
    train))

(deftest burak-filter-test ()
  (check
    (and
      (equalp (length (egs (burak-filter (ar3) (ar3)))) (length (egs (ar3))))
      (equalp (length (egs (burak-filter (ar4) (ar5)))) 98))))

;;Takes a table structure containing training data and a list of table structures
;;containing test data and returns a table structure of training data consisting of
;;the union of the 10 nearest neighbors in the original training set of each instance 
;;in each test set.
(defun super-burak-filter (train test-sets)
  (setf train (table-deep-copy train))
  (let ((train-instances nil))
    (dolist (test test-sets)
      (setf train-instances (append (table-all (burak-filter train test)) train-instances)))
    (setf (table-all train) (remove-duplicates train-instances :test #'equalp))
    train))

(deftest super-burak-filter-test ()
  (check
    (and
      (equalp (length (egs (super-burak-filter (ar4) (list (ar5))))) (length (egs (burak-filter (ar4) (ar5)))))
      (equalp (length (egs (super-burak-filter (ar4) (list (ar3) (ar5))))) 107))))

