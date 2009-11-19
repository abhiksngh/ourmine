;; split2bins
;; Splits a data-set into N bins (default = 10) then splits them into 10% and 90%
;; Parameters: training data & number of bins)

(defun split2bins (data &optional (bins 10))
  (let* ((table-data (table-all data))
         (egs (get-features table-data))
         (n (length egs))
         (temp-bin)
         (bucket (create-bucket bins))
         (count 0))
    (dotimes (start n bucket)
      (progn
        (setf temp-bin (nth (random (- n 1)) egs))
        (setf (nth count bucket) (cons temp-bin (nth count bucket)))
        (remove temp-bin egs)
        (if (= count (- bins 1))
            (setf count 0)
            (incf count))))
    (list (make-simple-table (table-name data) (table-columns data) (blowup-bins (car bucket)))
          (make-simple-table (table-name data) (table-columns data) (blowup-bins (cdr bucket))))))
                



(defun split2bin-tables (data &optional (bins 10))
  (let* ((table-data (table-all data))
         (egs (get-features table-data))
         (n (length egs))
         (temp-bin)
         (bucket (create-bucket bins))
         (bucket-tables '())
         (count 0))
    (dotimes (start n bucket)
      (progn
        (setf temp-bin (nth (random (- n 1)) egs))
        (setf (nth count bucket) (cons temp-bin (nth count bucket)))
        (remove temp-bin egs)
        (if (= count (- bins 1))
            (setf count 0)
            (incf count))))
    (dolist (bin-instances bucket bucket-tables)
      (setf bucket-tables (append (list (xindex (make-simple-table (table-name data) (table-columns data) bin-instances))) bucket-tables)))))




; creates a bucket containing 'size' number of bins
(defun create-bucket (size)
  (let* ((bucket))
    (dotimes (start size bucket)
      (setf bucket (cons '() bucket)))))
                

;; builds train data from 90% of the data and test data from 10%
(defun traintest-bins (data)
  (let* ((bucket (split2bins data))
         (bucket-size (length bucket))
         (test-size (round (* 0.1 bucket-size)))
         (temp-bin)
         (test))
    (dotimes (start test-size)
      (setf temp-bin (nth (random bucket-size) bucket))
      (setf test (cons temp-bin test))
      (remove temp-bin bucket))
    (values bucket test)))


(defun blowup-bins (bucket)
  "explodes the bins in a bucket so the bucket is filled up with only instances"
  (let* ((newlist '()))
    (if (listp (car (car bucket)))
        (dolist (bin bucket newlist)
          (dolist (i bin)
            (setf newlist (cons i newlist))))
        bucket)))
