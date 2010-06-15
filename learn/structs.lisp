(defstruct data name columns rows)

(defstruct row  (id 0) cells)

(defstruct column name goalp)

(defstruct (num  (:include column)))
(defstruct (word  (:include column)))

(defun goalp    (x) (thingp x #\!))
(defun nump     (x) (thingp x #\$))
(defun ignorep  (x) (thingp x #\?))
(defun thingp (x y) (and (symbolp x) (find y (symbol-name x))))

(defun data (&key name columns rows)
  (make-data :name name 
	     :rows (make-rows rows)
	     :columns (mapcar #'about-column columns))

(defun make-rows (rows &aux (n 0))
  (mapcar #'(lambda (cells)
	      (make-row :cells cells 
			:id (incf n)))
	  rows))

(defun about-column (col)
  (if (nump col)
      (make-num  :name col :goalp (goalp col))
      (make-word :name col :goalp (goalp col))))

(let ((h (make-hash-table :test 'equal)))
  (defun euclid (row1 row2 name cols)
    (let* ((id1 (row-id row1))
	   (id2 (row-id row2)))
      (if (> id1 id2)
	  (euclid row2 row1 name cols)
	  (let ((key `(,name ,id1 ,id2)))
	    (or (gethash  key h)
		(setf (gethash key h) 
		      (euclid1 (row-cells row1)
			       (row-cells row2))))))))
)

(defun euclid1 (cells1 cells2 name cols &aux (sum 0))
  (mapc #'(lambda (col cell1 cell2)
	    (incf sum (euclid2 col cell1 cell2)))
	cols cells1 cells2)
  (/ (sqrt sum)  (sqrt (length r1))))

(defmethod euclid2 ((n num) n1 n2)  (expt (- n1 n2) 2))
(defmethod euclud2 ((w word) w1 w2) (if (eql w1 w2) 0 1))

(defun closest (rows cols)
  (let* ((one     (car rows))
	 (others  (cdr rows)))
    (cons one     
	  (sort others 
		#'(lambda (row1 row2) 
		    (< (euclid row1 one) 
		       (euclid row2 one)))))))
; do copu list once
(defun pairs (rows cols)
  (let ((sorted (closest name rows cols))
	(one (pop sorted))
	(two (pop sorted))
	(rest sorted))
    (cons `(,one ,two)
	  (pairs rest name cols))))
