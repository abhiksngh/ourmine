(defmacro while (test &rest body)
  (list* 'loop
         (list 'unless test '(return nil))
         body))

(defun nchops (n source-table)
  (let ((newtable (transpose (get-data source-table)))
        (result-table))
    (dolist (column newtable)
     ; (format t "please")
      (if (typep (first column) 'number)
          (let* ((sorted-col (sort column #'<))
                (col-size (length column))
                (chop-size (+ 1 (floor (/ col-size n))))
                (loop-count 0)
                (currentchop-low 0)
                (currentchop-high 0))
            (while (< loop-count n);(format t "something happen here?")
              (if (< currentchop-high col-size)
                  
              (let() (setf currentchop-high (+ currentchop-low chop-size))
               (while (equalp (nth currentchop-high sorted-col) (nth (+ currentchop-high 1) sorted-col))
                 (incf currentchop-high))
               (dolist (current-val column)
                 (if (> current-val (nth currentchop-low sorted-col))
                     (if (< current-val (nth currentchop-high sorted-col))
                         (setf current-val (nth currentchop-low sorted-col)))))
               (incf loop-count)
               (format t "something should be set to a value here")
               (setf currentchop-low currentchop-high)))))))
    (setf result-table (data
                     :name (table-name source-table)
                     :columns (columns-header (table-columns source-table))
                     :klass (table-class source-table)
                     :egs (transpose newtable)))
    result-table))


             ;
             ;not quite working yet.
             ;WTF WTF WTF WTF WTF WTF WTF WTF
             ;
