(defstruct
    (cluster
      (:constructor new-cluster (centroid)))
  centroid nodes)

(defun kmeans-learn (trainList testList &key
                     (prep #'numval1)
                     (norm #'normalizedatatestandtrain)
                     (k 8)
                     (init-method #'kmeans-init-centroids)
                     (rowReducer #'donothing)
                     (discretizer #'equal-width-train-test)
                     (classify #'nb))
  (let* ((k-list (make-list k)))
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
                    (trueResult (make-list 4 :initial-element 0))
                    (falseResult (make-list 4 :initial-element 0)))
               (multiple-value-bind (trainSet testSet)
                   (funcall norm trainSet testSet)
                 (setf trainSet (funcall rowReducer trainSet testSet))
                 (multiple-value-bind (trainSet testSet)
                     (funcall discretizer trainSet testSet)



(defun kmeans++-init-centroids(k k-list train)
  (let* ((initial-point (random (length (table-all (xindex train))))))
    (setf (cluster-centroid (nth 0 k-list)) initial-point))
  (dotimes (i (1- k) k-list)
    (let* ((distanceList (knn-per-instance (cluster-centroid (nth i k-list)) train)))


(defun kmeans-init-centroids(k k-list train)
  (doitems (per-cluster i k-list k-list)
           (setf (cluster-centroid (nth i k-list)) (nth (random (length (table-all (xindex train))))))))
