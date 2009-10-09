(defun k-nearest-per-instance(instance table &optional (k 10))
  ;;Set the class to a numeric, so we don't have to build code to handle a single discrete at the end of a line.  This zero will have no impact on the distance.
  (let* ((instance (eg-features instance))
         (xtable (xindex table))
         (data (table-all xtable))
         (resultHash (make-hash-table))
         (cozyNeighborList))
    ;;Populate a hash table of distances from the instance to all neighbors.
    (doitems (per-instance i data)
      (let* ((per-instance (eg-features per-instance))
             (distanceList))
         (doitems (per-attribute n per-instance)
           (if (numberp per-attribute)
               (push (- (nth n instance) per-attribute) distanceList)))
         (setf (gethash i resultHash) (eucDistance distanceList))))
    ;;Create a list of the k closest neighbors. Working the Lisp-fu.
    (maphash #'(lambda (key value)
                 (if (not(= value 0))
                 (setf cozyNeighborList (append (list (list key value)) cozyNeighborList))))
                 resultHash)
    (sort cozyNeighborList #'< :key #'second)))

         
;;Super ultra sexy euclidean distance one-liner!!!
(defun eucDistance(lst)
  (sqrt (apply '+ (mapcar 'square lst))))

(deftest test-eucDistance()
  (check
    (= (eucDistance '(3 4)) 5.0)))

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
