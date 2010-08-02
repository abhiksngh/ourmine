; incremental learning in eras of size X

; n-way stratified cross-val

; leave one-out

(defun randomize ()
  (when (thetable)
    (dolist (row (therows))
      (jiggle-the-sortkey row))
    (sort-rows)))

(defun jiggle-the-sortkey (row)
  "for stuff with numeric classes, the sortkey must be selected
   such that adding 0<=r < 0.49 moves things no more than 1/bins
   in the sort order"
  (setf (row-sortkey row)
	(+ (randf 0.49)
	   (round (row-sortkey row)))))
; self test

(defun abcd (nums)
  (with-slots ( a b c d acc pf prec pd f) nums
    (let ((zip (expt 10 -31)))
      (print 1)
      (setf acc  (float (/ (+ a d) (+ zip a b c d))))
      (setf pf   (float (/ c       (+ zip a c    ))))
      (setf prec (float (/ d       (+ zip c d    ))))
      (setf pd   (float (/ d       (+ zip b d    ))))
      (setf f    (float (/ (* 2 prec pd) (+ zip prec pd))))))
  nums)
  
; clone the table
; all the trains go into the table
; start from a certain offset
(defun traintest (bin &key (bins bin)
		  (train #'noop) (ready #'noop)
		  (tester #'noop) (reporter #'noop))
  (let ((tmp bins)
	test
	(results (make-results))
	(tbl (clone-table (thetable))))
    (doitems (row i (therows))
       (cond ((< i bin) (funcall train tbl row i))
	     ((= i bin) (push row test))
	     ((> i bin) (decf tmp)
	                (cond ((zerop tmp) (setf tmp bins)
			                   (push row test))
			      (t (funcall train tbl row i))))))
    (funcall ready tbl)
    (doitems (row i (reverse test))
      (funcall tester tbl row results))
    (funcall reporter tbl results)))

(deftest !traintest0 (&optional (bins 3))
  (let ((result
	 (with-output-to-string (s)
	   (labels ((train (tbl row i)       (show tbl row i :train ))
		    (test  (tbl row results) (show tbl results row '- :test  ))
		    (show (tbl row results i pre)
		      (declare (ignore tbl results))
		      (print `(,pre ,i ,(row-cells row)) s)))
	     (data)
	     (dotimes (bin bins)
	       (terpri s)
	       (traintest bin :bins bins :train #'train  :tester #'test))))))
    (test result
	 "(:TRAIN 1 (RAINY COOL NORMAL TRUE NO)) 
	  (:TRAIN 2 (RAINY MILD HIGH TRUE NO)) 
	  (:TRAIN 4 (SUNNY HOT HIGH FALSE NO)) 
	  (:TRAIN 5 (OVERCAST MILD HIGH TRUE YES)) 
	  (:TRAIN 7 (SUNNY COOL NORMAL FALSE YES)) 
	  (:TRAIN 8 (RAINY COOL NORMAL FALSE YES)) 
	  (:TRAIN 10 (OVERCAST HOT NORMAL FALSE YES)) 
	  (:TRAIN 11 (RAINY MILD NORMAL FALSE YES)) 
	  (:TRAIN 13 (SUNNY MILD NORMAL TRUE YES)) 
	  (:TEST - (SUNNY MILD HIGH FALSE NO)) 
	  (:TEST - (SUNNY HOT HIGH TRUE NO)) 
	  (:TEST - (OVERCAST HOT HIGH FALSE YES)) 
	  (:TEST - (RAINY MILD HIGH FALSE YES)) 
	  (:TEST - (OVERCAST COOL NORMAL TRUE YES)) 
	  
	  (:TRAIN 0 (SUNNY MILD HIGH FALSE NO)) 
	  (:TRAIN 2 (RAINY MILD HIGH TRUE NO)) 
	  (:TRAIN 3 (SUNNY HOT HIGH TRUE NO)) 
	  (:TRAIN 5 (OVERCAST MILD HIGH TRUE YES)) 
	  (:TRAIN 6 (OVERCAST HOT HIGH FALSE YES)) 
	  (:TRAIN 8 (RAINY COOL NORMAL FALSE YES)) 
	  (:TRAIN 9 (RAINY MILD HIGH FALSE YES)) 
	  (:TRAIN 11 (RAINY MILD NORMAL FALSE YES)) 
	  (:TRAIN 12 (OVERCAST COOL NORMAL TRUE YES)) 
	  (:TEST - (RAINY COOL NORMAL TRUE NO)) 
	  (:TEST - (SUNNY HOT HIGH FALSE NO)) 
	  (:TEST - (SUNNY COOL NORMAL FALSE YES)) 
	  (:TEST - (OVERCAST HOT NORMAL FALSE YES)) 
	  (:TEST - (SUNNY MILD NORMAL TRUE YES)) 
	  
	  (:TRAIN 0 (SUNNY MILD HIGH FALSE NO)) 
	  (:TRAIN 1 (RAINY COOL NORMAL TRUE NO)) 
	  (:TRAIN 3 (SUNNY HOT HIGH TRUE NO)) 
	  (:TRAIN 4 (SUNNY HOT HIGH FALSE NO)) 
	  (:TRAIN 6 (OVERCAST HOT HIGH FALSE YES)) 
	  (:TRAIN 7 (SUNNY COOL NORMAL FALSE YES)) 
	  (:TRAIN 9 (RAINY MILD HIGH FALSE YES)) 
	  (:TRAIN 10 (OVERCAST HOT NORMAL FALSE YES)) 
	  (:TRAIN 12 (OVERCAST COOL NORMAL TRUE YES)) 
	  (:TRAIN 13 (SUNNY MILD NORMAL TRUE YES)) 
	  (:TEST - (RAINY MILD HIGH TRUE NO)) 
	  (:TEST - (OVERCAST MILD HIGH TRUE YES)) 
	  (:TEST - (RAINY COOL NORMAL FALSE YES)) 
	  (:TEST - (RAINY MILD NORMAL FALSE YES)) "
	  )))
	
(defun clone-table (tbl)
  (make-table :name (table-name tbl)
	      :cols (mapcar #'clone-col (table-cols tbl))))

(defmethod clone-col ((col num))
  (make-num :name (col-name col) :goalp (col-goalp col)))

(defmethod clone-col ((col sym))
  (make-sym :name (col-name col) :goalp (col-goalp col)))
