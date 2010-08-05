
(defun zeror (&key f (bins 3) debug )
  (let (tbl majority results klasses)
    (labels ((preprocess (tbl0)
	       (setf tbl (clone-table tbl0)))
	     (ready ()
	       (setf klasses  (klass.all tbl)
		     majority (klass.majority tbl)
		     results  (klasses->results tbl)))
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
      (data f)
      (traintest 0
		 :bins       bins
		 :preprocess #'preprocess
		 :train      #'train
		 :ready      #'ready
		 :tester     #'classify
		 :reporter   #'reporter))))

(deftest !zeror1 ()
  (test
   (with-output-to-string (s) 
     (showh (zeror :debug s) :stream s))
 "(PREDICTION= YES FOR (SUNNY MILD HIGH FALSE NO)) 
  (PREDICTION= YES FOR (RAINY COOL NORMAL TRUE NO)) 
  (PREDICTION= YES FOR (RAINY MILD NORMAL FALSE YES)) 
  (PREDICTION= YES FOR (OVERCAST HOT NORMAL FALSE YES)) 
  (PREDICTION= YES FOR (OVERCAST MILD HIGH TRUE YES)) 
  NO = #S(RESULT
        :TARGET NO
        :A 3
        :B 2
        :C 0
        :D 0
        :ACC 0.6
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
         :D 3
         :ACC 0.6
         :PF 1.0
         :PREC 0.6
         :PD 1.0
         :F 0.75
         :DETAILS NIL)"))

(deftest !zeror2 ()
  (test
   (with-output-to-string (s) 
     (showh (zeror :f "weather3.lisp" :debug s) :stream s))
  "(PREDICTION= YES FOR (SUNNY MILD HIGH FALSE SAD)) 
   (PREDICTION= YES FOR (RAINY COOL NORMAL TRUE SAD)) 
   (PREDICTION= YES FOR (RAINY COOL NORMAL FALSE NEUTRAL)) 
   (PREDICTION= YES FOR (OVERCAST HOT NORMAL FALSE YES)) 
   (PREDICTION= YES FOR (RAINY MILD NORMAL FALSE YES)) 
   NEUTRAL = #S(RESULT
             :TARGET NEUTRAL
             :A 4
             :B 1
             :C 0
             :D 0
             :ACC 0.8
             :PF 0.0
             :PREC 0.0
             :PD 0.0
             :F 0.0
             :DETAILS NIL)
   SAD = #S(RESULT
         :TARGET SAD
         :A 3
         :B 2
         :C 0
         :D 0
         :ACC 0.6
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
         :D 2
         :ACC 0.4
         :PF 1.0
         :PREC 0.4
         :PD 1.0
         :F 0.5714286
         :DETAILS NIL)"))
