(defun do-over-features (tbl func)
	(dolist (item (table-all tbl)) 
		(setf (eg-features item) (mapcar func (eg-features item)))))

(defun gimme-classes (tbl)
	(mapcar #'eg-class (table-all tbl)))
