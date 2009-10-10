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

(defun test-no-disc-centroid-nb (train &optional (assoc 0))
  (let* ((copy (make-simple-table (table-name train) (table-columns train) (table-egs-to-lists train)))) 
    (no-disc-centroid-nb (log-data1 copy) assoc)))

(defun disc-centroid-nb (train &optional (assoc 0))
  "discretize data and apply naive bayes on centroids"
  (let* ((train (discretize train)))
    (test-no-disc-centroid-nb train assoc)))

(defun no-disc-centroid-nb (train &optional (assoc 0) &key (stream t))
  (let* ((acc 0)
         (gotwant_assoc '())
         (max (length (table-all train)))
         (class (table-class train))
         (lst (split2bins train))
         (train (xindex (car lst)))
         (clusters (k-means train))
         (cluster-tables (make-cluster-tables clusters train))
         (cls-means (get-cls-means cluster-tables))
         (test (xindex (car (cdr lst)))))
    (dolist (test_inst (get-features (table-all test)))
      (let* ((closest-cent (get-closest-centroid test_inst cls-means))
             (closest-cluster (nth closest-cent cluster-tables))
             (want (nth class test_inst))
             (got (bayes-classify-num test_inst  (xindex closest-cluster)))
             (success (equal got want)))
        (incf acc (if success 1.00 0.00))
        (if (= assoc 0)
            (format stream "~A ~A ~A ~A~%"  got want
                (round (* 100 (/ acc max)))
                (if success "    " "<- - -")))
        (setf gotwant_assoc (acons got want gotwant_assoc))))
    (if (= assoc 0)
        (/ acc max)
        (list gotwant_assoc (/ acc max)))))

(defun disc-infogain-centroid-nb (train n &optional (assoc 0) &key (stream t))
    (let* ((acc 0)
           (gotwant_assoc '())
           (max (length (table-all train)))
           (class (table-class train))
           (lst (split2bins train))
           (train (xindex (car lst)))
           (clusters (k-means train))
           (cluster-tables (make-cluster-tables clusters train))
           (cls-means (get-cls-means cluster-tables))
           (test (xindex (car (cdr lst)))))
      (dolist (one cluster-tables)
          ;(format t "~A~%"  cls-means)
          ;(format t "~A~%" one)
          ;(return-from disc-infogain-centroid-nb)))))
          (infogain-table (xindex one) n))))
          ;(return-from disc-infogain-centroid-nb)))))
        
(defun debug-cls (train)
  (let* ((cluster-table (make-cluster-tables (k-means train) train)))
    (format t "~A~%" (length cluster-table))
      ;(format t "~A~%" (car cluster-table))
      (format t "~A~%" (get-features (table-all (discretize (car cluster-table)))))
      (rank-via-infogain (get-features (table-all (discretize (car cluster-table)))))))

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
  (let* ((cluster-tables '())
         (cluster-nr 1))
    (dolist (obj clusters)
      (setf cluster-tables (append cluster-tables
                                   (list (data :name cluster-nr :columns (get-col-names (table-columns train)) :egs obj))))
      (setf cluster-nr (incf cluster-nr)))
    (del-empty-clusters cluster-tables)))



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
                 
    
