(defun extract-best-cols (attranks dataset n)
  (let ((used)
	(orig)
	(keepcols)
	(current 0)
        (classindx (- (length (car dataset)) 1)))
    (setf orig (copy-list attranks)) 
    (setf attranks (sort attranks #'>))
    (dolist (sortedrank attranks)
      (setf current 0)
      (dolist (rank orig)
	(if (and (equal sortedrank rank)
		 (not (contains used rank)))		
	    (progn ()
		   (setf used (append used (list rank)))
		   (setf keepcols (append keepcols (list current)))))
	(incf current))
      (cond ((> (length keepcols) (- n 1))
            (setf keepcols (append keepcols (list classindx)))
            (return-from extract-best-cols (sort keepcols #'<)))))))
	


(defun prune-cols (colnums data)
  (let ((pruned)
	(tmp))
    (dolist (row data pruned)
      (setf tmp '())
      (dolist (col colnums)
	(setf tmp (append tmp (list (nth col row)))))
      (setf pruned (append pruned (list tmp))))))

;;works on lists
(defun rank-via-infogain (dataset &optional (n (/ (length (car dataset)) 2)))
  (let* ((scores (infogain dataset))
        (colnums (extract-best-cols scores dataset n))
        (result (prune-cols colnums dataset)))
    (values colnums result)))

;;on tables
(defun infogain-table (table n)
  (multiple-value-bind (colnums insts)
      (rank-via-infogain (table-egs-to-lists table) n)
    (let ((cols))
      (dolist (col colnums)
        (setf cols (append cols (list (nth col (table-columns table))))))
      (make-desc-table 'infogain-res-table cols insts))))
    
    


