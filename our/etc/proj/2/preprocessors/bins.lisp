(deftest test-bins ()
    (multiple-value-bind (b0-test b0-train
                          b1-test b1-train
                          b2-test b2-train
                          b3-test b3-train
                          b4-test b4-train
                          b5-test b5-train
                          b6-test b6-train
                          b7-test b7-train
                          b8-test b8-train
                          b9-test b9-train)
                          (bins (ar3))
    )
)

; splits a data-set into 10 bins, and preserves class distribution in
; bins.  Then builds a test-set from 10% of the data, and train-set from
; the remaining 90%
(defun bins (data-set &optional (nbins 10))
    (let* ((n-instances (negs data-set))
           (test-set)  
           (train-set)
           (classes (table-all (sort-table data-set))) ; sorted data-set by class
           (per-bin (ceiling (/ n-instances nbins))) ; # of instances per bin
           (filled-bins (fill-bins classes nbins per-bin)))
       (return-bins data-set filled-bins per-bin)
    )
)

; fills a 2 dimensional matrix with the passed instances.  The matrix has n
; columns, where n is the number of desired bins. The instances are 
; distributed evenly amongst the bins  
(defun fill-bins (instances nbins per-bin)
    (let* ((bin-matrix (make-array (list per-bin nbins) :initial-element nil))
           (col-num 0)
           (row-num 0))

        ; for each instance in the list (which has been sorted by class)
        (dolist (instance instances)
                ; write the instance to the bin
                (setf 
                      (aref bin-matrix row-num col-num) instance
                )
                
                (incf col-num)

                (when (= col-num nbins)
                    (setf col-num 0)
                    (incf row-num)
                )
        )
        bin-matrix
    )
)

; builds a test-set and train-set from the passed bin-matrix
; 90% of the data is used for training, 10% for testing
(defun build-data-set (filled-bins bin-num max-per test)
    (let ((eg-set) 
          (per-bin 0)
          (start 0) 
          (end))

        (loop for i from 1 to max-per
            do
                (when (aref filled-bins per-bin bin-num) 
                    (incf per-bin)
                )
        )

        (setf end (floor (/ per-bin 10)))

        (when (not test)
            (setf start end)
            (setf end (- per-bin 1))
        )
        (loop for row from start to end
            do
                (push (eg-features (aref filled-bins row bin-num)) eg-set)
        )
        eg-set
    )
)

(defun return-bins (data-set filled-bins per-bin)
        (values 
            (data :name 'bin0-test 
                  :columns (columns-header (table-columns data-set))
                  :egs (build-data-set filled-bins 0 per-bin t)
            )
            (data :name 'bin0-train
                  :columns (columns-header (table-columns data-set))
                  :egs (build-data-set filled-bins 0 per-bin nil)
            )
            (data :name 'bin1-test
                  :columns (columns-header (table-columns data-set))
                  :egs (build-data-set filled-bins 1 per-bin t)
            )
            (data :name 'bin1-train
                  :columns (columns-header (table-columns data-set))
                  :egs (build-data-set filled-bins 1 per-bin nil)
            )
            (data :name 'bin2-test
                  :columns (columns-header (table-columns data-set))
                  :egs (build-data-set filled-bins 2 per-bin t)
            )
            (data :name 'bin2-train
                  :columns (columns-header (table-columns data-set))
                  :egs (build-data-set filled-bins 2 per-bin nil)
            )
            (data :name 'bin3-test
                  :columns (columns-header (table-columns data-set))
                  :egs (build-data-set filled-bins 3 per-bin t)
            )
            (data :name 'bin3-train
                  :columns (columns-header (table-columns data-set))
                  :egs (build-data-set filled-bins 3 per-bin nil)
            )
            (data :name 'bin4-test
                  :columns (columns-header (table-columns data-set))
                  :egs (build-data-set filled-bins 4 per-bin t)
            )
            (data :name 'bin4-train
                  :columns (columns-header (table-columns data-set))
                  :egs (build-data-set filled-bins 4 per-bin nil)
            )
            (data :name 'bin5-test
                  :columns (columns-header (table-columns data-set))
                  :egs (build-data-set filled-bins 5 per-bin t)
            )
            (data :name 'bin5-train
                  :columns (columns-header (table-columns data-set))
                  :egs (build-data-set filled-bins 5 per-bin nil)
            )
            (data :name 'bin6-test
                  :columns (columns-header (table-columns data-set))
                  :egs (build-data-set filled-bins 6 per-bin t)
            )
            (data :name 'bin6-train
                  :columns (columns-header (table-columns data-set))
                  :egs (build-data-set filled-bins 6 per-bin nil)
            )
            (data :name 'bin7-test
                  :columns (columns-header (table-columns data-set))
                  :egs (build-data-set filled-bins 7 per-bin t)
            )
            (data :name 'bin7-train
                  :columns (columns-header (table-columns data-set))
                  :egs (build-data-set filled-bins 7 per-bin nil)
            )
            (data :name 'bin8-test
                  :columns (columns-header (table-columns data-set))
                  :egs (build-data-set filled-bins 8 per-bin t)
            )
            (data :name 'bin8-train
                  :columns (columns-header (table-columns data-set))
                  :egs (build-data-set filled-bins 8 per-bin nil)
            )
            (data :name 'bin9-test
                  :columns (columns-header (table-columns data-set))
                  :egs (build-data-set filled-bins 9 per-bin t)
            )
            (data :name 'bin9-train
                  :columns (columns-header (table-columns data-set))
                  :egs (build-data-set filled-bins 9 per-bin nil)
            )
        )
)

