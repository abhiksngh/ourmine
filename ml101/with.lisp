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
(defun data (&optional f reader)
  (reset-seed)
  (w0) 
  (if reader 
      (setf (wme-! *w*) reader))
  (load (or f (wfile))) 
  (funcall (wme-ready *w*))
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
  (setf (wrows) (sort (wrows) #'< :key #'row-sortkey)))

(defun defklass (class)
  (unless (member class (wklasses) :key #'klass-name)
    (setf (wklasses)
	  (appendl (wklasses) (make-klass :name class)))))

(defun defrow (l &aux (class (car (goals-in-list l))))
  (defklass class)
  (push (make-row :cells   l 
		  :class   class
		  :utility (funcall (wu) class)
		  :sortkey  (+ (randf 0.5) 
			       (position class (wklasses) 
					 :key #'klass-name)))
	(wrows)))

(defun goals-in-list (l)   (mapcan #'1goal-in-list l (wcols)))
(defun 1goal-in-list (x c) (and (col-goalp c) (knownp x) (list x)))   


;;;; testss

(deftest !data () 
  (data) 
  (test (wtable)
" #S(TABLE
                     :NAME WEATHER
                     :ROWS (#S(ROW
                               :CELLS (SUNNY MILD HIGH FALSE NO)
                               :CLASS NO
                               :UTILITY 0
                               :SORTKEY 0.263794998761171d0)
                            #S(ROW
                               :CELLS (RAINY COOL NORMAL TRUE NO)
                               :CLASS NO
                               :UTILITY 0
                               :SORTKEY 0.2808336484156706d0)
                            #S(ROW
                               :CELLS (RAINY MILD HIGH TRUE NO)
                               :CLASS NO
                               :UTILITY 0
                               :SORTKEY 0.4147286442642699d0)
                            #S(ROW
                               :CELLS (SUNNY HOT HIGH TRUE NO)
                               :CLASS NO
                               :UTILITY 0
                               :SORTKEY 0.45606366123820824d0)
                            #S(ROW
                               :CELLS (SUNNY HOT HIGH FALSE NO)
                               :CLASS NO
                               :UTILITY 0
                               :SORTKEY 0.4608172823026857d0)
                            #S(ROW
                               :CELLS (OVERCAST MILD HIGH TRUE YES)
                               :CLASS YES
                               :UTILITY 0
                               :SORTKEY 1.0419332417854728d0)
                            #S(ROW
                               :CELLS (OVERCAST HOT HIGH FALSE YES)
                               :CLASS YES
                               :UTILITY 0
                               :SORTKEY 1.0619544305661481d0)
                            #S(ROW
                               :CELLS (SUNNY COOL NORMAL FALSE YES)
                               :CLASS YES
                               :UTILITY 0
                               :SORTKEY 1.1025441790011452d0)
                            #S(ROW
                               :CELLS (RAINY COOL NORMAL FALSE YES)
                               :CLASS YES
                               :UTILITY 0
                               :SORTKEY 1.200825895974797d0)
                            #S(ROW
                               :CELLS (RAINY MILD HIGH FALSE YES)
                               :CLASS YES
                               :UTILITY 0
                               :SORTKEY 1.2681145252511439d0)
                            #S(ROW
                               :CELLS (OVERCAST HOT NORMAL FALSE YES)
                               :CLASS YES
                               :UTILITY 0
                               :SORTKEY 1.2719946884419744d0)
                            #S(ROW
                               :CELLS (RAINY MILD NORMAL FALSE YES)
                               :CLASS YES
                               :UTILITY 0
                               :SORTKEY 1.4600164722465054d0)
                            #S(ROW
                               :CELLS (OVERCAST COOL NORMAL TRUE YES)
                               :CLASS YES
                               :UTILITY 0
                               :SORTKEY 1.4711289221752104d0)
                            #S(ROW
                               :CELLS (SUNNY MILD NORMAL TRUE YES)
                               :CLASS YES
                               :UTILITY 0
                               :SORTKEY 1.4968490470186104d0))
                     :KLASSES (#S(KLASS :NAME NO :N 0 :A 0 :B 0 :C 0 :D 0)
                               #S(KLASS
                                  :NAME YES
                                  :N 0
                                  :A 0
                                  :B 0
                                  :C 0
                                  :D 0))
                     :COLS (#S(SYM
                               :NAME FORECAST
                               :GOALP NIL
                               :COUNTS {hash of 0 items})
                            #S(SYM
                               :NAME TEMP
                               :GOALP NIL
                               :COUNTS {hash of 0 items})
                            #S(SYM
                               :NAME HUMIDTY
                               :GOALP NIL
                               :COUNTS {hash of 0 items})
                            #S(SYM
                               :NAME WINDY
                               :GOALP NIL
                               :COUNTS {hash of 0 items})
                            #S(SYM
                               :NAME !PLAY
                               :GOALP !
                               :COUNTS {hash of 0 items})))
"))
