;subsetp
(defun elementOf (list value)
  (let ((found nil))
  (dolist (current list)
    (if (equalp current value)
        (setf found T)
        nil))found))

;(length (remove-duplicates list))
(defun unique-count (lst)
  (length (remove-duplicates lst)))


;(defun unique-count (list)
 ;; (let* ((sorted-list)
  ;       (uniques 0)
  ;       (iteration 1)
   ;      (x))
   ; (if (numberp (first list)
   ; (dolist (current sorted-list uniques)
     ; (if (equalp current (nth iteration sorted-list))
    ;       (incf iteration)
      ;    (progn
       ;     (incf iteration)(incf uniques))))))

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
         (row-num)
         (column-num)
         )
    (if (subsetp (list test-value) test-column)
        (progn
          (dolist (current test-column)
            (if (equalp current test-value)
                (incf pass-count)
                (incf fail-count)))
          (dolist (current (transpose dataset))
            (setf uniques-per-column (append uniques-per-column (unique-count current)))
            (setf row-num 1)
            (dolist (current2 dataset)
              ;probably not a good idea to use current again
              ;changed to current2
              (setf column-num 1)
              )
            )
          )
        
        ;(format t "value not found~%")
        (print "value not found")
        )
    )
  )
        



         
         
        
    
  

  ;sample execution: (naivebayes 4 (nth x (transpose (get-data (*datatable*)))) (*datatable*))
