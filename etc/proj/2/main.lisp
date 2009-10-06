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
;;(load "algos/relief")
(print "Complete.")

(print "Loading Classifiers...")
(load "algos/naivebayes")
;;(load "algos/twor")
(print "Complete.")

(print "Loading Data...")
(load "d-data/weathernumerics")
(load "d-data/boston-housing")
(print "Complete.")

(defun learn (&key 	(k 	10)
			(preprocessor	#'subsample)
			(discretizer	#'binlogging)
			(clusterer	#'genic)
			(fss		"#'relief")
			(classifier	#'naivebayes)
			(train		#'weather-numerics)
			(test		#'weather-numerics))
  (let ((training (funcall train))
    (testing (funcall test)))

    (print "Running Tables through Preprocessor...")
    (setf training (funcall preprocessor training))
    (setf testing (funcall preprocessor testing))
    (print " - Preprocessor Complete.")

    (print "Running Tables through Discretizer...")
    (setf training (funcall discretizer training))
    (setf testing (funcall discretizer testing))
    (print " - Discretizer Complete.")
    (print training)
    (print testing)

    (print "Running Tables through Clusterer...")
    (setf training (funcall clusterer training))
    ;;(setf testing (funcall clusterer testing))
    (print " - Clusterer Complete.")
 
    ;(print "Running FSS...")
    ;(setf training (mapcar fss training))
    ;(setf testing (mapcar fss testing))
    ;(print " - FSS Complete.")
    ; Comment these next two lines when you uncomment the FSS!!!!!!!!!!
    (setf training (list training))
    (setf testing (list testing))

    (print "Running Classifier...")
    (setf testing (mapcar #'(lambda (trainn) (funcall classifier trainn testing)) training))
    (setf testing (testiest-truthiness-list testing #'max))
    (print testing)
    (print "Done.")
  )
)

(learn)
