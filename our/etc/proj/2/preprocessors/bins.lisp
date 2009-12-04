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

; splits a data-set into nbins, and preserves class distribution in
; bins.  Then builds a test-set from 10% of the data, and train-set from
; the remaining 90%
(defun bins (data)
    (let* ((n-instances (negs data))
           (test-set)  
           (train-set)
           (nbins 3)

           ; sort the instances of the table by class value
           (classes (table-all (sort-table data))) 
           (per-bin (ceiling (/ n-instances nbins))) ; # of instances per bin

           ; fill the bins with the instances evenly 
           (filled-bins (fill-bins classes nbins per-bin)))
       
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

(defun get-test (bins-list bin-num)
    (let* ((len (length (nth bin-num bins-list)))
           (test-size (ceiling (* len .1))))
        (subseq (nth bin-num bins-list) 0 (- test-size 1))
    )    
)

(defun get-train (bins-list bin-num)
    (let* ((len (length (nth bin-num bins-list)))
           (test-size (ceiling (* len .1))))
        (subseq (nth bin-num bins-list) (- test-size 1))
    )
)


(defun bin-list (filled-bins max-per)
    (let* ((per-bin 0) (eg-set) (bins-list))
        (loop for bin-num from 0 to 2
          do
            (loop for i from 1 to max-per
                do
                    (when (aref filled-bins per-bin bin-num)
                        (incf per-bin)
                    )
            ) ; know how many are in the bin
            (loop for row from 0 to (- per-bin 1)
                do
                    (push (eg-features (aref filled-bins row bin-num)) eg-set)
            )
            (setf per-bin 0)
            (setf eg-set (shuffle eg-set))
            (push eg-set bins-list)
            (setf eg-set (list ))
        )
        bins-list
    )
)



; create train/test data sets for each bin 
(defun return-bins (data-set filled-bins per-bin)
    (let* ((bins-list (bin-list filled-bins per-bin)))

        (values 
     
           (list (data :name (format nil "~A_~A" (table-name data-set) "bin0-train")
                  :columns (columns-header (table-columns data-set))
                  :egs (get-train bins-list 0)
            )
 
            (data :name (format nil "~A_~A" (table-name data-set) "bin1-train")
                  :columns (columns-header (table-columns data-set))
                  :egs (get-train bins-list 1)
            )

            (data :name (format nil "~A_~A" (table-name data-set) "bin2-train")
                  :columns (columns-header (table-columns data-set))
                  :egs (get-train bins-list 2)
            )

;            (data :name (format nil "~A_~A" (table-name data-set) "bin3-train")
;                  :columns (columns-header (table-columns data-set))
;                  :egs (get-train bins-list 3)
;            )

;            (data :name (format nil "~A_~A" (table-name data-set) "bin4-train")
;                  :columns (columns-header (table-columns data-set))
;                  :egs (get-train bins-list 4)
;            )

;            (data :name (format nil "~A_~A" (table-name data-set) "bin5-train")
;                  :columns (columns-header (table-columns data-set))
;                  :egs (build-data-set filled-bins 5 per-bin nil)
;            )
;
;            (data :name (format nil "~A_~A" (table-name data-set) "bin6-train")
;                  :columns (columns-header (table-columns data-set))
;                  :egs (build-data-set filled-bins 6 per-bin nil)
;            )
;
;            (data :name (format nil "~A_~A" (table-name data-set) "bin7-train")
;                  :columns (columns-header (table-columns data-set))
;                  :egs (build-data-set filled-bins 7 per-bin nil)
;            )
;
;            (data :name (format nil "~A_~A" (table-name data-set) "bin8-train")
;                  :columns (columns-header (table-columns data-set))
;                  :egs (build-data-set filled-bins 8 per-bin nil)
;            )
;
;           (data :name (format nil "~A_~A" (table-name data-set) "bin9-train")
;                  :columns (columns-header (table-columns data-set))
;                  :egs (build-data-set filled-bins 9 per-bin nil)
;            )
)
            
          (list  (data :name (format nil "~A_~A" (table-name data-set) "bin0-test")
                  :columns (columns-header (table-columns data-set))
                  :egs (get-test bins-list 0)
            )

            (data :name (format nil "~A_~A" (table-name data-set) "bin1-test")
                  :columns (columns-header (table-columns data-set))
                  :egs (get-test bins-list 1)
            )

            (data :name (format nil "~A_~A" (table-name data-set) "bin2-test")
                  :columns (columns-header (table-columns data-set))
                  :egs (get-test bins-list 2)
            )

;            (data :name (format nil "~A_~A" (table-name data-set) "bin3-test")
;                  :columns (columns-header (table-columns data-set))
;                  :egs (get-test bins-list 3)
;            )

;            (data :name (format nil "~A_~A" (table-name data-set) "bin4-test")
;                  :columns (columns-header (table-columns data-set))
;                  :egs (get-test bins-list 4)
;            )

;            (data :name (format nil "~A_~A" (table-name data-set) "bin5-test")
;                  :columns (columns-header (table-columns data-set))
;                  :egs (build-data-set filled-bins 5 per-bin t)
;            )
;
;            (data :name (format nil "~A_~A" (table-name data-set) "bin6-test")
;                  :columns (columns-header (table-columns data-set))
;                  :egs (build-data-set filled-bins 6 per-bin t)
;            )
;
;            (data :name (format nil "~A_~A" (table-name data-set) "bin7-test")
;                  :columns (columns-header (table-columns data-set))
;                  :egs (build-data-set filled-bins 7 per-bin t)
;            )
;
;            (data :name (format nil "~A_~A" (table-name data-set) "bin8-test")
;                  :columns (columns-header (table-columns data-set))
;                  :egs (build-data-set filled-bins 8 per-bin t)
;            )
;
;            (data :name (format nil "~A_~A" (table-name data-set) "bin9-test")
;                  :columns (columns-header (table-columns data-set))
;                  :egs (build-data-set filled-bins 9 per-bin t)
;            )
     )
     )
     )
)

