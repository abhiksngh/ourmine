(defmacro while (test &rest body)
  (list* 'loop
         (list 'unless test '(return nil))
         body))

(defun nchops (n source-table)
  (let ((newtable (transpose (get-data source-table)))
        (result-table))
    (dolist (column newtable result-table)
      (when (typep (first column) 'number)
          (let* ((temp-col)
                (sorted-col)
                (col-size (length column))
                (chop-size (+ 1 (floor (/ col-size n))))
                (loop-count 0)
                (currentchop-low 0)
                (currentchop-high 0))
            (setf temp-col column)
            (setf sorted-col (sort temp-col #'<))
            (while (< loop-count n);(format t "something happen here?")
              (setf currentchop-low currentchop-high)
              (setf currentchop-high (+ currentchop-low chop-size))
              (when (< currentchop-high col-size)  
                (while (equalp (nth currentchop-high sorted-col) (nth (+ currentchop-high 1) sorted-col))
                  (incf currentchop-high))
                (format t "YAY ~a~%" currentchop-high)
                (print column)
                (dolist (current-val column)
                  (when (> current-val (nth currentchop-low sorted-col))
                      (when (< current-val (nth currentchop-high sorted-col))
                          (setf current-val (nth currentchop-low sorted-col)))))
                (format t "~a~%" loop-count))
              (incf loop-count)))))
    (setf result-table (data
                     :name (table-name source-table)
                     :columns (columns-header (table-columns source-table))
                     :klass (table-class source-table)
                     :egs (transpose newtable)))))


             ;
             ;sort is destructive and it breaks things
             ;not quite working yet. does not put all data back into the table
             ;WTF WTF WTF WTF WTF WTF WTF WTF
             ;

;(defun nchops (n source-table)
;  (let* ((source-data (transpose (get-data source-table)))
;         (col-size (length (first source-data)))
;         (chop-size (+ 1 (floor (/ col-size n)))))
;    (dolist (column source-data)
;      (if (typep (first column) 'number)
;          (
