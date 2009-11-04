;write results to file
(defun write-stats-2 (filename str)
  (let (st)
  (setf st (open (make-pathname :name filename) :direction :output
                            :if-exists :supersede))
  (format st str)
  (close st)))

;running the stimulation for n -- all datasets
(defun test-all-no-subsample (&optional (times 10))
  (let* ((data-shared '(shared_pc1 shared_cm1 shared_kc1 shared_kc2 shared_kc3 shared_mc2 shared_mw1))
         (data-ar '(ar3 ar4 ar5))
         (results-shared)
         (results-ar))
    (dolist (shar data-shared)
      (format t "~a~%" shar)
      (setf results-shared (append results-shared (test-no-subsample (funcall shar) times))))
    (dolist (ar data-ar)
      (format t "~a~%" ar)
      (setf results-ar (append results-ar (test-no-subsample (xindex (funcall ar)) times))))
    (write-stats-2  "shared-combined.csv" (format nil "~a" results-shared))
    (write-stats-2  "ar-combined.csv" (format nil "~a" results-ar))))
    
;running the stimulation for n -- all n / each dataset
(defun test-no-subsample (train &optional (times 10))
  (let* ((preprocess)
         (ns '(2 4 8 10 12))
         (results)
         (ts)
         (tr))
    (multiple-value-bind (tst trn) (make-k-train-test train)
      (setf ts tst)
      (setf tr trn))
    (setf preprocess (make-knn-data tr ts))
    (dotimes (i times results)
      (dolist (n ns)
        (let ((tmp))
          (setf tmp (list 'infogain-nb 'infogain n 'Knn)) ;test infogain-nb
          (setf results (append results (prepare-inst tmp (infogain-nb preprocess n))))
          (setf tmp (list 'bsquare-nb 'bsquare n 'Knn)) ;test bsquare-nb
          (setf results (append results (prepare-inst tmp (bsquare-nb preprocess n))))
          (setf tmp (list 'infogain-prism 'infogain n 'Knn)) ;test infogain-prism
          (setf results (append results (prepare-inst tmp (infogain-prism preprocess n))))
          (setf tmp (list 'bsquare-prism 'bsquare n 'Knn)) ;test bsquare-prism
          (setf results (append results (prepare-inst tmp (bsquare-prism preprocess n)))))))))
       


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
         (lst (split2bin-tables train))
         ;(train (xindex (car (cdr lst))))
         ;(test (xindex (car lst)))
         (gotwants))
   (dotimes (i  (- (length lst) 1))
     (let* ((test (xindex (nth i lst)))
            (train-lst)
            (tr))
       (dotimes (j (- (length lst) 1))
         (if (not (= j i))
             (setf train-lst (append train-lst (list (nth j lst))))))
       (setf tr (append-tables train-lst))
     (dolist (test_inst (get-features (table-all test)))
       (let* ((want (nth class test_inst))
              (got (funcall fun test_inst tr)))
         (setf want (list want))
         (setf gotwants (append gotwants (list (append want got))))))))
    (split (abcd-stats gotwants :verbose nil))))

;utility function to print
(defun prepare-inst (param abcd)
  (let* ((true-lst (list (append param (car abcd))))
        (false-lst (list (append param (car (cdr abcd)))))
        (result))
    (setf result (append true-lst false-lst))))

(defun append-tables(lst)
  (let* ((col (table-columns (car lst)))
         (inst))
    (dolist (l lst)
      (setf inst (append inst (get-features (table-all l)))))
    (xindex (make-simple-table 'train col inst))))
      

(defun make-k-train-test (train)
  (let* ((lst (split2bins train)))
    (values (car lst) (car (cdr lst)))))



    
