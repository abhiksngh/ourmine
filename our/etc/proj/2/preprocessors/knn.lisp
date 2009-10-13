(defun doNothing (table)
  table)

(defun k-nearest-per-instance(instance table &optional (distfunc #'eucDistance))
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
         (setf (gethash i resultHash) (funcall distfunc distanceList))))
    ;;Create a list of the k closest neighbors. Working the Lisp-fu.
    (maphash #'(lambda (key value)
                 (if (not(= value 0))
                 (setf cozyNeighborList (append (list (list key value)) cozyNeighborList))))
                 resultHash)
    (sort cozyNeighborList #'< :key #'second)))

;;Burak Filter
(defun burak(train test)
  (let* ((xtrain (normalizedata (xindex train)))
         (xtest (table-all(normalizedata(xindex test))))
         (tmp)
         (returnData)
         )
    (doitems (per-instance i xtest returnData)
      (let* ((nearest-neighbors (subseq (k-nearest-per-instance per-instance xtrain) 0 10)))
        (doitems (per-neighbor j nearest-neighbors)
          (let* ((neighbor (eg-features (nth (first per-neighbor) (table-all xtrain)))))
            (if (null (member neighbor tmp))
                (push neighbor tmp))))
        (setf returnData (build-a-data (table-name xtrain) (columns-header (table-columns xtrain)) tmp))))))
        
;;Super Burak Bros. Filter
(defun super-burak(n &rest test-sets)
  (let* ((train)
          (test)
          (columns))
    (doitems (per-test-set i test-sets)
      (multiple-value-bind (tmpTrain tmpTest) (funcall per-test-set n)
        (setf columns (columns-header(table-columns tmpTrain)))
        (setf train (append train (features-as-a-list tmpTest)))
        (setf test (append test (features-as-a-list tmpTest)))))
    (burak (build-a-data 'TRAIN-DATA columns  train)
           (build-a-data 'TEST-DATA columns test))))
      
;;Super ultra sexy euclidean distance one-liner!!!
(defun eucDistance(lst)
  (sqrt (apply '+ (mapcar 'square lst))))

(deftest test-eucDistance()
  (check
    (= (eucDistance '(3 4)) 5.0)))

(defun features-as-a-list(table)
  (let* ((data (table-all (xindex table)))
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
                (setf classMaximum (log 0.001)))
            (setf (nth per-index (eg-features per-instance)) (normal classMinimum classMaximum (nth per-index (eg-features per-data))))))))))

(defun normalizeDataTrainAndTest(train test)
  (let* ((combinedDataSet (nvalues 0.0 train test))
         (combinedDataSet (xindex combinedDataSet))
         (combinedData (table-all combinedDataSet))
         (cols (table-columns combinedDataSet)))
    (dolist (per-set (list (xindex train) (xindex test)) (values train test))
      (let* ((columns (numeric-col per-set))
             (table-data (table-all per-set)))
        (dolist (per-data table-data)
           (dolist (per-index columns)
             (let* ((header (header-f (nth per-index cols)))
                    (f-struct (gethash (eg-class per-data) header))
                    (classMinimum (normal-min f-struct))
                    (classMaximum (normal-max f-struct)))
               (if (= classMaximum 0)
                   (setf classMaximum (log 0.001)))
               (setf (nth per-index (eg-features per-data)) (normal classMinimum classMaximum (nth per-index (eg-features per-data)))))))))))

(deftest test-normalizeTrainTest()
  (multiple-value-bind (train test) (seg-ar3)
	   (multiple-value-bind (train test) (normalizedataTrainandTest train test)
	     (check
                (if (listp (or
                     (member (eg-features(nth 1 (table-all(normalizedata(Ar3))))) (features-as-a-list train))
                     (member (eg-features(nth 1 (table-all(normalizedata(ar3))))) (features-as-a-list test))))
        T
        nil)))))
  

(defun normal (classMinimum classMaximum value)
  (/ (- value classMinimum) (if (= (- classMaximum classMinimum) 0)
                                (log 0.0001)
                                (- classMaximum classMinimum))))
    
(defun numeric-col(data)
  (let* ((columns)
         (i 0)
         (cols (table-columns data)))
         (dolist (per-col cols columns)
           (if (numericp (header-name per-col))
               (setf columns (append columns (list i))))
           (incf i))))
