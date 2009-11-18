(defparameter shared-lst (list (xindex (shared_pc1)) (xindex (shared_pc1))
			       (xindex (shared_kc2)) (xindex (shared_kc3))
			       (xindex (shared_cm1)) (xindex (shared_mw1))
			       (xindex (shared_mc2))))

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



(defun prepare-datasets-bsquare ()
  (let* ((lst-out)
	 (indexes (merge-data)))
  (dolist (l shared-lst lst-out)
    (setf lst-out (append lst-out (list (discretize (xindex  (make-bsquare-table l indexes)))))))))

(defun make-bsquare-table (tbl indexes)
  (bsquare-table tbl indexes))

	 
	 
