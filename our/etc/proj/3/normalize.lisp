


(defun normalize (source-table)
  (let* (
         (table (copy-table source-table))
         (new-table)
         (transposed-data (transpose (get-data table)))
         (pre-normalize-lst)
         (position-lst)
         (post-normalize-lst)
         (new-data)
         (new-column)
         (norm-struct)
         (n)
         )
    ;for each column
    (dolist (one-column transposed-data)
      (setf new-column NIL)
      (setf norm-struct (make-normal))
    ;Has discretes?  
      (if (equalp (is-column-discrete one-column) NIL)
          ;if no, lumn '(value position)
          (progn
            
            ;get normals of column
            (dolist (item one-column)
              (add norm-struct item))
            
            (dolist (item2 one-column)
              (setf new-column (append new-column (list (pdf norm-struct item2)))))

            (setf new-data (append new-data new-column)))
          (setf new-data (append new-data one-column))))
                                               
                    
                       

                       ;normalize on the list

    ;for each nth item

    ;if n in position list
        ;get position of n
        ;append item at (position of n in position-lst) 






    (setf new-table (data
                     :name (table-name table)
                     :columns (columns-header (table-columns table))
                     :klass (table-class table)
                     :egs
                     (transpose new-data)))

    new-table
    )
  )

               