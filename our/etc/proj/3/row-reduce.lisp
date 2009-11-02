(defun default-row-reducer (train test)
  train)

;;Takes a table structure and returns the symbol representing the minority class and 
;;the number of instances of the minority class.
(defun find-minority-class (tbl)
  (let ((minority-class nil)
        (minority-class-count most-positive-fixnum))
    (dolist (class (get-table-classes tbl))
      (if (< (length (get-table-class-rows tbl class))
             minority-class-count)
        (setf minority-class class
              minority-class-count (length (get-table-class-rows tbl class)))))
    minority-class))

(deftest find-minority-class-test ()
  (check
    (and
      (equalp (find-minority-class (ar3)) 'true)
      (equalp (find-minority-class (ar4)) 'true)
      (equalp (find-minority-class (ar5)) 'true))))

;;Takes a table structure and randomly removes instances from the non-minority classes
;;until all classes have the same frequency.
;;Returns a modified copy of the table structure.
(defun sub-sample (train &optional test)
  (setf train (table-deep-copy train))
  (let* ((minority-class (find-minority-class train))
         (n (length (get-table-class-rows train minority-class)))
         (random-rows nil))
    (dolist (class (get-table-classes train))
      (let ((class-rows (get-table-class-rows train class)))
        (dotimes (i n)
          (let ((randomi (random (length class-rows))))
            (push (nth randomi class-rows) random-rows)
            (setf class-rows (remove (nth randomi class-rows) class-rows))))))
      (setf (table-all train) random-rows)
    train))

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

;;Reduces the number of defect rows in tbl to n and reduces the number of
;;non-defect rows to n.
(defun micro-sample (tbl &optional (n 25) (defect-class 'true))
  (setf tbl (table-deep-copy tbl))
  (let* ((defect-rows (get-table-class-rows tbl defect-class))
         (non-defect-rows (set-difference (get-table-rows tbl) defect-rows))
         (random-rows nil))
    (setf n (min n (length defect-rows)))
    (dotimes (i n)
      (let ((randomi (random (length defect-rows))))
        (push (nth randomi defect-rows) random-rows)
        (setf defect-rows (remove (nth randomi defect-rows) defect-rows))))
    (dotimes (i n)
      (let ((randomi (random (length non-defect-rows))))
        (push (nth randomi non-defect-rows) random-rows)
        (setf non-defect-rows (remove (nth randomi non-defect-rows) non-defect-rows))))
    (setf (table-all tbl) random-rows)
    tbl))

(deftest micro-sample-test ()
  (check
    (and
      (equalp (length (table-all (micro-sample (ar4)))) 40)
      (equalp (length (table-all (micro-sample (ar4) 15))) 30)
      (equalp (length (table-all (micro-sample (ar4) 20))) 40)
      (equalp (length (table-all (micro-sample (ar4) 25))) 40))))

;;Reduces the number of rows in train to 25 defect rows and 25 non-defect rows.
(defun micro-sample-n25 (train &optional test)
  (micro-sample train))

