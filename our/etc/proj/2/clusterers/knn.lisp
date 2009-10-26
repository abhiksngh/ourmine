(defun doNothing (table &rest func)
  table)

(deftest test-nothing()
     (multiple-value-bind (train test) (doNothing (ar3) (ar3))
       (check
         (equal
          (eg-features (nth 1 (table-all (xindex (ar3)))))
          (eg-features (nth 1 (table-all (xindex train))))))))

(defun doNothing (test train &rest func)
  (values test train))

(defun addLists (list1 list2)
  (let* ((returnList (make-list 4)))
    (doitems (per-list1 i list1 returnList)
      (setf (nth i returnList) (+ per-list1 (nth i list2))))))

(defun knn-learn(trainList testList
                  &key (prep #'numval1)
                       (norm #'normalizedatatrainandtest)
                       (k    8)
                       (rowReducer #'donothing)
                       (discretizer #'equal-width-train-test)
                       (classify  #'nb))
  (when (not (listp trainList))
    (setf trainList (list trainList)))
  (when (not (listp testList))
    (setf testList (list testList)))
  (doitems (per-data-train i trainList)
    (let* ((trainSet (if (tablep per-data-train)
                         per-data-train
                         (funcall per-data-train)))
           (testSet (if (tablep (nth i testList))
                        (nth i testList)
                        (funcall (nth i testList))))
           (trainSet (funcall prep trainSet))
           (testSet (funcall prep testSet))
           (resultSet)
           (trueResult (make-list 4 :initial-element 0))
           (falseResult (make-list 4 :initial-element 0)))
      (multiple-value-bind (trainSet testSet)
          (funcall norm trainSet testSet)
        (setf trainSet (funcall rowReducer trainSet testSet))
        (multiple-value-bind (trainSet testSet)
            (funcall discretizer trainSet testSet)
          (print trainSet)
          (doitems (per-test i (table-all testSet))
            (let* ((nearestTrain (subseq (dolist (each-item (k-nearest-per-instance per-test trainSet) resultSet)
                                   (push (eg-features(nth (first each-item) (table-all trainSet))) resultSet)) 0 (1- k)))
                   (currentTrainSet (build-a-data (table-name trainSet) (columns-header (table-columns trainSet)) nearestTrain))
                   (currentTestSet (build-a-data (table-name testSet) (columns-header (table-columns testSet)) (list (eg-features per-test)))))
              (multiple-value-bind (trueAnswer falseAnswer) (funcall classify currentTrainSet currentTestSet)
                (progn
                  (setf trueResult (addLists trueResult trueAnswer))
                  (setf falseResult (addLists falseResult falseAnswer))))))))
      (printLine t 'TRUE trueResult)
      (printLine t 'FALSE falseResult))))
        
(defun k-nearest-per-instance(instance table &optional (distfunc #'eucDistance))
  ;;Set the class to a numeric, so we don't have to build code to handle a single discrete at the end of a line.  This zero will have no impact on the distance.
  (let* ((instance (eg-features instance))
         (xtable (xindex table))
         (data (table-all xtable))
         (resultHash (make-hash-table))
         (cozyNeighborList))
    ;;Populate a hash table of distances from the instance to all neighbors.
    (doitems (per-instance i data)
      (let* ((per-instance-features (eg-features per-instance))
             (distanceList))
         (doitems (per-attribute n per-instance-features)
           (if (numericp (nth n (columns-header (table-columns xtable))))
               (push (- (nth n instance) per-attribute) distanceList)
               (if (equal (nth n instance) per-attribute)
                   (push 0 distanceList)
                   (push 1 distanceList)))
           (setf (gethash i resultHash) (funcall distfunc distanceList)))))
      ;;Create a list of the k closest neighbors. Working the Lisp-fu.
      (maphash #'(lambda (key value)
                   (if (not(= value 0))
                       (setf cozyNeighborList (append (list (list key value)) cozyNeighborList))))
               resultHash)
      (sort cozyNeighborList #'< :key #'second)))

(deftest test-knear()
  (let* ((train  (xindex(build-a-data 'TRAIN (list '$a '$b '$c '$d) (list
                                                       '(1 1 1 1)
                                                       '(1.1 1.1 1.1 1.1)
                                                       '(1.2 1.2 1.2 1.2)
                                                       '(1.3 1.3 1.3 1.3)
                                                       '(1.4 1.4 1.4 1.4)
                                                       '(1.5 1.5 1.5 1.5)
                                                       '(1.6 1.6 1.6 1.6)
                                                       '(1.7 1.7 1.7 1.7)
                                                       '(1.8 1.8 1.8 1.8)
                                                       '(1.9 1.9 1.9 1.9)
						       '(2.0 2.0 2.0 2.0)
						       '(5 5 5 5)))))
         (test  (xindex(build-a-data 'TEST (list '$a '$b '$c '$d) (list
							'(1 1 1 1))))))
    (check
      (equal
       (k-nearest-per-instance (nth 0 (table-all test)) train)
       '((10 0.20000005) (9 0.4000001) (8 0.5999999) (7 0.79999995) (6 1.0)
 (5 1.2) (4 1.4000001) (3 1.5999999) (2 1.8) (1 2.0) (0 8.0))))))
       

;;Burak Filter
(defun burak(train test)
  (let* ((xtrain (xindex train))
         (xtest (table-all(xindex test)))
         (tmp)
         (returnData)
         )
    (doitems (per-instance i xtest returnData)
      (let* ((nearest-neighbors (k-nearest-per-instance per-instance xtrain))
             (nearest-neighbors (if (< (length nearest-neighbors) 10)
                                    nearest-neighbors
                                    (subseq nearest-neighbors 0 10))))
        (doitems (per-neighbor j nearest-neighbors)
          (let* ((neighbor (eg-features (nth (first per-neighbor) (table-all xtrain)))))
            (if (null (member neighbor tmp))
                (push neighbor tmp))))
        (setf returnData (build-a-data (table-name xtrain) (columns-header (table-columns xtrain)) tmp))))))

(deftest test-burak()
  (let* ((test (build-a-data 'TRAIN (list '$a '$b '$c '$d) (list
                                                       (list 1 1 1 1)
                                                       (list 1.1 1.1 1.1 1.1)
                                                       (list 1.2 1.2 1.2 1.2)
                                                       (list 1.3 1.3 1.3 1.3)
                                                       (list 1.4 1.4 1.4 1.4)
                                                       (list 1.5 1.5 1.5 1.5)
                                                       (list 1.6 1.6 1.6 1.6)
                                                       (list 1.7 1.7 1.7 1.7)
                                                       (list 1.8 1.8 1.8 1.8)
                                                       (list 1.9 1.9 1.9 1.9)
                                                       (list 2.0 2.0 2.0 2.0)
                                                       (list 5 5 5 5))))
         (train (build-a-data 'TEST (list '$a '$b '$c '$d) (list
                                                        (list 1 1 1 1))))
         (result (burak test train)))
    (and
     (check
       (eql
        (length (table-all (xindex result)))
        10))
     (check (not (member (list 5 5 5 5) (features-as-a-list (xindex result))))))))
        
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
  (let* ((combinedDataSet (nvalues 1.0 train test))
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
  (multiple-value-bind (train test) (seg-shared-kc1)
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
