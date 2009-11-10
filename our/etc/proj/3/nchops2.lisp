(defmacro while (test &rest body)
  (list* 'loop
         (list 'unless test '(return nil))
         body))

(defun nchops (n source-table)
  (let ((newtable (transpose (get-data source-table)))
        (result-table))
    (dolist (column newtable result-table)
      (format t "new column")
      (when (typep (first column) 'number)
        (let* ((sorted-col (sort (copy-list column) #'<))
               (col-size (length column))
               (chop-size (+ 1 (floor (/ col-size n))))
               (loop-count 0)
               (currentchop-low 0)
               (currentchop-high 0)
               (index 0))
          (format t "chop size ~a~%" chop-size)
                                        ;(setf sorted-col (sort (copy-list column) #'<))
          (while (<= loop-count n)
            (when (<= currentchop-high col-size)
              (unless (> (+ currentchop-low chop-size) (length sorted-col))
                (setf currentchop-high (+ currentchop-low chop-size)))
              (unless (> (+ currentchop-high 1)  (length sorted-col))
                (while (equalp (nth currentchop-high sorted-col) (nth (+ currentchop-high 1) sorted-col))
                  (incf currentchop-high)))
              (format t "YAY ~a~%" currentchop-high)
                                        ;   (print column)
              (dolist (current-val column)
                (when (> current-val (nth currentchop-low sorted-col))
                                        ;(format t "first ")
                  (when (< current-val (nth currentchop-high sorted-col))
                                        ;(format t "second ")
                    (setf (nth index column) (nth currentchop-high sorted-col))))
                (incf index))
              (setf index 0)
              (setf currentchop-low currentchop-high)
                                        ;(format t "~a~%" loop-count);)
              (incf loop-count)
              )))))
    (setf result-table (data
                        :name (table-name source-table)
                        :columns (columns-header (table-columns source-table))
                        :klass (table-class source-table)
                        :egs (reverse (transpose newtable))))))


                                        ;
                                        ;sort is destructive and it breaks things
                                        ;not quite working yet. doesn't change any values
                                        ;WTF WTF WTF WTF WTF WTF WTF WTF
                                        ;
