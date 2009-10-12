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
    '5
)

(defmethod numval3 ((header discrete) class-val)
    (declare (ignore header))
    '10
)


(defun compute-scores (data b r)
    ;pick some class value, let's say true
    (let* ((attr-vals) ; unique attr values
           (V 0) ; magic cut-off value for b
(i 0)
           (scores (list )) ; value scores for each attr value
           (median-scores (list )) ; median scores for each attr
           (b-set (xindex b))
           (r-set (xindex r))
           (b-size(negs b-set)) (r-size (negs r-set)))
        ;for every attribute we have a number of possible values
        (loop for i from 0 to (- (length (table-columns data)) 1)
          do
            (setf attr-vals (discrete-uniques (nth i (table-columns data))))
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
                        (setf scores (append scores (list (/ (square b) (+ b r)))))
                        (setf scores (append scores (list 0)))
                    )
                )
            )
            ; compute the median score for all attr vals
            (setf median-scores (append median-scores (list (median scores))))

;Reject attributes with less than X% of the max. median score
        )
        ;Sort each attribute by the median score
;        (setf median-scores (sort median-scores #'<))
(format t "data:~%~A~%" (features-as-a-list data))
(format t "trans:~%~A~%" (transpose (features-as-a-list data)))

        (transpose (sort (transpose (features-as-a-list data)) #'<
                    :key (lambda (k) (nth i median-scores) (incf i))))
    )
)

(defun transpose (x)
  (apply #'mapcar (cons #'list x)))



