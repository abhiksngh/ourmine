(defun nb-rig (debug )
  (let (tbl results  (n 0))
    (labels ((preprocess (tbl0)
	       (setf tbl (clone-table tbl0)))
	     (trains (row i &aux (klass (row-class row)))
	       (incf n)
	       (incf (klass-n (defklass klass tbl)))
	       (if debug (print `(,i ,(row-cells row)) debug))
	       (mapcar #'(lambda (col value) (train col value (row-class row)))
		       (table-cols tbl) (row-cells row)))
	     (train (col value klass)
	       (if (knownp value)
		   (counts col klass value)))
	     (ready ()
	       (setf results  (klasses->results tbl 'nb)))
	     (classify (row)
	       (let* ((actual     (row-class row))
		      (predicted  (most-likely-klass tbl row n)))
		 (if debug
		     (print `(prediction= ,predicted for ,(row-cells row)) debug))
		 (results-add results actual predicted)))
	     (reporter ()
	       (if debug
		   (terpri debug))
	       (results-report results)))
      (make-rig
       :preprocess #'preprocess
       :train      #'trains
       :ready      #'ready
       :tester     #'classify
       :reporter   #'reporter))))

(defun nb (&key f (bins 3) debug (xval t))
  (let (out (learner (nb-rig debug)))
    (data f)
    (if xval
	(dotimes (bin bins)
	  (push  (traintest bin :bins   bins :rigs learner) out))
	(push (traintest 0 :bins bins :rigs learner) out))
    out))

(defmethod counts ((col sym) klass value)
  (incf
   (gethash `(,klass ,(col-name col) ,value)
	    (sym-counts col)
	    0)))

; wrong- need different counts per class
(defmethod counts ((col num) klass value)
  (with-slots (n sum sumsq min max) col
    (incf n)
    (incf sum value)
    (incf sumsq (* value value))
    (setf min (min min value)
	  max (max max value))))

(defun most-likely-klass (tbl row n &optional (m 2) (k 1))
  (let* ((klasses        (table-klasses tbl))
	 (nklasses       (1+ (length klasses)))
         (like           most-negative-fixnum)
         (classification (klass-name (first klasses))))
    (dolist (klass klasses classification)
      (let* ((prior (/ (+ (klass-n klass)  k)
                       (+  n (* k nklasses))))
             (tmp   prior))
	;(o (klass-name klass) prior (row-cells row))
	(mapcar #'(lambda (col value)
		    (unless (col-goalp col)
		      (unless (not (knownp value))
			(let* ((key    `(,(klass-name  klass) ,(col-name col) ,value))
			       (peh    (gethash key (sym-counts col) 0))
			       (ph     (klass-n klass))
			       (delta  (/ (+ peh (* m prior))
					  (+ ph m))))
			  ;(o key value delta)
			  (setf tmp (* tmp delta))))))
		(table-cols tbl)
		(row-cells row))
	(when (> tmp like)
          (setf like tmp
                classification (klass-name klass)))))))


(deftest !nb ()
  (reset-seed)
  (test (with-output-to-string (s)
	  (mapc #'(lambda (rl) (showh (first rl) :stream s))
		(nb :bins 2 :debug s)))
	"
(1 (RAINY COOL NORMAL TRUE NO)) 
(3 (SUNNY HOT HIGH TRUE NO)) 
(5 (OVERCAST MILD HIGH TRUE YES)) 
(7 (SUNNY COOL NORMAL FALSE YES)) 
(9 (RAINY MILD HIGH FALSE YES)) 
(11 (RAINY MILD NORMAL FALSE YES)) 
(13 (SUNNY MILD NORMAL TRUE YES)) 
(PREDICTION= YES FOR (SUNNY MILD HIGH FALSE NO)) 
(PREDICTION= YES FOR (RAINY MILD HIGH TRUE NO)) 
(PREDICTION= YES FOR (SUNNY HOT HIGH FALSE NO)) 
(PREDICTION= YES FOR (OVERCAST HOT HIGH FALSE YES)) 
(PREDICTION= YES FOR (RAINY COOL NORMAL FALSE YES)) 
(PREDICTION= YES FOR (OVERCAST HOT NORMAL FALSE YES)) 
(PREDICTION= YES FOR (OVERCAST COOL NORMAL TRUE YES)) 

(0 (SUNNY MILD HIGH FALSE NO)) 
(2 (RAINY MILD HIGH TRUE NO)) 
(4 (SUNNY HOT HIGH FALSE NO)) 
(6 (OVERCAST HOT HIGH FALSE YES)) 
(8 (RAINY COOL NORMAL FALSE YES)) 
(10 (OVERCAST HOT NORMAL FALSE YES)) 
(12 (OVERCAST COOL NORMAL TRUE YES)) 
(PREDICTION= YES FOR (RAINY COOL NORMAL TRUE NO)) 
(PREDICTION= NO FOR (SUNNY HOT HIGH TRUE NO)) 
(PREDICTION= NO FOR (OVERCAST MILD HIGH TRUE YES)) 
(PREDICTION= YES FOR (SUNNY COOL NORMAL FALSE YES)) 
(PREDICTION= NO FOR (RAINY MILD HIGH FALSE YES)) 
(PREDICTION= YES FOR (RAINY MILD NORMAL FALSE YES)) 
(PREDICTION= NO FOR (SUNNY MILD NORMAL TRUE YES)) 
NO = #S(RESULT
        :TARGET NO
        :A 2
        :B 1
        :C 3
        :D 1
        :ACC 0.42857143
        :PF 0.6
        :PREC 0.25
        :PD 0.5
        :F 0.33333334
        :DETAILS NIL)
YES = #S(RESULT
         :TARGET YES
         :A 1
         :B 3
         :C 1
         :D 2
         :ACC 0.42857143
         :PF 0.5
         :PREC 0.6666667
         :PD 0.4
         :F 0.5
         :DETAILS NIL)
NO = #S(RESULT
        :TARGET NO
        :A 4
        :B 3
        :C 0
        :D 0
        :ACC 0.5714286
        :PF 0.0
        :PREC 0.0
        :PD 0.0
        :F 0.0
        :DETAILS NIL)
YES = #S(RESULT
         :TARGET YES
         :A 0
         :B 0
         :C 3
         :D 4
         :ACC 0.5714286
         :PF 1.0
         :PREC 0.5714286
         :PD 1.0
         :F 0.72727275
         :DETAILS NIL)
"))