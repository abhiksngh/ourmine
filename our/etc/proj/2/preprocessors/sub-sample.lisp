; row reduction, defaults to subsampling
; if a "micro" value is supplied, microsampling is used
(defun sub-sample (data empty &optional micro)
    (let* ((sorted-data (sort-table data))
           (all-instances (table-all sorted-data))
           (sampled-data)
           (curr)
           (least most-positive-fixnum) 
           (class-count 0)
           (prev (last (eg-features (nth 0 (table-all (xindex sorted-data)))))))

    (if (>= (negs data) 10)
        (progn 
            ; find the class that occurs least frequently and record its count
            (doitems (per-instance i all-instances)
                (setf curr (last (eg-features (nth i (table-all sorted-data)))))
                (if (equal prev curr) 
                    (incf class-count)
                    (progn 
                        (setf least (min class-count least))
                        (setf class-count 1)
                    )
                )
                (setf prev curr)
            )
            (setf least (min class-count least)) ; the least count

           (when micro
               (setf least (max least micro)))
          

        ; copy no more than "least" of each class to a new table
        (doitems (per-instance i all-instances)
            (setf curr (last (eg-features (nth i (table-all sorted-data)))))
            (if (equal prev curr)
                (incf class-count)
                (setf class-count 1))
            (setf prev curr)
            (when (<= class-count least)
                (push (eg-features per-instance) sampled-data)
            )
        )
        (data :name 'sub-sampled-data
          :columns (columns-header (table-columns data))
          :egs sampled-data))
    data
    ))
)

(deftest test-sub-sampling ()
    (check
        (let* ((tbl (make-data))
               (sub-tbl (sub-sample tbl))
               (egs (table-all (xindex sub-tbl))))
            (and (equal (length egs) 4)
                 (equal (last (eg-features (nth 0 egs))) '(NO))
                 (equal (last (eg-features (nth 1 egs))) '(NO))
                 (equal (last (eg-features (nth 2 egs))) '(YES))
                 (equal (last (eg-features (nth 3 egs))) '(YES)))
        )
    )
)

