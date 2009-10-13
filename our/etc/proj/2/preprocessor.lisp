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

