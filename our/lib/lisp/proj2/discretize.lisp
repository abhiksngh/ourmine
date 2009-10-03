; discretize:
; call: (discretize train 10 1) = discretize dataset 'train' with 10 bins using column #1

(defun get-col-maxmin (dataset &optional (colnum 0))
  "discretizes a dataset based on values in 'column' - default column = 1"
  (let* ((umin)
         (umax)
         (min)
         (max)
         (maxmin '())
         (dataset (xindex dataset)) ; get the min and max for each column
         (class-column-number (table-class dataset)) ; get column # that has the unique classes in it
         (class-data (nth class-column-number (table-columns dataset))) ; get the structure containing the unique classes
         (classes (discrete-uniques class-data))
         (data-col (nth colnum (table-columns dataset))))
    (dolist (c classes maxmin)
      (multiple-value-bind (max min) (get-range data-col c)
        (if (null umin)
            (setf umin min)
            (if (< min umin)
                (setf umin min)))
        (if (null umax)
            (setf umax max)
            (if (> max umax)
                (setf umax max)))
        (setf maxmin (list umax umin))))))


(defun discretize (dataset &optional (bins 10) (colnum 0))
  (let* ((maxmin (get-col-maxmin dataset colnum))
         (max (first maxmin))
         (min (second maxmin))
         (index)
         (range (- max min))
         (bin-range (/ range bins))
         (instances (get-features (table-all dataset))))
    (format t "max: ~a ~%min: ~a ~%bin-range: ~a ~%" max min bin-range)
    (setf bucket-info (create-bucket-info max min bins))
    (setf bucket (create-bucket bins))
    (dolist (item instances (merge-bins bucket))
      (setf index (which-bin bucket-info (nth colnum item)))
      (setf (nth index bucket) (cons item (nth index bucket))))))
    

(defun create-bucket-info (max min bins)
  "creates an association list containing the ranges for each bin (ie. (low . high) for bin 1, 2 etc)
   this is used to determine the bin which a value falls in"
  (let* ((bucket)
         (range (- max min))
         (bin-range (/ range bins))
         (low min)
         (high (+ min bin-range)))
    (dotimes (n bins (reverse bucket))
      (setf bucket (acons low high bucket))
      (setf low high)
      (setf high (+ high bin-range)))))


(defun which-bin (bucket-info val)
  "takes a bucket-info list and a val and retuns the bin # which the value falls in"
  (let* ((count 0))
    (dolist (range bucket-info)
      (if (and (>= val (car range)) (<= val (cdr range)))
          (return (values count range))
          (incf count)))))
    

(defun merge-bins (bucket)
  (let* ((dataset))
    (dolist (item bucket dataset)
      (setf dataset (append item dataset)))))
