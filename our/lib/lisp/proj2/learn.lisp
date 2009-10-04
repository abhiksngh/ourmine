(defun learn (&key (k 8)
              (cluster   #'(lambda (data) (k-means data k))))

  (let* ((train (make-data-k))
         (clusters (funcall cluster train))
         (cluster-tables '()))
    
    (setf cluster-tables (make-cluster-tables clusters train))))




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


;(defun get-cls-means(cluster-tables)
;  (let* ((centroids '()))
 ;   (dolist (obj cluster-tables centroids)
  ;    (let* ((features (get-features (table-all obj)))
   ;          (class (table-class obj)))
    ;    (setf centroids (append (cluster-mean features class) centroids))))))

(defun del-empty-clusters (cluster-tables)
  (dolist (obj cluster-tables cluster-tables)
    (if (not (table-all obj))
        (setf cluster-tables (remove obj cluster-tables)))))
