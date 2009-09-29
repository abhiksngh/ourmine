(defun learn (&key (k 8)
                   (cluster   #'(lambda (data) (k-means data k))))

  (let* ((train (make-data-k))
         (clusters (funcall cluster train))
         (cluster-tables '())
         (cluster-nr 1))
    (dolist (obj clusters cluster-tables)
      (setf cluster-tables (cons cluster-tables
                                 (data :name cluster-nr :columns (get-col-names (table-columns train)) :egs obj)))
      (setf cluster-nr (incf cluster-nr)))))



(defun get-col-names (lst)
  (let* ((lst-cols))
  (dolist (obj lst (reverse lst-cols))
    (setf lst-cols (cons (header-name obj) lst-cols)))))
              
