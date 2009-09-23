;; split2bins
;; Splits a data-set into N bins (default = 10)
;; Parameters: training data & number of bins)

(defun split2bins (data &optional (bins 10))
  (let* ((table-data (table-all data))
         (egs (get-features table-data))
         (n (length egs))
         (bin-size (round (/ n bins)))
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
            (incf count))))))
                

; creates a bucket containing 'size' number of bins
(defun create-bucket (size)
  (let* ((bucket))
    (dotimes (start size bucket)
      (setf bucket (cons '() bucket)))))
                
      
