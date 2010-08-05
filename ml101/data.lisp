;;;; utils
;;; about symbols
(defun thingp (x y) (and (symbolp x) (find y (symbol-name x))))
(defun goalp  (x)   (thingp x (wme-goal *w*)))
(defun nump   (x)   (thingp x (wme-num *w*)))
(defun knownp (x)   (not (eql x (wme-unknown *w*))))

;;; misc
(defun zero (l)       (declare (ignore l)) 0)
(defun noop (&rest l) (declare (ignore l)) t)

;;;; main
;;; reader
(defun data (&optional f)
  (w0) 
  (load (or f (thefile))) 
  (funcall (wme-ready *w*))
  (funcall (wme-run *w*))
  (funcall (wme-report *w*))
)

(defmacro deftable (name &rest cols)
  `(setf (wme-table *w*)
	 (make-table :name ',name 
		     :cols (mapcar #'make-col ',cols))))

(defun make-col (col)
  (if (nump col)
      (make-num :name col :goalp (goalp col))
      (make-sym :name col :goalp (goalp col))))

(defun sort-rows () 
  (setf (therows) (sort (therows) #'< :key #'row-sortkey)))

(defun defklass (class &optional (tbl (thetable)))
  (let ((k (first (member class (theklasses tbl) :key #'klass-name))))
    (unless k
      (setf  (theklasses tbl)
	    (appendl (theklasses tbl) (setf k (make-klass :name class)))))
    k))

(defun defrow (l &optional (tbl (thetable)) &aux (class (car (goals-in-list l))))
  (incf (klass-n (defklass class tbl)))
  (push (make-row :cells   l 
		  :class   class
		  :utility (funcall (theu) class)
		  :sortkey  (+ (randf 0.49) 
			       (position class (theklasses tbl) 
					 :key #'klass-name)))
	(therows tbl)))

(defun goals-in-list (l)   (mapcan #'1goal-in-list l (thecols)))
(defun 1goal-in-list (x c) (and (col-goalp c) (knownp x) (list x)))   

;;;; testss

(deftest !data ()
  (reset-seed)
  (data) 
  (test (thetable)
	"#S(TABLE
   :NAME WEATHER
   :ROWS (#S(ROW
             :CELLS (SUNNY MILD HIGH FALSE NO)
             :CLASS NO
             :UTILITY 0
             :SORTKEY 0.2585191038174379d0)
          #S(ROW
             :CELLS (RAINY COOL NORMAL TRUE NO)
             :CLASS NO
             :UTILITY 0
             :SORTKEY 0.27521698080383394d0)
          #S(ROW
             :CELLS (RAINY MILD HIGH TRUE NO)
             :CLASS NO
             :UTILITY 0
             :SORTKEY 0.40643407928930564d0)
          #S(ROW
             :CELLS (SUNNY HOT HIGH TRUE NO)
             :CLASS NO
             :UTILITY 0
             :SORTKEY 0.44694239671216807d0)
          #S(ROW
             :CELLS (SUNNY HOT HIGH FALSE NO)
             :CLASS NO
             :UTILITY 0
             :SORTKEY 0.45160094544602414d0)
          #S(ROW
             :CELLS (OVERCAST MILD HIGH TRUE YES)
             :CLASS YES
             :UTILITY 0
             :SORTKEY 1.0410945777495766d0)
          #S(ROW
             :CELLS (OVERCAST HOT HIGH FALSE YES)
             :CLASS YES
             :UTILITY 0
             :SORTKEY 1.0607153431365122d0)
          #S(ROW
             :CELLS (SUNNY COOL NORMAL FALSE YES)
             :CLASS YES
             :UTILITY 0
             :SORTKEY 1.1004932973769972d0)
          #S(ROW
             :CELLS (RAINY COOL NORMAL FALSE YES)
             :CLASS YES
             :UTILITY 0
             :SORTKEY 1.1968093818857513d0)
          #S(ROW
             :CELLS (RAINY MILD HIGH FALSE YES)
             :CLASS YES
             :UTILITY 0
             :SORTKEY 1.2627522398599997d0)
          #S(ROW
             :CELLS (OVERCAST HOT NORMAL FALSE YES)
             :CLASS YES
             :UTILITY 0
             :SORTKEY 1.266554799861022d0)
          #S(ROW
             :CELLS (RAINY MILD NORMAL FALSE YES)
             :CLASS YES
             :UTILITY 0
             :SORTKEY 1.4508161515756934d0)
          #S(ROW
             :CELLS (OVERCAST COOL NORMAL TRUE YES)
             :CLASS YES
             :UTILITY 0
             :SORTKEY 1.4617063527177772d0)
          #S(ROW
             :CELLS (SUNNY MILD NORMAL TRUE YES)
             :CLASS YES
             :UTILITY 0
             :SORTKEY 1.4869120755548817d0))
   :KLASSES (#S(KLASS :NAME NO :N 5) #S(KLASS :NAME YES :N 9))
   :COLS (#S(SYM :NAME FORECAST :GOALP NIL :COUNTS {hash of 0 items})
          #S(SYM :NAME TEMP :GOALP NIL :COUNTS {hash of 0 items})
          #S(SYM :NAME HUMIDTY :GOALP NIL :COUNTS {hash of 0 items})
          #S(SYM :NAME WINDY :GOALP NIL :COUNTS {hash of 0 items})
          #S(SYM :NAME !PLAY :GOALP #\! :COUNTS {hash of 0 items}))
   :RESULTS NIL)"))
