; sorts the passed table by class and returns the sorted table
(defun sort-table (tbl)
    (sort (table-all tbl) 'string-lessp :key 
                    #'(lambda (n) 
                  (format nil "~A" (nth (table-class tbl) (eg-features n)))))
)
