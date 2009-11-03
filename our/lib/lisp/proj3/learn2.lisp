
(defun write-stats-2 (filename str)
  (let (st)
  (setf st (open (make-pathname :name filename) :direction :output
                            :if-exists :supersede))
  (format st str)
  (close st)))


(defun test-all-no-subsample (&optional (times 10))
  (let* ((data-shared '(shared_pc1 shared_cm1 shared_kc1 shared_kc2 shared_kc3 shared_mc2 shared_mw1))
        (data-ar '(ar3 ar4 ar5))
        (results-shared)
        (results-ar))
    (dolist (shar data-shared)       
      (setf results-shared (append results-shared (test-no-subsample (funcall shar) times))))
    (dolist (ar data-ar)
      (setf results-ar (append results-ar (test-no-subsample (xindex (funcall ar)) times))))
    (write-stats-2  "shared-test-n-no-subsample.csv" (format nil "~a" results-shared))
    (write-stats-2  "ar-test-n-no-subsample.csv" (format nil "~a" results-ar))))
    

(defun test-no-subsample (train &optional (times 10))
  (let* ((ns '(2 4 8 10 12))
         (results))
    (dotimes (i times results)
      (dolist (n ns)
        (let ((tmp))
          (setf tmp (list 'infogain-nb 'infogain n 'None)) ;test infogain-nb
          (setf results (append results (prepare-inst tmp (infogain-nb train n))))
          (setf tmp (list 'bsquare-nb 'bsquare n 'None)) ;test bsquare-nb
          (setf results (append results (prepare-inst tmp (bsquare-nb train n))))
          (setf tmp (list 'infogain-prism 'infogain n 'None)) ;test infogain-prism
          (setf results (append results (prepare-inst tmp (infogain-prism train n))))
          (setf tmp (list 'bsquare-prism 'bsquare n 'None)) ;test bsquare-prism
          (setf results (append results (prepare-inst tmp (bsquare-prism train n)))))))))
       


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

;utility function to print
(defun prepare-inst (param abcd)
  (let* ((true-lst (list (append param (car abcd))))
        (false-lst (list (append param (car (cdr abcd)))))
        (result))
    (setf result (append true-lst false-lst))))
