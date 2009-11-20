(defparameter shared-lst (list (xindex (shared_pc1)) (xindex (shared_pc1))
			       (xindex (shared_kc2)) (xindex (shared_kc3))
			       (xindex (shared_cm1)) (xindex (shared_mw1))
			       (xindex (shared_mc2))))
(defparameter prepared-data '())

(defun merge-data (&optional (nr-attributes 5))
  (let* ((sh_pc1 (xindex (shared_pc1)))
	 (sh_kc1 (xindex (shared_kc1)))
	 (sh_kc2 (xindex (shared_kc2)))
	 (sh_kc3 (xindex (shared_kc3)))
	 (sh_cm1 (xindex (shared_cm1)))
	 (sh_mw1 (xindex (shared_mw1)))
	 (sh_mc2 (xindex (shared_mc2)))
	 (lst (list sh_pc1 sh_kc1 sh_kc2 sh_kc3 sh_cm1 sh_mw1 sh_mc2))
	 (all-tbl (xindex (append-tables lst))))
   (score-tbl-bsquare all-tbl nr-attributes)))


(defun prepare-datasets-bsquare (&optional (num-attrs))
  (let* ((lst-out)
	 (indexes (merge-data num-attrs)))
  (dolist (l shared-lst lst-out)
    (setf lst-out (append lst-out (list (xindex  (make-bsquare-table l indexes))))))))

(defun make-bsquare-table (tbl indexes)
  (bsquare-table tbl indexes))

(defun randomize (lst &optional (b 5))
  (let* ((all-tbl))
    (dolist (l lst all-tbl)
      (setf all-tbl (append all-tbl (split2bin-tables l b))))))

(defun k-means-all-tables (lst &optional (k 2))
  (let ((all-tables))
    (dolist (tbl lst all-tables)
      (let ((lst-clusters (k-means tbl k))) 
       (setf all-tables  (append all-tables (list (car (sort lst-clusters #'> :key #'length)))))))
       (make-cluster-tables all-tables (car lst))))

(defun build-datas (&optional (ks) (bins 5) (num-attrs 5))
  (let* ((all-tables))
    (dolist (k ks all-tables)
      (setf all-tables (append all-tables 
			       (k-means-all-tables 
				(randomize 
				 (prepare-datasets-bsquare num-attrs) bins) k))))))

(defun set-data ()
  (setf prepared-data (build-datas '(2 4 6 8 10))))


