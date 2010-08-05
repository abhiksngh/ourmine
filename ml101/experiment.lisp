; incremental learning in eras of size X

; n-repeats with 66%

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

  
; clone the table
; all the trains go into the table
; start from a certain offset
(defun traintest (bin &key (tbl0 (thetable)) (bins bin)
		  (preprocess #'noop)  (train #'noop) (ready #'noop)
		  (tester #'noop) (reporter #'noop))
  (let (tests (tmp bins))
    (funcall preprocess tbl0)
    (doitems (row i (therows tbl0))
      (cond ((< i bin) (funcall train row i))
	    ((= i bin) (push row tests))
	    ((> i bin) (decf tmp)
	               (cond ((zerop tmp) (setf tmp bins)
			                  (push row tests))
			     (t (funcall train row i))))))
    (funcall ready)
    (mapc tester (reverse tests))
    (funcall reporter)))

(defun clone-table (tbl)
  (make-table :name (table-name tbl)
	      :cols (mapcar #'clone-col (table-cols tbl))))

(defmethod clone-col ((col num))
  (make-num :name (col-name col) :goalp (col-goalp col)))

(defmethod clone-col ((col sym))
  (make-sym :name (col-name col) :goalp (col-goalp col)))

(deftest !traintest0 (&optional (bins 3))
  (let* (tbl
	 (result
	  (with-output-to-string (s)
	   (labels ((zap   (tbl0)   (setf tbl (clone-table tbl0)))
		    (train (row i)  (show row `(train ,i)))
		    (test  (row)    (show row 'test  ))
		    (show (row  pre)
		      (print `(,pre  ,(row-cells row)) s)))
	     (data)
	     (dotimes (bin bins)
	       (terpri s)
	       (traintest bin :preprocess #'zap :bins bins
			      :train #'train :tester #'test))))))
    (test result
	" ((TRAIN 1) (RAINY MILD HIGH TRUE NO)) 
	  ((TRAIN 2) (SUNNY MILD HIGH FALSE NO)) 
	  ((TRAIN 4) (RAINY COOL NORMAL TRUE NO)) 
	  ((TRAIN 5) (OVERCAST HOT NORMAL FALSE YES)) 
	  ((TRAIN 7) (RAINY MILD NORMAL FALSE YES)) 
	  ((TRAIN 8) (SUNNY COOL NORMAL FALSE YES)) 
	  ((TRAIN 10) (OVERCAST HOT HIGH FALSE YES)) 
	  ((TRAIN 11) (RAINY COOL NORMAL FALSE YES)) 
	  ((TRAIN 13) (RAINY MILD HIGH FALSE YES)) 
	  (TEST (SUNNY HOT HIGH TRUE NO)) 
	  (TEST (SUNNY HOT HIGH FALSE NO)) 
	  (TEST (SUNNY MILD NORMAL TRUE YES)) 
	  (TEST (OVERCAST COOL NORMAL TRUE YES)) 
	  (TEST (OVERCAST MILD HIGH TRUE YES)) 
	  
	  ((TRAIN 0) (SUNNY HOT HIGH TRUE NO)) 
	  ((TRAIN 2) (SUNNY MILD HIGH FALSE NO)) 
	  ((TRAIN 3) (SUNNY HOT HIGH FALSE NO)) 
	  ((TRAIN 5) (OVERCAST HOT NORMAL FALSE YES)) 
	  ((TRAIN 6) (SUNNY MILD NORMAL TRUE YES)) 
	  ((TRAIN 8) (SUNNY COOL NORMAL FALSE YES)) 
	  ((TRAIN 9) (OVERCAST COOL NORMAL TRUE YES)) 
	  ((TRAIN 11) (RAINY COOL NORMAL FALSE YES)) 
	  ((TRAIN 12) (OVERCAST MILD HIGH TRUE YES)) 
	  (TEST (RAINY MILD HIGH TRUE NO)) 
	  (TEST (RAINY COOL NORMAL TRUE NO)) 
	  (TEST (RAINY MILD NORMAL FALSE YES)) 
	  (TEST (OVERCAST HOT HIGH FALSE YES)) 
	  (TEST (RAINY MILD HIGH FALSE YES)) 
	  
	  ((TRAIN 0) (SUNNY HOT HIGH TRUE NO)) 
	  ((TRAIN 1) (RAINY MILD HIGH TRUE NO)) 
	  ((TRAIN 3) (SUNNY HOT HIGH FALSE NO)) 
	  ((TRAIN 4) (RAINY COOL NORMAL TRUE NO)) 
	  ((TRAIN 6) (SUNNY MILD NORMAL TRUE YES)) 
	  ((TRAIN 7) (RAINY MILD NORMAL FALSE YES)) 
	  ((TRAIN 9) (OVERCAST COOL NORMAL TRUE YES)) 
	  ((TRAIN 10) (OVERCAST HOT HIGH FALSE YES)) 
	  ((TRAIN 12) (OVERCAST MILD HIGH TRUE YES)) 
	  ((TRAIN 13) (RAINY MILD HIGH FALSE YES)) 
	  (TEST (SUNNY MILD HIGH FALSE NO)) 
	  (TEST (OVERCAST HOT NORMAL FALSE YES)) 
	  (TEST (SUNNY COOL NORMAL FALSE YES)) 
	  (TEST (RAINY COOL NORMAL FALSE YES)) "
    )))

