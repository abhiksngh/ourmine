
;testing infogain and NB learner 
(defun infogain-nb(train n)
  (classify-nb (infogain-table (discretize train) n)))

;tesing  bsquared and NB
(defun bsquare-nb (train n)
  (classify-nb (bsquare train n)))


;;classfying infogain and NB learner
(defun classify-nb (train)
  (let* ((class (table-class train))
         (lst (split2bins train))
         (train (xindex (car (cdr lst))))
         (test (xindex (car lst)))
         (gotwants))
    (dolist (test_inst (get-features (table-all test)))
      (let* ((want (nth class test_inst))
             (got (bayes-classify-num test_inst train)))
        (setf want (list want))
        (setf gotwants (append gotwants (list (append want got)))))) 
    (split (abcd-stats gotwants :verbose nil))))

