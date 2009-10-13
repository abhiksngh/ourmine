; sorts the passed table by class and returns the sorted table
(defun sort-table (tbl)
    (setf (table-all tbl)  
    (sort (table-all tbl) 'string-lessp :key #'(lambda (n) 
                  (format nil "~A" (nth (table-class tbl) (eg-features n))))))
    tbl
)

(deftest test-sort ()
    (check
        (let* ((tbl (make-data))
              (sorted-tbl (xindex (sort-table tbl)))
              (egs (table-all sorted-tbl)))
            (and 
              (equal (last (eg-features (nth 0 egs))) '(NO))
              (equal (last (eg-features (nth 1 egs))) '(NO))
              (equal (last (eg-features (nth 2 egs))) '(YES))
              (equal (last (eg-features (nth 3 egs))) '(YES))
              (equal (last (eg-features (nth 4 egs))) '(YES))
              (equal (last (eg-features (nth 5 egs))) '(YES)))   
        )
    )
)
