(defun no-disc-nb (train)
  "split into 10 bins and apply naive bayes"
  (let* ((lst (split2bins train))
         (train (xindex (car lst)))
         (test (xindex (car (cdr lst)))))
            ;(format t "~A~%"  train)
            ;(format t "~A~%" test)
   (nb-num train test)))

(defun write-stats (filename str)
  (setf st (open (make-pathname :name filename) :direction :output
                            :if-exists :supersede))
  (format st str)
  (close st))

(defun test-all (train &optional (times 1) (k 1) (n 5))
  (let* (disc-nb disc-info disc-info-nb)
    (setf disc-nb (test-no-disc-centroid-nb train times k))
    (write-stats "no-disc-nb-cluster" (format nil "~a" disc-nb))  
    (setf disc-info (test-disc-infogain-centroid-nb train n times))
    (write-stats "disc-info-cluster" (format nil "~a" disc-info))
    (setf disc-info-nb (test-disc-infogain-nb train times n))
    (write-stats "disc-info-nb" (format nil "~a" disc-info-nb))))
    
   ;(format t "No Disc, Cluster (k=~A), Nb ~A~%" k (median disc-nb 4))
   ; (format t "Disc, Infogain (n=~A), Cluster (k=~A), Nb ~A~%" n k (median disc-info 3))))
   ;(format t "Disc, Infogain (n=~A), No Clustering, Nb ~A~%" n (median disc-info-nb 3))))
;;testing: No Discretization on the data. Naive Bayes learner
(defun test-no-disc-centroid-nb (train &optional (times 1) (k 1))
  (let* ((results))
    (dotimes (i times (blowup-bins results))
      (let* ((copy (make-simple-table (table-name train) (table-columns train) (table-egs-to-lists train)))) 
        (setf results (append results (list (no-disc-centroid-nb (log-data1 copy) k))))))))

;;testing infogain
(defun test-disc-infogain-nb (train &optional (times 1)(n 5))
  (let* ((results))
    (dotimes (i times (blowup-bins results))
      (let* ((copy (make-simple-table (table-name train) (table-columns train) (table-egs-to-lists train)))) 
        (setf results (append results (list (disc-infogain-nb (log-data1 copy) n))))))))

;;testing: Discretizing the data. Naive Bayes learner
(defun test-disc-infogain-centroid-nb (train n &optional (times 1))
  (let* ((results))
    (dotimes (i times (blowup-bins results))
      (let* ((copy (make-simple-table (table-name train) (table-columns train) (table-egs-to-lists train)))) 
        (setf results (append results (list (disc-infogain-centroid-nb (log-data1 copy) n))))))))


;;applying only clustering and naive bayes
(defun no-disc-centroid-nb (train &optional (k 1))
  (let* ((class (table-class train))
         (lst (split2bins train))
         (train (xindex (car (cdr lst))))
         (test (xindex (car lst)))
         (clusters (k-means train k))
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
   (split (abcd-stats gotwants :verbose nil))))
    ;(format t "~a~%" (abcd-stats gotwants :verbose nil))))
 
; infogain on dataset, cluster original dataset (infogain's best columns only) and apply naive bayes
(defun disc-infogain-centroid-nb(train n)
  (let* ((best-cols (extract-best-cols (infogain (table-egs-to-lists train)) (table-egs-to-lists train) n))
         (train-cols (table-columns train))
         (newdata)
         (newtable)
         (newcols '()))
    (dolist (col best-cols)
      (setf newcols (cons (nth col train-cols) newcols)))
    (setf newdata (get-wanted-cols train best-cols))
    (setf newtable (make-desc-table (table-name train) newcols newdata))
    (no-disc-centroid-nb newtable)))

(defun split (lst)
  (let ((out))
    (setf out (append out (list (list (car lst)))))
    (setf out (append (list (cdr lst)) out))))
   
(defun get-wanted-cols (train wanted)
  (let* ((all (table-egs-to-lists train))
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
      (split  (abcd-stats gotwants :verbose nil))))
         ;(format t "~a~%" (abcd-stats gotwants :verbose nil))))
            
        

      
(defun disc-nb (train)
  "discretize and apply naive bayes"
  (no-disc-nb (discretize train)))

      
                     
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
                 
    
