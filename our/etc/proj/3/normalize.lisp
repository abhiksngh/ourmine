


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
         (class-lst)
         )
    ;get class.  Needed
    (setf class-lst (first (last transposed-data)))
    (setf transposed-data (remove class-lst transposed-data))

    ;(print class-lst)
    ;(print 'vs)
    ;(print (last transposed-data))

    ;for each column
    ;(print '0)
    (dolist (one-column transposed-data)
      
      ;(print '0.1)
      (setf new-column NIL)
      (setf norm-struct NIL)
      (setf norm-struct (make-normal))

      ;Has discretes?  
      (if (equalp (is-column-discrete one-column) NIL) ;if column isn't discrete
          ;if no, lumn '(value position)
          (progn
        ;    (print "NEW COLUMN")
         ;   (print "column is numeric")
            ;get normals of column
            (if (equalp 't (< 1 (length (remove-duplicates one-column)))); more than one unique
                (progn
                  (dolist (item one-column)
          ;          (print "Adding:")
          ;         (print item)
                    (add norm-struct item))
                  
          ;        (print "normal ready")
          ;        (print norm-struct)
                  
                  (dolist (item2 one-column)
                    
          ;          (print "Current Item:")
          ;          (print item2)
          ;          (print "(pdf) result:")
          ;          (print (pdf norm-struct item2))
          ;          (print '3)
                    (setf new-column (append new-column (list (pdf norm-struct item2)))))
                  
                  (setf new-data (append new-data (list new-column))))
                (setf new-data (append new-data (list one-column))))); if all data is the same
          (setf new-data (append new-data (list one-column)))); if column is discrete
      (print new-data)
      )
          
    
    
    (setf new-data (append new-data (list class-lst)))
    
                       
    
                       ;normalize on the list

    ;for each nth item

    ;if n in position list
        ;get position of n
        ;append item at (position of n in position-lst) 




    ;(setf new-data (append new-data class-lst))

    (setf new-table (data
                     :name (table-name table)
                     :columns (columns-header (table-columns table))
                     :klass (table-class table)
                     :egs
                     (transpose new-data)))
    
    new-table
    )
  )
  


               