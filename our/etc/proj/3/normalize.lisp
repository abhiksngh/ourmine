


(defun normalize (source-table)
  (let* ((table (copy-table source-table))
         (transposed-data (transpose (get-data table))))
    
               