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

(defun majority-class-list (tbl)
  "Return a list containing features of instances in the majority class"
  (mapcar 'eg-features ((lambda (x) (l
et ((y '())) (dolist (l (egs x) y) (if (eql (majority-class x) (eg-class l)) (push l y))))) tbl)))
	 
(defun oner(tbl)
  (let* 
      ((cols (columns-header (table-columns tbl)))
       (maj-class (majority-class tbl))
       (major-features (majority-class-list tbl))
       (counts-all '())
       (i 0))
    (dolist (col (reverse (cdr (reverse cols)))) ;for each column
      (let ((counts '()))
	(dolist (l major-features) ; for each instance
	  (let ((this (nth i l)))
	    (print this)
	    (if (null counts) ; is it a new list? then put in first value w/ '1'
		(push (cons this 1) counts)
	      (if (null (assoc this counts)) ;this isn't in the list yet
		  (push (cons this 1) counts) ; add it
		  (incf (cdr (assoc this counts)))))))
	(incf i)
	(push (cons col counts) counts-all)))
    counts-all))








; use (rowclass tbl N) later on when traveling down columns


   



;;for each column a
;;;;;;for each value, v, in a
;;;;;;;;;;