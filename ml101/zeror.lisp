
(defun zeror-rig (debug )
  (let (tbl majority results)
    (labels ((preprocess (tbl0)
	       (setf tbl (clone-table tbl0)))
	     (ready ()
	       (setf majority (klass.majority tbl)
		     results  (klasses->results tbl 'zeror)))
	     (train (row i)
	       (declare (ignore i))
	       (defrow (row-cells row) tbl))
	     (classify (row)
	       (let* ((actual     (row-class row))
		      (predicted  majority))
		 (if debug
		     (print `(prediction= ,majority for ,(row-cells row)) debug))
		 (results-add results actual predicted)))
	     (reporter ()
	       (if debug
		   (terpri debug))
	       (results-report results)))
    (make-rig
       :preprocess #'preprocess
       :train      #'train
       :ready      #'ready
       :tester     #'classify
       :reporter   #'reporter))))

(defun zeror (&key f (bins 3) debug (xval t))
  (let (out (learner (zeror-rig debug)))
    (data f)
    (if xval
	(dotimes (bin bins)
	  (push  (traintest bin :bins   bins :rigs learner) out))
	(push (traintest 0 :bins bins :rigs learner) out))
    out))

(deftest !zeror1 ()
  (reset-seed)
  (data)
  (test
   (with-output-to-string (s)
     (mapc #'(lambda (rl) (showh (first rl) :stream s))
	   (zeror :bins 2 :debug s)))
   "
(PREDICTION= YES FOR (SUNNY HOT HIGH TRUE NO)) 
(PREDICTION= YES FOR (SUNNY MILD HIGH FALSE NO)) 
(PREDICTION= YES FOR (RAINY COOL NORMAL TRUE NO)) 
(PREDICTION= YES FOR (SUNNY MILD NORMAL TRUE YES)) 
(PREDICTION= YES FOR (SUNNY COOL NORMAL FALSE YES)) 
(PREDICTION= YES FOR (OVERCAST HOT HIGH FALSE YES)) 
(PREDICTION= YES FOR (OVERCAST MILD HIGH TRUE YES)) 

(PREDICTION= YES FOR (RAINY MILD HIGH TRUE NO)) 
(PREDICTION= YES FOR (SUNNY HOT HIGH FALSE NO)) 
(PREDICTION= YES FOR (OVERCAST HOT NORMAL FALSE YES)) 
(PREDICTION= YES FOR (RAINY MILD NORMAL FALSE YES)) 
(PREDICTION= YES FOR (OVERCAST COOL NORMAL TRUE YES)) 
(PREDICTION= YES FOR (RAINY COOL NORMAL FALSE YES)) 
(PREDICTION= YES FOR (RAINY MILD HIGH FALSE YES)) 
NO = #S(RESULT
        :TARGET NO
        :A 5
        :B 2
        :C 0
        :D 0
        :ACC 0.71428573
        :PF 0.0
        :PREC 0.0
        :PD 0.0
        :F 0.0
        :DETAILS NIL)
YES = #S(RESULT
         :TARGET YES
         :A 0
         :B 0
         :C 2
         :D 5
         :ACC 0.71428573
         :PF 1.0
         :PREC 0.71428573
         :PD 1.0
         :F 0.8333334
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
 