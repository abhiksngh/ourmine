(load "miner")
(load "utils")
(load "normalize")
(load "kmeans")
(load "gac")
(load "cluster")
(load "tests/data/weather2")
(load "tests/data/vehicle")
(load "tests/data/additionalbolts")

(defun learn (&key (k            8)
                   (prep         #'normalize)
;                  (discretizer  #'nbins)
                   (cluster      #'kmeans)
;                  (fss          #'b-squared)
;                  (classify     #'ekrem)
                   (train        "tests/train.lisp")
                   (test         "tests/test.lisp"))
      
  (load train)
  (load test))
                                        ; then run the discretizer
    
     ; the do FSS on each cluster 
     ; then on the remaining attributes, train a classifier for each cluster
     ; then for all example in the test set
     ;     ... find the cluster with the nearest centroid...
     ;     ... classify that example  using that cluster's classifie
