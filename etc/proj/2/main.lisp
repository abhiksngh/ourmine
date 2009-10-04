;; Main
;; This file loads the basic function for each of our data mining techniques
;; and defuns the learn function - which executes them based on function passing

(print "Loading Utility Libraries...")
(load "lib/loaddeps")
(load "utils/utils")
(print "Complete.")

(print "Loading Pre-processors...")
(load "algos/subsample")
(print "Complete.")

(print "Loading Discretizers...")
(load "algos/nbins")
(load "algos/binlogging")
(print "Complete.")

(print "Loading Clusterers...")
(load "algos/genic")
(print "Complete.")

(print "Loading Feature Subset Selectors...")
(load "algos/relief")
(print "Complete.")

(print "Loading Classifiers...")
(load "algos/naivebayes")
(load "algos/twor")
(print "Complete.")

(defun learn (&key 	(k 	10)
			(preprocessor	#'subsample)
			(discretizer	#'binlog)
			(clusterer	#'genic)
			(fss		#'relief)
			(classifier	#'naivebayes)
			(train		"train.lisp")
			(test		"test.lisp"))
  (let ((training (load train)))
    ((testing (load test)))
    
    
    )
  )
