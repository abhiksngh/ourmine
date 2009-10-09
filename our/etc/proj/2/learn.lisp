(defun learn (&key (k            8)
                   (prep         #'numval1)
                   (discretizer  #'equal-width)
                   (cluster      #'(lambda (data) (kmeans k data))) 
                   (fss          #'infoGain)
                   (classify     #'naiveBayes)
                   (train        "train.lisp")
                   (test         "test.lisp"))

     (let* ((data (ar3))
            (prep-data (funcall prep data))
            (disc-data (funcall discretizer prep-data nil)))
      disc-data
     )
)

     ; first prep train and test
     ; then run the discretizer
     ; then cluster the training set into k clusters
     ; the do FSS on each cluster 
     ; then on the remaining attributes, train a classifier for each cluster
     ; then for all example in the test set
     ;     ... find the cluster with the nearest centroid...
     ;     ... classify that example  using that cluster's classifier
