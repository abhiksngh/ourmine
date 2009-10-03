;; Main.lisp
;; This file loads the basic function for each of our data mining techniques
;; and defuns the learn function - which executes them based on function passing

(print "Loading Pre-processors...")
(load subsample.lisp)
(print "Complete.")

(print "Loading Discretizers...")
(load binlogging.lisp)
(print "Complete.")

(print "Loading Clusterers...")
(load genic.lisp)
(print "Complete.")

(print "Loading Feature Subset Selectors..."
(load relief.lisp)
(print "Complete.")

(print "Loading Classifiers...")
(load naivebayes.lisp)
(load twor.lisp)
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
