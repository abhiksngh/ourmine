(defun learn (&key (k            8)
                   (prep         #'numval)
                   (discretizer  #'equal-width)
                   (cluster      #'(lambda (data) (kmeans k data))) 
                   (fss          #'infoGain)
                   (classify     #'naiveBayes)
                   (train        "train.lisp")
                   (test         "test.lisp"))

;    (let* ((data (ar3))
;           (prep-data (prep data))
;           (disc-data (discretizer prep-data)))
;        (table-all disc-data)
;    )

     (let* ((data (ar3))
            (prep-data (numval data))
            (disc-data (equal-width prep-data nil))
            (all-instances (table-all prep-data)))
         (dolist (per-instance all-instances)
              (let ((all-features (eg-features per-instance)))
                  (dolist (per-feature all-features)
                      (format t "~A " per-feature)
                  )
              )
              (format t "~%")
         )
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
