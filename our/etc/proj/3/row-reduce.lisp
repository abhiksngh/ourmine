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
      (equalp (length (egs (super-burak-filter (ar4) (list (ar5))))) 98))))

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

(defun analyze1 ()
  (let ((collections (list (list (ar3) (ar4) (ar5))
                           (list (ar3short) (ar4short) (ar5short))
                           (list (shared_pc1) (shared_cm1) (shared_kc1) (shared_kc2) (shared_kc3) (shared_mc2) (shared_mw1))
                           (list (pc1short) (cm1short) (kc1short) (kc2short) (kc3short) (mc2short) (mw1short))
                           (list (ar3com) (ar4com) (ar5com) (pc1com) (cm1com) (kc1com) (kc2com) (kc3com) (mc2com) (mw1com)))))
    (dolist (collection collections)
      (dolist (train collection)
        (format t "~a~%" (table-name train))
        (format t "~9a ~9a ~11a~%" "FREQUENCY" "ROW COUNT" "ROW PERCENT")
        (format t "--------- --------- -----------~%")
        (let ((freq-counts (make-hash-table :test #'eq))
              (row-freq nil)
              (train-rows (get-table-rows train)))
          (mapc #'(lambda (row) (setf (gethash row freq-counts) 0)) (get-table-rows train))
          (dolist (test (remove train collection))
            (setf (table-all train) (copy-list train-rows))
            (dolist (row (get-table-rows (burak-filter (table-update train) test)))
              (inch row freq-counts)))
          (maphash #'(lambda (k v) (push v row-freq)) freq-counts)
          (mapcar #'(lambda (freq) 
                      (format t "~9a ~9@a ~10,1F%~%" (format nil "~a/~a" freq (1- (length collection)))
                                                     (format nil "~a/~a" (count freq row-freq) (length row-freq))
                                                     (* (/ (count freq row-freq) (length row-freq)) 100)))
                  (sort (remove-duplicates row-freq) #'<)))
        (format t "~%")))))

(defun analyze2 ()
  (let ((collections (list (list (ar3) (ar4) (ar5))
                           (list (ar3short) (ar4short) (ar5short))
                           (list (shared_pc1) (shared_cm1) (shared_kc1) (shared_kc2) (shared_kc3) (shared_mc2) (shared_mw1))
                           (list (pc1short) (cm1short) (kc1short) (kc2short) (kc3short) (mc2short) (mw1short))
                           (list (ar3com) (ar4com) (ar5com) (pc1com) (cm1com) (kc1com) (kc2com) (kc3com) (mc2com) (mw1com)))))
    (dolist (collection collections)
      (format t "~10a ~10a ~9a ~11a~%" "TRAIN" "TEST" "ROW COUNT" "ROW PERCENT")
      (format t "---------- ---------- --------- -----------~%")
      (dolist (train collection)
        (dolist (test (remove train collection))
          (let ((tbl (burak-filter (table-deep-copy train) test)))
            (format t "~10a ~10a ~9@a ~10,1F%~%" (table-name train) 
                                                 (table-name test) 
                                                 (format nil "~a/~a" (length (get-table-rows tbl)) (length (get-table-rows train))) 
                                                 (* (/ (length (get-table-rows tbl)) (length (get-table-rows train))) 100)))))
      (format t "~%"))))

(defun analyze3 ()
  (let ((collections (list (list (ar3) (ar4) (ar5))
                           (list (ar3short) (ar4short) (ar5short))
                           (list (shared_pc1) (shared_cm1) (shared_kc1) (shared_kc2) (shared_kc3) (shared_mc2) (shared_mw1))
                           (list (pc1short) (cm1short) (kc1short) (kc2short) (kc3short) (mc2short) (mw1short))
                           (list (ar3com) (ar4com) (ar5com) (pc1com) (cm1com) (kc1com) (kc2com) (kc3com) (mc2com) (mw1com)))))
    (dolist (collection collections)
      (mapc #'(lambda (tbl) (format t "~a " (table-name tbl))) collection)
      (format t "~%")
      (doitems (column-header columni (filter #'(lambda (ch) (and (not (column-header-classp ch)) ch)) (get-table-column-headers (car collection))))
        (format t "~a~%" (header-name column-header))
        (format t "~10a ~10a ~10a ~10a ~10a ~10a~%" "DATA SET" "MIN" "MEDIAN" "MAX" "MEAN" "STDEV")
        (format t "---------- ---------- ---------- ---------- ---------- ----------~%")
        (dolist (tbl collection)
          (let ((normal (make-normal)))
            (mapc #'(lambda (value) (add normal value)) (get-table-column tbl columni))
            (format t "~10a ~10,1F ~10,1F ~10,1F ~10,1F ~10,2F~%" (table-name tbl)
                                                                  (normal-min normal)
                                                                  (median (get-table-column tbl columni))
                                                                  (normal-max normal)
                                                                  (mean normal)
                                                                  (stdev normal))))
        (format t "~%"))
      (format t "~%"))))

(defun analyze4 ()
  (let ((collections (list (list (ar3) (ar4) (ar5))
                           (list (ar3short) (ar4short) (ar5short))
                           (list (shared_pc1) (shared_cm1) (shared_kc1) (shared_kc2) (shared_kc3) (shared_mc2) (shared_mw1))
                           (list (pc1short) (cm1short) (kc1short) (kc2short) (kc3short) (mc2short) (mw1short))
                           (list (ar3com) (ar4com) (ar5com) (pc1com) (cm1com) (kc1com) (kc2com) (kc3com) (mc2com) (mw1com)))))
    (dolist (collection collections)
      (mapc #'(lambda (tbl) (format t "~a " (table-name tbl))) collection)
      (format t "~%")
      (doitems (column-header columni (filter #'(lambda (ch) (and (not (column-header-classp ch)) ch)) (get-table-column-headers (car collection))))
        (format t "~a~%" (header-name column-header))
        (format t "~10a ~10a ~10a ~10a ~10a ~10a ~10a~%" "DATA SET" "CLASS" "MIN" "MEDIAN" "MAX" "MEAN" "STDEV")
        (format t "---------- ---------- ---------- ---------- ---------- ---------- ----------~%")
        (dolist (tbl collection)
          (dolist (class (sort (copy-list (get-table-classes tbl)) #'string< :key #'(lambda (s) (format nil "~a" s))))
            (let ((normal (gethash class (header-f (find (header-name column-header) (get-table-column-headers tbl) :key #'header-name :test #'equalp)))))
              (format t "~10a ~10a ~10,1F ~10,1F ~10,1F ~10,1F ~10,2F~%" (table-name tbl)
                                                                         class
                                                                         (normal-min normal)
                                                                         (median (get-table-class-column tbl columni class))
                                                                         (normal-max normal)
                                                                         (mean normal)
                                                                         (stdev normal)))))
        (format t "~%"))
      (format t "~%"))))
