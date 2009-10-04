; splits a data-set into 10 bins, and preserves class distribution in
; bins.  Then builds a test-set from 10% of the data, and train-set from
; the remaining 90%
(defun bins (data-set &optional (nbins 10))
    (let* ((n-instances (negs data-set))
           (test-set)  
           (train-set)
           (classes (sort-table data-set)) ; sorted data-set by class
           (per-bin (ceiling (/ n-instances nbins))) ; # of instances per bin
           (filled-bins (fill-bins classes nbins per-bin))) ; bin-matrix
           (build-data-sets data-set filled-bins nbins per-bin) 
    )
)

; fills a 2 dimensional matrix with the passed instances.  The matrix has n
; columns, where n is the number of desired bins. The instances are 
; distributed evenly amongst the bins  
(defun fill-bins (instances nbins per-bin)
    (let* ((bin-counts (make-array nbins :initial-element per-bin))
           (bin-matrix (make-array (list per-bin nbins) :initial-element nil)))

        ; for each class in the class list
        (dolist (instance instances)
            (let* ((rand (random nbins)) ; random bin
                   (free (aref bin-counts rand))) ; number of free spots in bin

                (loop until (/= free 0) ; search for a non-full bin
                    do
                        (setf rand (random nbins)
                              free (aref bin-counts rand))
                )
 
                ; write the instance to the bin
                (setf 
                      (aref bin-matrix (- per-bin free) rand) instance
                      (aref bin-counts rand) (- (aref bin-counts rand) 1)
                      rand (random nbins)
                      free (aref bin-counts rand)
                )
            )
        )
        bin-matrix
    )
)

; builds a test-set and train-set from the passed bin-matrix
; 90% of the data is used for training, 10% for testing
(defun build-data-sets (data-set filled-bins nbins per-bin)
    (let* ((test-size (ceiling (/ nbins 10)))
           (test-set (consolidate filled-bins 0 test-size per-bin))
           (train-set (consolidate filled-bins test-size nbins per-bin)))

        (values ; return the two data sets
            (data :name 'test-set 
                  :columns (columns-header (table-columns data-set))
                  :egs test-set
            )
            (data :name 'train-set
                  :columns (columns-header (table-columns data-set))
                  :egs train-set
            )
        )
    )
)

; read instances from a two dimensional matrix representing bins and
; construct a new data set from all instances from columns 'start' to 'end'
(defun consolidate (buckets start end per-bin)
    (let* ((col-num start)  
           (row-num 0)
           (destination) 
           (egs))
        (loop until (= col-num end) ; stop at designated column
            do
                (loop until (= row-num per-bin) ; stop at last row
                    do
                        (if (aref buckets row-num col-num) 
                            (push (aref buckets row-num col-num) destination)
                            (); nil, do nothing, it's empty!
                        )
                        (incf row-num) ; move to the next row
                )
                (setf row-num 0)
                (incf col-num) ; move to th next column
        )

        ; for each captured instance, extract all features and build data-set
        (dolist (per-instance destination)
            (push (eg-features per-instance) egs))

        egs ; return the new data-set
    )
)
