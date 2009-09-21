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
