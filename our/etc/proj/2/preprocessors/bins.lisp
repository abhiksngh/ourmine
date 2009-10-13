; make sure classes are distributed properly, instances are placed evenly
(deftest test-bins ()
    (check
        (multiple-value-bind (train-bins test-bins)
                              (bins (make-bin-data))
            (let* ((bin0 (features-as-a-list (first train-bins))))
                (and (equal (last (first bin0)) '(YES))
                     (equal (last (second bin0)) '(NO))
                     (equal (length bin0) 2)
                )
            )
        )
    )
)

; splits a data-set into 10 bins, and preserves class distribution in
; bins.  Then builds a test-set from 10% of the data, and train-set from
; the remaining 90%
(defun bins (data)
    (let* ((n-instances (negs data))
           (test-set)  
           (train-set)

           ; sort the instances of the table by class value
           (classes (table-all (sort-table data))) 
           (per-bin (ceiling (/ n-instances 10))) ; # of instances per bin

           ; fill the bins with the instances evenly 
           (filled-bins (fill-bins classes 10 per-bin)))
       
       ; create train/test data sets out of each bin
       (return-bins data filled-bins per-bin)
    )
)

; creates a 2d array and fills it with instances
(defun fill-bins (instances nbins per-bin)
    (let* ((bin-matrix (make-array (list per-bin nbins) :initial-element nil))
           (col-num 0)
           (row-num 0))

        ; for each instance in the list (which has been sorted by class)
        (dolist (instance instances)
                ; write the instance to the bin
                (setf (aref bin-matrix row-num col-num) instance)
                 
                ; move to the next column
                (incf col-num)

                ; hop back to the first column and down a row
                (when (= col-num nbins)
                    (setf col-num 0)
                    (incf row-num)
                )
        )
        bin-matrix ; return the 2d array
    )
)

; builds a test-set and train-set from the passed bin-matrix
; 90% of the data is used for training, 10% for testing
(defun build-data-set (filled-bins bin-num max-per test)
    (let ((eg-set) 
          (per-bin 0)
          (start 0) 
          (end))

        ; find the number of instances in the bin
        (loop for i from 1 to max-per
            do
                (when (aref filled-bins per-bin bin-num) 
                    (incf per-bin)
                )
        )
        
        ; if testing, use first 10% of data
        (setf end (floor (/ per-bin 10)))

        ; if not testing, use remaining 90%
        (when (not test)
            (setf start end)
            (setf end (- per-bin 1))
        )

        ; push the instances onto a list
        (loop for row from start to end
            do
                (push (eg-features (aref filled-bins row bin-num)) eg-set)
        )
        eg-set
    )
)

; create train/test data sets for each bin 
(defun return-bins (data-set filled-bins per-bin)
        (values 
     
           (list (data :name 'bin0-train
                  :columns (columns-header (table-columns data-set))
                  :egs (build-data-set filled-bins 0 per-bin nil)
            )
 
            (data :name 'bin1-train
                  :columns (columns-header (table-columns data-set))
                  :egs (build-data-set filled-bins 1 per-bin nil)
            )

            (data :name 'bin2-train
                  :columns (columns-header (table-columns data-set))
                  :egs (build-data-set filled-bins 2 per-bin nil)
            )

            (data :name 'bin3-train
                  :columns (columns-header (table-columns data-set))
                  :egs (build-data-set filled-bins 3 per-bin nil)
            )

            (data :name 'bin4-train
                  :columns (columns-header (table-columns data-set))
                  :egs (build-data-set filled-bins 4 per-bin nil)
            )

            (data :name 'bin5-train
                  :columns (columns-header (table-columns data-set))
                  :egs (build-data-set filled-bins 5 per-bin nil)
            )

            (data :name 'bin6-train
                  :columns (columns-header (table-columns data-set))
                  :egs (build-data-set filled-bins 6 per-bin nil)
            )

            (data :name 'bin7-train
                  :columns (columns-header (table-columns data-set))
                  :egs (build-data-set filled-bins 7 per-bin nil)
            )

            (data :name 'bin8-train
                  :columns (columns-header (table-columns data-set))
                  :egs (build-data-set filled-bins 8 per-bin nil)
            )

           (data :name 'bin9-train
                  :columns (columns-header (table-columns data-set))
                  :egs (build-data-set filled-bins 9 per-bin nil)
            ))
            
          (list  (data :name 'bin0-test 
                  :columns (columns-header (table-columns data-set))
                  :egs (build-data-set filled-bins 0 per-bin t)
            )

            (data :name 'bin1-test
                  :columns (columns-header (table-columns data-set))
                  :egs (build-data-set filled-bins 1 per-bin t)
            )

            (data :name 'bin2-test
                  :columns (columns-header (table-columns data-set))
                  :egs (build-data-set filled-bins 2 per-bin t)
            )

            (data :name 'bin3-test
                  :columns (columns-header (table-columns data-set))
                  :egs (build-data-set filled-bins 3 per-bin t)
            )

            (data :name 'bin4-test
                  :columns (columns-header (table-columns data-set))
                  :egs (build-data-set filled-bins 4 per-bin t)
            )

            (data :name 'bin5-test
                  :columns (columns-header (table-columns data-set))
                  :egs (build-data-set filled-bins 5 per-bin t)
            )

            (data :name 'bin6-test
                  :columns (columns-header (table-columns data-set))
                  :egs (build-data-set filled-bins 6 per-bin t)
            )

            (data :name 'bin7-test
                  :columns (columns-header (table-columns data-set))
                  :egs (build-data-set filled-bins 7 per-bin t)
            )

            (data :name 'bin8-test
                  :columns (columns-header (table-columns data-set))
                  :egs (build-data-set filled-bins 8 per-bin t)
            )

            (data :name 'bin9-test
                  :columns (columns-header (table-columns data-set))
                  :egs (build-data-set filled-bins 9 per-bin t)
            ))
 
        )
)

