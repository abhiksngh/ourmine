(defparameter shared-lst (list (xindex (shared_pc1)) (xindex (shared_pc1))
			       (xindex (shared_kc2)) (xindex (shared_kc3))
			       (xindex (shared_cm1)) (xindex (shared_mw1))
			       (xindex (shared_mc2))))
(defparameter prepared-data '())


(defun remove-falses(train)
  (let* ((data (table-egs-to-lists train))
         (temp)
         (truths '())
         (class-col (table-class train)))
    (dotimes (n (length data) (make-simple-table (table-name train) (table-columns train) truths))
      (setf temp (nth n data))
      (if (eq (nth class-col temp) 'true)
          (setf truths (append (list temp) truths))))))


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

(defun build-new-bp (bp atable current-rules)
  (let* ((x 0))
    (setf current-rules (get-rules-for-true current-rules))
    (if (not (score-rules (car bp) current-rules))
	(let* ((table-lst (list atable (cadr bp)))
	       (newtable (append-tables table-lst))
	       (newbp (list (get-rules-for-true (prism newtable)) newtable)))
	  (if (not (score-rules (car newbp) current-rules))
	      (return-from build-new-bp (list (get-rules-for-true current-rules) atable))
	      (return-from build-new-bp newbp)))
	(return-from build-new-bp bp))))
	
		   
	      
	  
    
