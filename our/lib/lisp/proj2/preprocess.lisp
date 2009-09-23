;;log the numerics

(defun find-numeric-cols (data)
  (let* ((numeric-cols)
         (count 0)
         (col (table-columns data)))
         (dolist (i col numeric-cols)
           (if (numericp (header-name i))
               (setf numeric-cols (append numeric-cols (list count))))
         (incf count))))


(defun log-data1 (data)
  (log-data2 (find-numeric-cols data) data))

(defun log-data2 (indx-lst data)
  (let* ((all (table-all data)))
    (dolist (i all)
      (dolist (indx indx-lst)
        ;(format t "~A " (nth indx (eg-features i)))
        (setf (nth indx (eg-features i))
              (log-item (nth indx (eg-features i)) indx))))))
        
(defun log-item (row pos)
  (let* ((n (nth pos row)))
    (if (not (unknownp n))
        (if (< n 0.0001)
            (log 0.0001 10)
            (log n 10))
        n)))

(defun test-numeric-cols (cols)
  (dolist (i cols t)
    (format t "~A " i)))

;; new data set 
(defun new-data (train &rest args)
  (let* ((new-data (table-copy train (get-features (table-all train)))))
    (dolist (dat args new-data)
      (let* ((dat-set (table-all dat)))
        (setf (table-all new-data)
              (append (table-all new-data)  dat-set))))))
    

;;k-nearest-neighbor
(defun k-nearest (instance train &optional (k 10))
  (let* ((klist (make-hash-table :test 'equal))
         (k-nearest)
         (key))
    (dolist (obj train klist)
      (setf (gethash obj klist)(euc instance obj)))
    (dotimes (i k (reverse k-nearest))
           (if (= (hash-table-count klist) 0)
               (return-from k-nearest (reverse k-nearest))
               (progn      
                 (setf key (get-hash-nearest klist))
                 (setf k-nearest (push key k-nearest))
                 (remhash key klist))))))

;;util function for k-nearest
(defun get-hash-nearest (ht)
  (let* ((key)
         (val most-positive-fixnum))
    (maphash #'(lambda (k v) (if ( <= (gethash k ht) val)
                                 (progn
                                 (setf key k)
                                 (setf val v)))) ht)
  key))
                                 


;; util function to print hash                                 
(defun print-hash (hash)
  (maphash #'(lambda (k v) (format t "~A = ~A~%" k v))
           hash))





  
