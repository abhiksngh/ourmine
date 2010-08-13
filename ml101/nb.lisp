(defun nb-rig (debug &optional note (m 2) (k 1))
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
	       (setf results  (klasses->results tbl (cons 'nb note))))
	     (classify (row)
	       (let* ((actual     (row-class row))
		      (predicted  (most-likely-klass tbl row n m k)))
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

(defun nb (&key f note (repeats 1) (bins 3) debug (xval t) (m 2) (k 1))
  (let (out (learner (nb-rig debug note m k)))
    (data f)
    (dotimes (repeat repeats out)
      (randomize)
      (if xval
	  (dotimes (bin bins)
	    (push  (traintest bin :bins   bins :rigs learner) out))
	  (push (traintest 0 :bins bins :rigs learner) out)))))

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
             (tmp   (log prior)))
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
			  (incf tmp (log delta))))))
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

(deftest !weather ()
  (show-n-mway :learner #'nb
	       :f "weather.lisp"
	       :m 10 :n 3 :reporter #'result-pd))

(deftest !audiology ()
  (show-n-mway :learner #'nb
	       :f "audiology.lisp"
	       :m 10 :n 10 :reporter #'result-pd))

(deftest !audiology2 ()
  (show-n-mway :learner #'nb
	       :collector #'collectors
	       :f "audiology.lisp"
	       :m 10 :n 10 :reporter #'result-pd))

(deftest !iris ()
  (show-n-mway :learner #'nb
	       :f "iris.lisp"
	       :m 10 :n 10 :reporter #'result-pd))

(deftest !iris2 ()
  (show-n-mway :collector #'collectors
	       :learner #'nb
	       :f "iris.lisp"
	       :m 7 :n 3 :reporter #'result-f))

(deftest !iris3 ()
  (let ((f "iris.lisp")
	(repeats 10)
	(bins     3))
    (dotimes (m 3)
      (dotimes (k 3)
	(reset-seed)
	(chartc `(m ,m k ,k) 
	       (nb :f f :repeats repeats :bins bins :m m :k k))))))


(deftest !iris4 ()
  (let ((f "iris.lisp")
	(repeats 10)
	(bins     3)
	all)
    (reset-seed)
    (dotimes (m 4)
      (dotimes (k 4)
	(push (chart-all `(m ,m k ,k) #'result-pd
			 (nb :f f :repeats repeats :bins bins :m m :k k))
	      all)))
    (setf all (sort all #'> :key #'first ))
    (let ((rank 1)
	  (last (second (car all))))
      ;(print last)
      (format t "~5<~a~> ~a~%" rank (third (car all)))
      (dolist (one    (cdr all))
	(let ((next   (second one))
	      (report (third one)))
	  (when (mann-whitney last next 95)
	      ;(o next last)
	      (incf rank))
	  (format t "~5<~a~> ~a~%" rank report)
	  (setf last (append next last)))))))


(defun chartc (header results)
  (let ((f "~&~20<~a~> ~30<~a~> ~3<~a~> ~3<~a~> ~3<~a~> ~3<~a~> ~3<~a~> ~%"))
    (terpri)
    (format t f header ""  "    10" 30 50 70 90)
    (format t f "" ""  "    --" "--" "--" "--" "--")
    (dolist (one  (collectorc results #'result-f))
      (let* ((all (percentiles (cdr one) '(10 30 50 70 90))))
	(labels ((p (n) (round (* 100 (cdr (assoc n all))))))
	  (format t f
		  (car one)
		  (quintile (cdr one) )
		  (p 10) (p 30) (p 50) (p 70) (p 90)
		  ))))))


(defun chart-all (header reporter results)
  (let ((f "~&~20<~a~> ~30<~a~> ~3<~a~> ~3<~a~> ~3<~a~> ~3<~a~> ~3<~a~>"))
    (let* ((some  (collector-all results reporter))
	   (all   (percentiles some '(10 30 50 70 90))))
	(labels ((p (n) (round (* 100 (cdr (assoc n all))))))
	  (list (p 50)
		some
		(format nil f
		  header
		  (quintile some :shrink 1)
		  (p 10) (p 30) (p 50) (p 70) (p 90)
		  ))))))


(deftest !lungcancer ()
  (show-n-mway :learner #'nb
	       :f "lungcancer.lisp"
	       :m 10 :n 10 :reporter #'result-pd))

(deftest !credit ()
  (show-n-mway :learner #'nb
	       :f "credit.lisp"
	       :m 10 :n 10 :reporter #'result-pd))

(defun show-n-mway (&key f note learner (stream t) (m 10) (n 3) (collector #'collector)
		    (reporter #'result-acc))
  (reset-seed)
  (let ((results (funcall learner :f f :note note :repeats m :bins n)))
    (showh
     (funcall collector results reporter) :stream stream)))
    
(defun collector (results reporter)
  (let (all
	(out (make-hash-table)))
    (dolist (hash (flatten results))
      (dohash (key result hash)
	(let ((value (funcall reporter result)))
	  (push value all)
	  (push value (gethash key out)))))
    (setf all (sort all #'<))
    (dohash (key value out (values out all))
      (declare (ignore key))
      (setf value (sort value #'<)))))

(defun collectorc (results reporter)
  (let (alist
	all
	(out (make-hash-table :test #'equal)))
    (dolist (hash (flatten results))
      (dohash (key result hash)
	(let ((value (funcall reporter result)))
	  (push value all)
	  (push value (gethash (cons key (result-details result)) out)))))
    (setf all (sort all #'<))
    (dohash (key value out alist)
      (push (cons key value) alist))))


(defun collector-all (results reporter)
  (let (out )
    (dolist (hash (flatten results))
      (dovalues (result hash)
	(let ((value (funcall reporter result)))
	  (push value out))))
    (sort out #'<)))