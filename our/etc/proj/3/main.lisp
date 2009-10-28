(load "miner")
;(load "tests/data/primary-tumor")
(load "learn/nb")

(defun learn (&key (k            8)
              (prep         #'normalize)
              ;(discretizer  #'n-chops)
              ;(cluster      #'(lambda (k data) (kmeans k data)))
              ;(fss          #'infoGain)
              ;(classify     #'naiveBayes)
              (train        #'primary-tumor)
              (test         #'primary-tumor))
  (let (
        (training (funcall train))
        (testing  (funcall test))
        (clusters)
        )
    
  
                                        ;      ...
     ; first prep train and test

    (print "preprocessing")
    (setf training (funcall prep training))
    (setf testing (funcall prep testing))
    
     ; then run the discretizer
    (print "discretizing")
    ;(setf training (funcall discretizer training))
    ;(setf testing (funcall discretizer testing))
    
     ; then cluster the training set into k clusters
    (print "clustering")
    ;(setf clusters (cluster training k))
    ;;;(setf clusters training)

    
     ; the do FSS on each cluster
    (print "Feature Select")
    ;(setf clusters (funcall fss clusters 40))

    ;then on the remaining attributes, train a classifier for each cluster

    (print "Classifying")
    
    ;(nb-simple clusters testing)

   ; then for all example in the test set
     ;     ... find the cluster with the nearest centroid...
     ;     ... classify that example  using that cluster's classifier

    ))
