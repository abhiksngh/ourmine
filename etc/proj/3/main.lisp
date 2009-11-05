;; Main
;; This file loads the basic function for each of our data mining techniques
;; and defuns the learn function - which executes them based on function passing

(print "Loading Utility Libraries...")
(load "lib/loaddeps")
(load "utils/utils")
(print "Complete.")

(print "Loading Pre-processors...")
(load "algos/subsample")
(load "algos/normalize")
(print "Complete.")

(print "Loading Discretizers...")
(load "algos/nbins")
(load "algos/binlogging")
(load "algos/nchops")
(print "Complete.")

(print "Loading Clusterers...")
(load "algos/genic")
(load "algos/kmeans")
(print "Complete.")

(print "Loading Feature Subset Selectors...")
(load "algos/relief")
(load "algos/infogain")
(print "Complete.")

(print "Loading Classifiers...")
(load "algos/naivebayes")
;;(load "algos/twor")
(suppress-style-warnings (load "algos/2b"))
;;(load "algos/prism")
(print "Complete.")

(print "Loading Data...")
(load "d-data/weathernumerics")
(load "d-data/boston-housing")
(load "d-data/mushroom")
(print "Complete.")

