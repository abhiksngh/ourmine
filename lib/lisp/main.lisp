(defun learn (&key (k            8)
                   (prep         #'normalize)
                   (discretizer  #'nbins)
                   (cluster      #'kmeans)
                   (fss          #'b-squared)
                   (classify     #'ekrem)
                   (train        "train.lisp")
                   (test         "test.lisp"))
      (let ((training (load train))
           ((testing  (load test)))
 
            (funcall prep training)
            (funcall prep testing)
     ; then run the discretizer
     ; then cluster the training set into k clusters
     ; the do FSS on each cluster 
     ; then on the remaining attributes, train a classifier for each cluster
     ; then for all example in the test set
     ;     ... find the cluster with the nearest centroid...
     ;     ... classify that example  using that cluster's classifier
