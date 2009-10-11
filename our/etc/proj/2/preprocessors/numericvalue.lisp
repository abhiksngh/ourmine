; establishes a minimum value for numeric data entires and performs a 
; log on all numeric data in the table.  Returns the processed table
(defun numval1 (data)
  (let* (eg-set
	 (header (table-columns data))
	 (all-instances (table-all data)))
    (dolist (per-instance all-instances) ; for every instance
      (push (mapcar #'numval2 
		    header
		    (eg-features per-instance))
	    eg-set))
    (data :name 'log-set
	  :columns (columns-header (table-columns data))
	  :egs eg-set)))

(defmethod numval2 ((header numeric) feature)
  (declare (ignore header))
  (log (max feature 0.00001)))

(defmethod numval2 ((header discrete) feature)
    (declare (ignore header))
    feature)

