(defun elementOf (list value)
  (let ((found nil))
  (dolist (current list)
    (if (equalp current value)
        (setf found T)
        nil))found))

(defun unique-count (list)
  (let* ((sorted-list (sort list #'<))
        (uniques 0)
        (iteration 1))
    (dolist (current sorted-list uniques)
      (if (equalp current (nth iteration sorted-list))
           (incf iteration)
          (let ((x))(incf iteration)(incf uniques))))))

;(defun unique-count (list)
;  (let ((uniques 0)
;        (iteration 1)
;        (list-of-uniques))
;    (dolist (current list uniques)
;      (dolist (uniques-current list-of-uniques)
;        (if (equalp uniques-current current)
;            (break)
;            ())
;        (incf uniques)))))

(defun naivebayes (test-value test-column table); test-value = value to test against, numeric or discrete test-column, must be list of values, table is table
  (let* ((dataset (get-data table))
         (pass-count 0)
         (fail-count 0)
         (uniques-per-column)
    (if (equalp (elementOf test-column test-value) T)
        ((dolist (current test-column)
           (if (equalp current test-value)
               (incf pass-count)
               (incf fail-count)))
         (dolist (current (transpose (dataset)))
           (setf uniques-per-column (append uniques-per-column (unique-count current)))
         (let((row-num 1))
           (dolist (current dataset)
             (let ((column-num 1))
               
                 
        (format t "value not found~%" nil))))





  ;sample execution: (naivebayes 4 (nth x (transpose (get-data (*datatable*)))) (*datatable*))
