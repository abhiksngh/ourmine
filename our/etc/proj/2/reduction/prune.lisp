; manually reduce the data set to only the passed columns and the class
(defun prune-columns (data column-list)
    (let* ((tbl (features-as-a-list data))
           (trans-tbl (transpose tbl))
           (pruned-tbl (list ))
           (cols (columns-header (table-columns data)))
           (pruned-cols (list ))
           (class-col (table-class data)))

        (setf column-list (append column-list (list class-col)))

        (dolist (col column-list)
            (setf pruned-cols (append pruned-cols (list (nth col cols))))
            (setf pruned-tbl (append pruned-tbl (list (nth col trans-tbl))))
        )
         
        (setf tbl (transpose pruned-tbl))

        (data :name 'pruned-set
              :columns pruned-cols
              :egs tbl
        )
    )
)
