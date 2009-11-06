;;Row reducer that doesn't reduce any rows.
(defun default-row-reducer (train test)
  train)

;;Reduces the number of defect and non-defect rows in tbl to n.
;;Modifies tbl.
(defun micro-sample (tbl &optional (n 25))
  (let* ((defect-class (get-defect-class tbl))
         (defect-rows (get-table-class-rows tbl defect-class))
         (n-defect-rows (get-table-class-frequency tbl defect-class))
         (non-defect-rows (set-difference (get-table-rows tbl) defect-rows))
         (n-non-defect-rows (length non-defect-rows))
         (random-rows nil))
    (setf n (min n n-defect-rows))
    (dotimes (i n)
      (let* ((randomi (random (- n-defect-rows i)))
             (random-row (nth randomi defect-rows)))
        (push random-row random-rows)
        (setf defect-rows (delete random-row defect-rows))))
    (dotimes (i n)
      (let* ((randomi (random (- n-non-defect-rows i)))
             (random-row (nth randomi non-defect-rows)))
        (push random-row random-rows)
        (setf non-defect-rows (delete random-row non-defect-rows))))
    (setf (table-all tbl) random-rows)
    (table-update tbl)))

(deftest micro-sample-test ()
  (check
    (and
      (equalp (length (table-all (micro-sample (ar4)))) 40)
      (equalp (length (table-all (micro-sample (ar4) 15))) 30)
      (equalp (length (table-all (micro-sample (ar4) 20))) 40)
      (equalp (length (table-all (micro-sample (ar4) 25))) 40))))

;;Does micro-sampling on train with n = the frequency of the defect class in
;;train.  Modifies train.
(defun sub-sample (train &optional test)
  (micro-sample train (get-table-class-frequency train (get-defect-class train))))

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
;;Modifies train.
(defun burak-filter (train test)
  (let ((train-instances nil))
    (dolist (row (get-table-rows test))
      (setf train-instances (nconc (knn row train 10) train-instances)))
    (setf (table-all train) (remove-duplicates train-instances))
    (table-update train)))

(deftest burak-filter-test ()
  (check
    (and
      (equalp (length (egs (burak-filter (ar3) (ar3)))) (length (egs (ar3))))
      (equalp (length (egs (burak-filter (ar4) (ar5)))) 98))))

;;Takes a table structure containing training data and a list of table structures
;;containing test data and returns a table structure of training data consisting of
;;the union of the 10 nearest neighbors in the original training set of each instance 
;;in each test set.
;;Modifies train.
(defun super-burak-filter (train test-sets)
  (let ((train-instances nil))
    (dolist (test test-sets)
      (setf train-instances (nconc (table-all (burak-filter train test)) train-instances)))
    (setf (table-all train) (remove-duplicates train-instances))
    (table-update train)))

(deftest super-burak-filter-test ()
  (check
    (and
      (equalp (length (egs (super-burak-filter (ar4) (list (ar5))))) (length (egs (burak-filter (ar4) (ar5)))))
      (equalp (length (egs (super-burak-filter (ar4) (list (ar3) (ar5))))) 107))))

;;Reduces the number of rows in train to 25 defect rows and 25 non-defect rows.
(defun micro-sample-n25 (train &optional test)
  (micro-sample train))

;;Reduces the number of rows in train to 50 defect rows and 50 non-defect rows.
(defun micro-sample-n50 (train &optional test)
  (micro-sample train))

;;Reduces the number of rows in train to 100 defect rows and 100 non-defect rows.
(defun micro-sample-n100 (train &optional test)
  (micro-sample train))

;;Reduces the number of rows in train to 200 defect rows and 200 non-defect rows.
(defun micro-sample-n200 (train &optional test)
  (micro-sample train))

