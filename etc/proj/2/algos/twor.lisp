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
  (mapcar 'eg-features ((lambda (x) (let ((y '())) (dolist (l (egs x) y) (if (eql (majority-class x) (eg-class l)) (push l y))))) tbl)))
	
 
 (defun oner(tbl)
  (let* 
      ((cols (columns-header (table-columns tbl)))
        (major-features (majority-class-list tbl))
       (counts-all '())
       (i 0))
    (dolist (col (reverse (cdr (reverse cols)))) ;for each column
      (let ((counts '()))
	(dolist (l major-features) ; for each instance
	  (let ((this (nth i l)))
	    (if (null counts) ; is it a new list? then put in first value w/ '1'
		(push (cons this 1) counts)
	      (if (null (assoc this counts)) ;this isn't in the list yet
		  (push (cons this 1) counts) ; add it
		  (incf (cdr (assoc this counts)))))))
	(incf i)
	(push (cons col counts) counts-all)))
    (reverse counts-all)

    ;We use accuracy to store the counts for each column
    (let ((accuracy '())

	  ; j allows us to iterate over list in 'feats'
	  (j 0)
	  ; feats represents all observed features.
	  ; feats contains a list for each column (attribute)
	  ; each list stores an assoc list of the attr values and
	  ; how many times each one appeared.
	  (feats (list-unique-features tbl))
	  (cols (columns-header (table-columns tbl))))
      ; col is the column we are classifying 
      (dolist (col (reverse (cdr (reverse cols)))) ; drop the classes column, put back in order...
	; the jist of this method is to iterate over each column of attributes
	; Find out how many times an attribute value appeared over all
	; Find out how many tmes an attribute value appeared in the target class
	; This dolist will loop for each column

	(let*
	    ; select the present working column, j, from the full set
	    ((these-tokens-tuples (nth j feats))
	     (these-tokens (mapcar 'car these-tokens-tuples)) ; list of observed attr values in this column
	     (class-count-list (cdr (assoc col counts-all)))) ; list of the counts of class intances in this column

	  ;(print these-tokens-tuples)    ; like this: ((RAINY 5) (OVERCAST 4) (SUNNY 5))
	  ;(print (cdr (assoc col counts-all))) ; like this: ((SUNNY . 2) (RAINY . 3) (OVERCAST . 4))

	  (dolist
	      (this-token these-tokens)
	    (let* 
		((full-count (nth 1 (assoc this-token these-tokens-tuples)))
		 (class-count (cdr (assoc this-token class-count-list)))
		 (measure (/ class-count full-count)))
	      (format t "Occurrences of: ~A~% Total: ~A;    Class: ~A~%" this-token full-count class-count))))
	    
	(incf j)))))
      

