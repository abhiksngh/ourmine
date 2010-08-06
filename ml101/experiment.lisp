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
; all the trains go into the tableex
; start from a certain offset

(defun traintest (bin &key (tbl0 (thetable)) (bins bin) rigs)
  (let (tests
	(tmp bins)
	(learners (if (consp rigs) rigs (list rigs))))
    (labels ((_preprocess (l) (funcall (rig-preprocess l) tbl0))
	     (_train (row i)  (mapc #'(lambda (l)
				      (funcall (rig-train l) row i))
				  learners))
	     (_ready (l) (funcall (rig-ready l)))
	     (_tester (test) (mapc #'(lambda (l)
				      (funcall (rig-tester l) test))
				  learners))
	     (_reporter (l) (funcall (rig-reporter l))))
      (mapc #'_preprocess learners)
      (doitems (row i (therows tbl0))
	(cond ((< i bin) (_train row i))
	      ((= i bin) (push row tests))
	      ((> i bin) (decf tmp)
	                 (cond ((< tmp 1)   (setf tmp bins)
		                            (push row tests))
		               (t           (_train row i))))))
      (mapc #'_ready    learners)
      (mapc #'_tester   (reverse tests))
      (mapcar #'_reporter learners))))

(defun clone-table (tbl)
  (make-table :name (table-name tbl)
	      :cols (mapcar #'clone-col (table-cols tbl))))

(defmethod clone-col ((col num))
  (make-num :name (col-name col) :goalp (col-goalp col)))

(defmethod clone-col ((col sym))
  (make-sym :name (col-name col) :goalp (col-goalp col)))

(defun !traintest0-rig (s)
  (let (tbl)
    (labels ((zap   (tbl0)   (setf tbl (clone-table tbl0)))
	     (train (row i)  (show row `(train ,i)))
	     (test  (row)    (show row 'test  ))
	     (show (row  pre)
	       (print `(,pre  ,(row-cells row)) s)))
      (make-rig :preprocess #'zap :train #'train :tester #'test))))

(deftest !traintest0 (&aux (bins 3) (xval t))
  (test
   (with-output-to-string (s)
     (let ((rig (!traintest0-rig s)))
       (reset-seed)
       (data)
       (if xval
	   (dotimes (bin bins)
	     (terpri s)
	     (traintest bin :bins bins :rigs rig))
	   (traintest 0 :bins bins :rigs rig))))
   "

((TRAIN 1) (RAINY COOL NORMAL TRUE NO)) 
((TRAIN 2) (RAINY MILD HIGH TRUE NO)) 
((TRAIN 4) (SUNNY HOT HIGH FALSE NO)) 
((TRAIN 5) (OVERCAST MILD HIGH TRUE YES)) 
((TRAIN 7) (SUNNY COOL NORMAL FALSE YES)) 
((TRAIN 8) (RAINY COOL NORMAL FALSE YES)) 
((TRAIN 10) (OVERCAST HOT NORMAL FALSE YES)) 
((TRAIN 11) (RAINY MILD NORMAL FALSE YES)) 
((TRAIN 13) (SUNNY MILD NORMAL TRUE YES)) 
(TEST (SUNNY MILD HIGH FALSE NO)) 
(TEST (SUNNY HOT HIGH TRUE NO)) 
(TEST (OVERCAST HOT HIGH FALSE YES)) 
(TEST (RAINY MILD HIGH FALSE YES)) 
(TEST (OVERCAST COOL NORMAL TRUE YES)) 

((TRAIN 0) (SUNNY MILD HIGH FALSE NO)) 
((TRAIN 2) (RAINY MILD HIGH TRUE NO)) 
((TRAIN 3) (SUNNY HOT HIGH TRUE NO)) 
((TRAIN 5) (OVERCAST MILD HIGH TRUE YES)) 
((TRAIN 6) (OVERCAST HOT HIGH FALSE YES)) 
((TRAIN 8) (RAINY COOL NORMAL FALSE YES)) 
((TRAIN 9) (RAINY MILD HIGH FALSE YES)) 
((TRAIN 11) (RAINY MILD NORMAL FALSE YES)) 
((TRAIN 12) (OVERCAST COOL NORMAL TRUE YES)) 
(TEST (RAINY COOL NORMAL TRUE NO)) 
(TEST (SUNNY HOT HIGH FALSE NO)) 
(TEST (SUNNY COOL NORMAL FALSE YES)) 
(TEST (OVERCAST HOT NORMAL FALSE YES)) 
(TEST (SUNNY MILD NORMAL TRUE YES)) 

((TRAIN 0) (SUNNY MILD HIGH FALSE NO)) 
((TRAIN 1) (RAINY COOL NORMAL TRUE NO)) 
((TRAIN 3) (SUNNY HOT HIGH TRUE NO)) 
((TRAIN 4) (SUNNY HOT HIGH FALSE NO)) 
((TRAIN 6) (OVERCAST HOT HIGH FALSE YES)) 
((TRAIN 7) (SUNNY COOL NORMAL FALSE YES)) 
((TRAIN 9) (RAINY MILD HIGH FALSE YES)) 
((TRAIN 10) (OVERCAST HOT NORMAL FALSE YES)) 
((TRAIN 12) (OVERCAST COOL NORMAL TRUE YES)) 
((TRAIN 13) (SUNNY MILD NORMAL TRUE YES)) 
(TEST (RAINY MILD HIGH TRUE NO)) 
(TEST (OVERCAST MILD HIGH TRUE YES)) 
(TEST (RAINY COOL NORMAL FALSE YES)) 
(TEST (RAINY MILD NORMAL FALSE YES)) "
))


(defun experiments (learners &key f (bins 3) debug (xval t))
  (let (out
	(rigs (mapcar #'(lambda (l) (funcall l debug)) learners)))
    (data f)
    (if xval
	(dotimes (bin bins)
	  (push  (traintest bin :bins   bins :rigs rigs) out))
	(push (traintest 0 :bins bins :rigs rigs) out))
    out))

(defun !experiments0 ()
  (let ((learners (list #'zeror-rig #'nb-rig)))
    (dolist (each-bin (experiments learners :debug t))
      (dolist (each-learner each-bin)
	(showh each-learner :stream t)))))