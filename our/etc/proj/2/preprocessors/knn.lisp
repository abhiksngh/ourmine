;;Super ultra sexy euclidean distance one-liner!!!
(defun eucDistance(instance)
  (sqrt (apply '+ (mapcar 'square instance))))

(defun features-as-a-list(table)
  (let* ((data (shuffle (table-all (xindex table))))
         result)
    (dotimes (i (length data) result)
      (push (eg-features(nth i (table-all table)))  result))))

;;Remove num instances from a dataset at random.
(defun remove-a-few(table num)
  (let* ((data (shuffle (table-all (xindex table))))
         result)
    (dotimes (i (- (length data) num) (build-a-data (table-name table) (columns-header (table-columns table)) result))
      (push (eg-features(nth i (table-all table)))  result))))

;;Create a new dataset.
(defun build-a-data(name columns egs)
  (data
   :name name
   :columns columns
   :egs egs))
  
;;Normalize numeric data functions!  xindex is sweeeeeeeeeeet...
(defun normalizeData(table)
  (let* ((xtable (xindex table))
         (data (table-all xtable))
         (columns (numeric-col table))
         (cols (table-columns table)))
    (dolist (per-data data xtable)
      (let ((per-instance per-data))
        (dolist (per-index columns)
          (let* ((head (header-f (nth per-index cols)))
                (f-struct (gethash (eg-class per-instance) head))
                (classMinimum (normal-min f-struct))
                (classMaximum (normal-max f-struct)))
            (if (= classMaximum 0)
                (setf classMaximum 0.001))
            (setf (nth per-index (eg-features per-instance)) (normal classMinimum classMaximum (nth per-index (eg-features per-data))))))))))

(defun normal (classMinimum classMaximum value)
  (/ (- value classMinimum) (- classMaximum classMinimum)))
    
(defun numeric-col(data)
  (let* ((columns)
         (i 0)
         (cols (table-columns data)))
         (dolist (per-col cols columns)
           (if (numericp (header-name per-col))
               (setf columns (append columns (list i))))
           (incf i))))
