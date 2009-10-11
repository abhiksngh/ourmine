(defun b-squared (data)
    (let* ((scored-data (score-data data))
           (sorted-data (sort-table scored-data))
           (instance-count (negs data)))
        (multiple-value-bind (b r) (chop-data sorted-data instance-count)
            b
            r
        ) 
            
    )
)

(defun chop-data (data num-vals)
    (let ((bin-size (floor (* .2 num-vals)))
          (all-instances (table-all data))
          (best-bin)
          (rest-bin))
        (doitems (per-instance i all-instances)
            (if (< i bin-size)
                (push (eg-features per-instance) best-bin)
                (push (eg-features per-instance) rest-bin)
            )
        )
        (values 
            (data :name 'best-set
                :columns (columns-header (table-columns data))
                :egs best-bin
            )
            (data :name 'rest-set
                :columns (columns-header (table-columns data))
                :egs rest-bin
            )
        )
    )
)

(defun score-data (data) 
    (let* ((header (table-columns data))
           (all-instances (table-all data))
           (classi (table-class data))
           eg-set)

        (dolist (per-instance all-instances)
            (push (score-class per-instance header classi) eg-set)
        )
        (data :name 'class-set
          :columns (columns-header (table-columns data))
          :egs eg-set
        )
    )
)
(defun score-class (per-instance header classi)
    (let ((all-features (eg-features per-instance)))
        (setf (nth classi all-features) (numval3 (nth classi header) (nth classi all-features)))
        all-features
    )
)

(defmethod numval3 ((header numeric) class-val)
    (declare (ignore header))
    '5
)

(defmethod numval3 ((header discrete) class-val)
    (declare (ignore header))
    '10
)
