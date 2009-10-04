;;; Claimee: Tim
;; Classifiers make decisions. 

(print " - Loading TwoR") ;; Output for a pretty log

(load "lib/loaddeps")
(load "utils/utils")
(load "d-data/weathernumerics.lisp")

(defparameter w (weather-numerics))

(defun majority-class(tbl)
  "Names the majority class of a dataset"
  (let ((classes (count-classes tbl))
	(greatest '()))
    (dolist (class classes (car greatest))
      (if
       (null greatest)
       (setf greatest class)
       (progn
	 (if
	  (< (nth 1 greatest) (nth 1 class))
	  (setf greatest class)))))))
	 
(defun oner(tbl)
  (let* 
      ((cols (columns-header (table-columns tbl)))
       (counts (mapcar #'cons cols (list-unique-features tbl)))
       (maj-class (majority-class tbl)))
    (dolist (col cols)
      (let ((found '()))
	








; use (rowclass tbl N) later on when traveling down columns


   



;;for each column a
;;;;;;for each value, v, in a
;;;;;;;;;;