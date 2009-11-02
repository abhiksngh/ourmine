(defun test-all-no-subsample (&optional (times 10))
  (let ((data '(shared_pc1 ar3 ar4 ar5 shared_cm1 shared_kc1 shared_kc2 shared_kc3 shared_mc2 shared_mw1)))
    (dolist (dat data)       
      (test-no-subsample (funcall dat)))))

(defun test-no-subsample (train &optional (times 10))
  (let ((ns '(2 4 8 10 12)))
    (dotimes (i times)
      (dolist (n ns)
        (infogain-nb train n)
        (bsquare-nb train n)
        (infogain-prism train n)
        (bsquare-prism train n)))))
       


;testing infogain and NB learner 
(defun infogain-nb (train n)
  (classify-learner 'bayes-classify-num (infogain-table (discretize train) n)))

;tesing  bsquared and NB
(defun bsquare-nb (train n)
  (classify-learner 'bayes-classify-num (bsquare train n)))

;testing prism
(defun infogain-prism (train n)
  (prism (infogain-table (discretize train) n)))

;testing bsquare prism 
(defun bsquare-prism (train n)
  (prism (discretize (bsquare train n))))


;;classfying a learner 
(defun classify-learner (fun train)
 (let* ((class (table-class train))
         (lst (split2bins train))
         (train (xindex (car (cdr lst))))
         (test (xindex (car lst)))
         (gotwants))
    (dolist (test_inst (get-features (table-all test)))
      (let* ((want (nth class test_inst))
             (got (funcall fun test_inst train)))
        (setf want (list want))
        (setf gotwants (append gotwants (list (append want got)))))) 
    (split (abcd-stats gotwants :verbose nil))))

