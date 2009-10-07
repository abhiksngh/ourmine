; discretize:
; call: (discretize train 10 1) = discretize dataset 'train' with 10 bins using column #1

(defun discretize (dataset &optional (bins 10))
  (let* ((dataset (xindex dataset))
         (class-column-number (table-class dataset))
         (table-data (get-features (table-all dataset)))
         (counter 0)
         (intel (get-intel dataset class-column-number table-data bins)))
    (dolist (instance table-data (make-desc-table (table-name dataset) (table-columns dataset) table-data))
      (setf counter 0)
      (dolist (item instance)
        (if (not (eq counter class-column-number))
            (progn
              (setf (nth counter instance) (which-bin (nth counter intel) item))
              (incf counter)))))))


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


(defun get-intel (dataset class-column-number table-data &optional (bins 10))
  (let* ((intel '()))
    (dotimes (n (- (length (car table-data)) 1)(reverse  intel))
      (if (not (eq n class-column-number))
          (progn
            (let* ((maxmin (get-col-maxmin dataset n))
                   (max (first maxmin))
                   (min (second maxmin)))
              (setf intel (cons (create-bucket-info max min bins) intel))))))))

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
    


