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
    (data :name (format nil "~A_~A" (table-name data) "log-set")
	  :columns (columns-header (table-columns data))
	  :egs eg-set)))

(defmethod numval2 ((header numeric) feature)
  (declare (ignore header))
  (log (max feature 0.00001) 10))

(defmethod numval2 ((header discrete) feature)
    (declare (ignore header))
    feature)


; makes sure discretes are preserved, <.00001 vals get set to 0.00001
; and numerics are logged properly
(deftest test-numval ()
    (check
        (let* ((tbl (make-data))
               (numval-tbl (numval1 tbl))
               (egs (table-all (xindex numval-tbl))))
            (and 
                 (equal (last (eg-features (nth 0 egs))) '(NO)) 
                 (equal (second (eg-features (nth 1 egs))) '-5.0)
                 (equal (second (eg-features (nth 2 egs))) '0.0))
        )                          
    )
)


