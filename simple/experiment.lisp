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

; clone the table
; all the trains go into the table
; start from a certain offset
(defun traintest (&optional (bins 4))
  (let ((start bins) (tmp bins) train test)
    (doitems (row pos (therows))
       (if (> pos start)
	   (cond  ((zerop (decf tmp)) (setf tmp bins)
                                      (push row test))
		  (t                  (push row train)))
	   (if (eql pos bins)
	       (push row test)
	       (push row train))))
    (values train test)))	      
	   
(defun clone-table (tbl)
  (make-table :name (table-name tbl)
	      :cols (mapcar #'clone-col (table-cols tbl))))

(defmethod clone-col ((col num))
  (make-num :name (col-name col) :goalp (col-goalp col)))

(defmethod clone-col ((col sym))
  (make-sym :name (col-name col) :goalp (col-goalp col)))
