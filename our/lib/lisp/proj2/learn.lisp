(defun learn (&key (k 8)
              (cluster   #'(lambda (data) (k-means data k))))

  (let* ((train (make-data-k))
         (clusters (funcall cluster train))
         (cluster-tables '())
         (lst-centroids '()))
    (setf cluster-tables (make-cluster-tables clusters train))
    (setf lst-centroids (get-cls-means cluster-tables))
    (values cluster-tables lst-centroids)))


(defun no-disc-nb (train)
  "split into 10 bins and apply naive bayes"
  (let* ((lst (split2bins train))
         (train (xindex (car lst)))
         (test (xindex (car (cdr lst)))))
            ;(format t "~A~%"  train)
            ;(format t "~A~%" test)
   (nb-num train test)))

;;testing: No Discretization on the data. Naive Bayes learner
(defun test-no-disc-centroid-nb (train &key (times 1))
  (let* ((results))
    (dotimes (i times results)
      (let* ((copy (make-simple-table (table-name train) (table-columns train) (table-egs-to-lists train)))) 
        (setf results (append results (list (no-disc-centroid-nb (log-data1 copy)))))))))

;;testing: Discretizing the data. Naive Bayes learner
(defun test-disc-infogain-centroid-nb (train n &key (times 1))
  (let* ((results))
    (dotimes (i times results)
      (let* ((copy (make-simple-table (table-name train) (table-columns train) (table-egs-to-lists train)))) 
        (setf results (append results (list (disc-infogain-centroid-nb (log-data1 copy) n))))))))

(defun disc-centroid-nb (train &optional (assoc 0))
  "discretize data and apply naive bayes on centroids"
  (let* ((train (discretize train)))
    (test-no-disc-centroid-nb train assoc)))


;;applying only clustering and naive bayes
(defun no-disc-centroid-nb (train)
  (let* ((class (table-class train))
         (lst (split2bins train))
         (train (xindex (car (cdr lst))))
         (test (xindex (car lst)))
         (clusters (k-means train))
         (cluster-tables (make-cluster-tables clusters train))
         (cls-means (get-cls-means cluster-tables))
         (gotwants))
    (dolist (test_inst (get-features (table-all test)))
      (let* ((closest-cent (get-closest-centroid test_inst cls-means))
             (closest-cluster (nth closest-cent cluster-tables))
             (want (nth class test_inst))
             (got (bayes-classify-num test_inst  (xindex closest-cluster))))
        (setf want (list want))
        (setf gotwants (append gotwants (list (append want got))))))
    (abcd-stats gotwants :verbose nil)))
    ;(format t "~a~%" (abcd-stats gotwants :verbose nil))))
 
; infogain on dataset, cluster original dataset (infogain's best columns only) and apply naive bayes
(defun disc-infogain-centroid-nb(train n)
  (let* ((best-cols (extract-best-cols (infogain (table-egs-to-lists train)) (table-egs-to-lists train) n))
         (train-cols (table-columns train))
         (numcols (length train-cols))
         (all (table-egs-to-lists train))
         (newdata)
         (newtable)
         (temp)
         (newcols '()))
    (dolist (col best-cols)
      (setf newcols (cons (nth col train-cols) newcols)))
    (setf newdata (get-wanted-cols train best-cols))
    (setf newtable (make-desc-table (table-name train) newcols newdata))
    (no-disc-centroid-nb newtable)))

         
(defun get-wanted-cols (train wanted)
  (let* ((all (table-egs-to-lists train))
         (n (length (table-columns train)))
         (temp)
         (newdata))
    (dolist (inst all (reverse newdata))
      (dolist (col wanted)
        (setf temp (append (list (nth col inst)) temp)))
      (setf newdata (append (list (reverse temp)) newdata))
      (setf temp '()))))


;;discretizing the data and applying info gain
(defun disc-infogain-nb (train n)
    (let* ((info-data (xindex (infogain-table (discretize train) n)))
           (class (table-class info-data))
           (lst (split2bins info-data))
           (test (xindex (car lst)))
           (train (xindex (car (cdr lst))))
           (gotwants))
       (dolist (test_inst (get-features (table-all test)))
         (let* ((want (nth class test_inst))
                (got (bayes-classify-num  test_inst train)))
                (setf want (list want))
                (setf gotwants (append gotwants (list (append want got))))))
       (abcd-stats gotwants :verbose nil)))
         ;(format t "~a~%" (abcd-stats gotwants :verbose nil))))
            
        
(defun debug-cls (train)
  (let* ((acc 0)
         (clusters (k-means train))
         (tabs (make-cluster-tables clusters train))
         (inst '(36 9 5 5 618.64 0.08 12 51.55 7423.67 0.21 412.43 28 6 8 16 30 67 45 17 FALSE))
         (closest-cent (get-closest-centroid inst
                            (get-cls-means tabs))))
    (dolist (obj tabs tabs)
      (setf acc (+ acc (length (table-all obj)))))
      (format t "~A~%" (length tabs))
      (format t "~A~%" closest-cent)
      (format t "~A~%" (position inst (get-features (table-all (nth closest-cent tabs))) :test #'equal))
      (nth closest-cent tabs)))
      
(defun disc-nb (train)
  "discretize and apply naive bayes"
  (no-disc-nb (discretize train)))

(setf lst '((9 7 0 0 7 9 1 8 4 7 4 9 0 0 0 2 9 9 7 FALSE)
            (0 0 0 0 5 9 0 23 0 5 0 0 3 0 4 8 4 6 0 TRUE)
            (6 2 1 1 3 9 2 5 2 3 2 6 9 0 4 4 4 4 2 TRUE)
            (0 0 0 0 0 9 2 3 0 0 0 0 5 0 3 1 0 2 0 FALSE)
            (3 0 0 0 7 9 2 7 5 7 5 3 7 0 3 4 8 7 0 TRUE)
            (5 7 9 7 6 9 2 7 5 6 5 4 0 9 4 6 7 6 7 FALSE)
            (2 3 3 1 0 0 23 0 23 0 23 1 0 6 9 0 1 1 2 FALSE)
            (0 7 5 3 0 0 4 2 1 0 1 0 0 0 6 0 3 0 7 FALSE)
            (5 9 3 9 9 9 2 9 8 23 8 5 0 4 5 9 9 9 9 FALSE)))
         
      
                     
(defun make-cluster-tables (clusters train)
  (let* ((cluster-tables)
         (len (length (table-columns train)))
         (cls (remove-centroid clusters len))
         (cluster-nr 1))
    (dolist (obj cls)
      (setf cluster-tables (append cluster-tables
                                   (list (data :name cluster-nr :columns (get-col-names (table-columns train)) :egs obj))))
      (setf cluster-nr (incf cluster-nr)))
    (del-empty-clusters cluster-tables)))

(defun remove-centroid (clusters len)
  (let* ((new-clusters))
    (dolist (cls clusters new-clusters)
      (dolist (inst cls)
        (if (not (equal (length inst) len))
            (setf new-clusters (append new-clusters (list (remove inst cls)))))))))
        
        



(defun get-col-names (lst)
  (let* ((lst-cols))
  (dolist (obj lst (reverse lst-cols))
    (setf lst-cols (cons (header-name obj) lst-cols)))))


(defun get-cls-means(cluster-tables)
  (let* ((centroids '()))
   (dolist (obj cluster-tables centroids)
     (let* ((features (get-features (table-all obj)))
            (class (table-class obj)))
       (setf centroids (append centroids (list (cluster-mean features class))))))))

(defun del-empty-clusters (cluster-tables)
  (dolist (obj cluster-tables cluster-tables)
    (if (not (table-all obj))
        (setf cluster-tables (remove obj cluster-tables)))))

(defun get-closest-centroid (one lstCentroids)
  (let ((dist most-positive-fixnum)
        (position))
    (dolist (obj lstCentroids position)
      (if ( <= (euc one obj) dist)
          (progn (setf dist (euc one obj))
                 (setf position (position obj lstCentroids :test #'equal)))))))
                 
    
