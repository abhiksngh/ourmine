(defmacro while (test &rest body)
  (list* 'loop
         (list 'unless test '(return nil))
         body))


;; # (EASY) N-chops (equal-frequency discretization)
;; (defun nchops-rewrite (n source-table)
;;   (let* (
;;          (source-data (transpose (get-data source-table)))
;;          (new-table)
;;          (break1)
;;          (pos-break1)
;;          (break2)
;;          (pos-break2)
;;          (sorted-column)
;;          (new-data)
;;          (bin1)
;;          (bin2)
;;          )
    
;;     (dolist (column source-data)
;;       (if (not (is-column-discrete column));; if column is NOT discrete
;;           (progn
;;             (setf sorted-column (sort column #'<));; sort column
;;             ;find break1
;;             (setf pos-break1 (get-break1-position n sorted-column))
;;             (setf break1 (nth pos-break1 sorted-column))

            
;;             )
;;           )
;;       )
;;     )
;;   )

(defun get-break1-position (n column)
  (+ 1 (floor (/ (length column) n))))
  
  
         
;; Sort the numbers, 
;; find the number at the end of the first N% of the data, call that break1. 

;; Until the next smallest number is different to break1, walk up the list. 
;; Find the number at the next N% of the data, call that break2. 
;; Until the next smallest number is different to break2, walk up the list. 

;; Etc. Go back over the data: everything underneath break1 is in bin1, 
;; the remainder underneath break2 is in bin2, etc. 

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
