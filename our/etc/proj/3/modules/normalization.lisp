; Implements the Normalize pre-processor.
(defun normalize-table (tbl)
  (let ((normval)
        (n 0))
    (dolist (column (table-columns tbl) tbl)
      (when (typep column 'numeric)
        (setf normval (fill-normal tbl n))
        (dolist (record (table-all tbl))
          (setf (nth n (eg-features record)) (normalize normval (nth n (eg-features record))))))
      (incf n))))

