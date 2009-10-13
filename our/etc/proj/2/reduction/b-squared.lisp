(defun b-squared (data)
    (let* ((scored-data (score-data data))
           (sorted-data (sort-table scored-data))
           (disc-data (xindex (equal-width sorted-data)))
           (instance-count (negs data)))
        (multiple-value-bind (b r) (chop-data disc-data instance-count)
            (compute-scores disc-data b r)
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
    5
)

(defmethod numval3 ((header discrete) class-val)
    (declare (ignore header))
    (if (equal class-val 'TRUE)
        10
        5
    )
)


(defun compute-scores (data b r)
    (let* ((attr-vals) ; unique attr values
           (V 0) ; magic cut-off value for b
           (trans-data) (attr-data) (class-data)
           (sorted-attr-data)
           (keep-cols-i 0)
           (col-names)
           (min-score) (max-score) (cutoff-score)
           (n-cols (length (table-columns data)))
           (scores (list )) ; value scores for each attr value
           (median-scores (list )) ; median scores for each attr
           (b-set (xindex b)) ; best set of data
           (r-set (xindex r)) ; rest set of data
           (b-size(negs b-set)) (r-size (negs r-set)))

        ;for every attribute we have a number of possible values
        (loop for i from 0 to (- (length (table-columns data)) 1)
          do
            (setf attr-vals (discrete-uniques (nth i (table-columns data))))
            (setf scores (list ))

            ;we want to find the frequency of each attr value/class pair
            (dolist (per-val attr-vals)
                ; calculate b^2/(b+r) for each per-val/pair-freq pair
                ;  r = freq(r in Rest) / SizeOfRest
                ;  b = freq(r in Best) / SizeOfBest
                ;if b < V, then b = 0
                (let ((b (/ (count per-val (table-all b-set) 
                   :key (lambda (k) (nth i (eg-features k)))) b-size))
                      (r (/ (count per-val (table-all r-set)
                   :key (lambda (k) (nth i (eg-features k)))) r-size)))

                    (when (< b V) (setf b 0))

                    (if (> r 0)
                        (setf scores (append scores (list (float (/ (square b) (+ b r))))))
                        (setf scores (append scores (list 0.0)))
                    )
                )
            )

            ; compute the median score for all attr vals
            (setf median-scores (append median-scores (list (median scores))))
        )

        ;Sort each attribute by the median score
        (setf trans-data (transpose 
                         (append (features-as-a-list data) 
                                 (list (table-columns (ar3))) 
                                 (list median-scores))))
        (setf attr-data (subseq trans-data 0 (- n-cols 1))) ; just attr

        ; preserve class data, don't consider in col reduction
        (setf class-data (nth (- n-cols 1) trans-data)) 

        ; sort the data by median score
        (setf sorted-attr-data (sort attr-data #'string-greaterp
                    :key (lambda (k) (format nil "~A" (last k)))))

        ; calculate the cut-off score, top 40% of range is kept
        (setf median-scores (nth (negs data) (transpose sorted-attr-data)))
        (setf max-score (nth 0 median-scores))
        (setf min-score (nth (- n-cols 2) median-scores))
        (setf score-cutoff (* (- max-score min-score) 0.6))

        ; gets the index of the last column we're keeping
        (dolist (score median-scores)
            (when (>= score score-cutoff)
                (incf keep-cols-i)
            )
        )

        ; prune off columns, tack classes back on
        (setf attr-data 
                      (append (subseq sorted-attr-data 0 keep-cols-i) 
                              (list class-data)))

        ; flip that shit
        (setf trans-data (transpose attr-data))

        ; extract the remaining col headers
        (setf col-names (nth (- (negs data) 1) trans-data))

        ; extract the data
        (setf data (subseq trans-data 0 (- (negs data) 1)))

        ; build a pruned data table
        (data :name 'col-reduced
          :columns (columns-header col-names)
          :egs data
        )
    )
)

(defun transpose (x)
  (apply #'mapcar (cons #'list x)))
