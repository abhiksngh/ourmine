(defun b-squared (data) 
    (let* ((true-cols  (b2 data 10 5))
           (false-cols (b2 data 5 10)))
           (prune-columns data (remove-duplicates (append true-cols false-cols))))
          
)
(defun b2 (data true-score false-score)
    (let* ((scored-data (score-data data true-score false-score))
           (sorted-data (sort-table scored-data))
           (disc-data (xindex sorted-data))
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

(defun score-data (data true-score false-score) 
    (let* ((header (table-columns data))
           (all-instances (table-all data))
           (classi (table-class data))
           eg-set)

        (dolist (per-instance all-instances)
            (push (score-class per-instance header classi true-score false-score) eg-set)
        )
        (data :name 'class-set
          :columns (columns-header (table-columns data))
          :egs eg-set
        )
    )
)
(defun score-class (per-instance header classi true-score false-score)
    (let ((all-features (copy-list (eg-features per-instance))))
        (setf (nth classi all-features) (numval4 (nth classi header) (nth classi all-features) true-score false-score))
        all-features
    )
)

(defmethod numval4 ((header numeric) class-val true-score false-score)
    (declare (ignore header))
    5
)

(defmethod numval4 ((header discrete) class-val true-score false-score)
    (declare (ignore header))
    (if (equal class-val 'TRUE)
        true-score
        false-score
    )
)


(defun compute-scores (data b r)
    (let* ((attr-vals) ; unique attr values
           (V .15) ; magic cut-off value for b
           (trans-data) (attr-data) (class-data)
           (sorted-attr-data)
           (keep-cols (list ))
           (col-names)
           (n-cols (length (table-columns data)))
           (scores (list )) ; value scores for each attr value
           (median-scores (list )) ; median scores for each attr
           (b-set (xindex b)) ; best set of data
           (r-set (xindex r)) ; rest set of data
           (b-size(negs b-set)) (r-size (negs r-set))
           (col-nums (list )))

        ;for every attribute we have a number of possible values
        (loop for i from 0 to (- (length (table-columns data)) 2)
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
        (setf median-scores (append median-scores (list 0.0))) ; no score for class

        ; build a table of scores & col nums
        (loop for i from 0 to (length median-scores)
            do
                (setf col-nums (append col-nums (list i)))
        )
        (setf trans-data (transpose 
                         (append (list col-nums) (list median-scores))))

        ; sort the data by median score
        (setf sorted-attr-data (sort trans-data #'string-greaterp
                    :key (lambda (k) (format nil "~A" (last k)))))

        ; flip that shit
        (setf trans-data (transpose sorted-attr-data))

        ; extract the remaining col headers
        (setf keep-cols (sort (subseq (nth 0 trans-data) 0 3) #'<))
    )
)

(defun transpose (x)
  (apply #'mapcar (cons #'list x)))

(defun back-to-class(data)
  (dolist (per-data data data)
    (if (equal (nth (1- (length per-data)) per-data) '5)
        (setf (nth (1- (length per-data)) per-data) 'FALSE)
        (setf (nth (1- (length per-data)) per-data)'TRUE))))


