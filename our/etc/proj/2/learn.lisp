(defun generateSlices(setList &optional (stream nil))
  (let ((trainSlices)
        (testSlices))
    (dolist (per-set setList)
      (let* ((currentData (if (or (search "shared" (string per-set))
                                   (search "combined" (string per-set)))
                               (prune-columns (funcall per-set) (list 0 18 13 12 1 3 11 6 8 9 5 10 4 0 17 16 15 14))
                               (prune-columns (funcall per-set) (list 1 17 3 2 22 25 4 13 14 15 12 16 11 0 7 8 5 6)))))
        (format t "~%A:~%" (table-name currentData))

        (loop for k from 1 to 5
             do
             (format t "~A.." k)
             (setf currentData
                  (build-a-data (format nil "Set: ~A Round: ~A" (table-name currentData) k)
                                (columns-header (table-columns currentData))
                                (shuffle (features-as-a-list currentData))))
                  (format stream "~A~%" (table-name currentData))

                  (multiple-value-bind (trainlist testlist) (bins currentData)
                    (doitems (per-train num trainlist)
                      (setf trainSlices (append trainSlices per-train))
                      (setf testSlices (append testSlices (nth num testlist))))))))
    (values (randomizeSlices trainSlices testSlices))))

(defun randomizeSlices(trainSlices testSlices)
  (let* ((randomizedList (make-list (length trainSlices)))
         (returnTrainSlices (make-list (length trainSlices)))
         (returnTestSlices (make-list (length testSlices))))
    (setf randomizedList (shuffle (doitems (per-num n randomizedList randomizedList)
               (setf (nth n randomizedList) n))))
    (doitems (num number randomizedList)
      (setf (nth number returnTrainSlices) (nth num trainSlices))
      (setf (nth number returnTestslices) (nth num testSlices)))
    (values returnTrainSlices returnTestSlices)))          
             
             
(defun runLearnSet(&optional (bsq nil) (filename "output.dat")
                   &key (prep #'numval1)
                        (norm #'normalizedata)
                        (rowReducer   #'sub-sample)
                        (discretizer  #'equal-width)
                        (classify     #'nb))
    (let* ((setList (list #'shared-cm1 
                          #'shared-kc1 
                          #'shared-kc2 
                          #'shared-kc3  
                          #'shared-mw1 
                          #'shared-mc2 
                          #'shared-pc1 
                          #'ar3 
                          #'ar4 
                          #'ar5
))
           (stream (open filename :direction :output 
                                  :if-does-not-exist :create
                                  :if-exists :supersede))
           (slice-count 0)
           (var)
           (tslice) (fslice) ; true/false scores for each slice
           (pdslice) (pfslice) ; pd/pf scores for each slice
           (tsofar) (fsofar) ; true/false scores for running train set
           (pdsofar) (pfsofar) ; pd/pf scores for running train set
           (train-so-far))   ; running train set (builds as it goes)
      
      (multiple-value-bind (trainSliceList testSliceList) (generateSlices setList stream)
        (setf train-so-far (features-as-a-list (first trainSliceList)))
        (doitems (per-train i trainSliceList)

           ; get perf scores for this slice
          (multiple-value-bind (ts fs)
              (learn per-train (nth i testSliceList))
              (setf tslice ts fslice fs))
          
          ; get perf scores for train set so far
          (multiple-value-bind (ts fs)
              (learn train-so-far (nth i testSliceList))
            (setf tsofar ts fsofar fs))

          ;** 'better' and 'worse' should probably be based on some % threshold
          ; if scores are equal, don't change 'so-far', just move to next slice
          ; if the slice is worse, ignore it, move to next slice
          (setf pdslice (float(pd (first tsofar)
                                  (second tsofar)
                                  (third tsofar)
                                  (fourth tsofar))))
          (setf pfslice (float(pf (first tsofar)
                                  (second tsofar)
                                  (third tsofar)
                                  (fourth tsofar))))
          (setf pdsofar (float(pd (first tsofar)
                                  (second tsofar)
                                  (third tsofar)
                                  (fourth tsofar))))
          (setf pfsofar (float(pd (first tsofar)
                                  (second tsofar)
                                  (third tsofar)
                                  (fourth tsofar))))

          ; if slice is better than 'so-far' add the slice's train to total 
          (when (> (- pdslice pfslice) (- pdsofar pfsofar))
            (setf train-so-far (combine-sets train-so-far per-train)))

          ; prints the pd/pf stats for the 'so-far' train set
          (format stream "~A: TRUE~Tpd: ~A~Tpf: ~A~Tsize: ~A~%" slice-count
                  pdsofar pfsofar (length (features-as-a-list train-so-far)))))
          
        (close stream)))

(defun combine-sets (base new)
    (build-a-data (table-name base) (columns-header (table-columns base)) 
                  (append (features-as-a-list base) (features-as-a-list new)))
)

(defun learn (trainset
              testset
              &key (prep #'donothing)
                   (norm #'donothing)
                   (rowReducer   #'donothing)
                   (discretizer  #'donothing)
                   (classify     #'nb))
    ; normalize both train and test data sets
    (multiple-value-bind (trainSet testSet) 
        (funcall norm trainSet testSet)

        ; perform row reduction on train set
        ; (setf trainSet (funcall rowReducer trainSet testSet 75))

        ; perform classificiation on both data sets
        (multiple-value-bind (trueClass falseClass) 
            (funcall classify trainSet testSet)

            ; return metrics
            (values trueClass falseClass)
         )
    )
)

(defun prec(a b c d)
  (/
   d
   (if (and
        (eql c 0)
        (eql d 0))
       1
       (+ c d))))

(defun acc(a b c d)
  (/
   (+ a d)
   (if (and
        (eql a 0)
        (eql b 0)
        (eql c 0)
        (eql d 0))
       1
       (+ a b c d))))

(defun pd(a b c d)
  (/
   d
   (if
    (and
     (eql b 0)
     (eql d 0))
    1
    (+ b d))))

(defun pf (a b c d)
  (/
   c
   (if (and
        (eql a 0)
        (eql c 0))
       1
       (+ a c))))

(defun f-calc (a b c d)
(let* ((a (if (eql a 0)
              1
              a))
       (b (if (eql b 0)
              1
              b))
       (c (if (eql c 0)
              1
              c))
       (d (if (eql d 0)
              1
              d)))
  (/ (* 2 (prec a b c d) (acc a b c d)) (+ (prec a b c d) (acc a b c d)))))

(defun g (a b c d)
(let* ((a (if (eql a 0)
              1
              a))
       (b (if (eql b 0)
              1
              b))
       (c (if (eql c 0)
              1
              c))
       (d (if (eql d 0)
              1
              d)))
  (/
   (*
    2
    (pf a b c d)
    (pd a b c d))
   (+
    (pf a b c d)
    (pd a b c d)))))


(defun parse-name (me)
    (let* ((name (format nil "~A" me)) 
           (start 0)
           (end  (position #\) name :from-end t))
           (start (position #\Space (subseq name 0 end) :from-end t)))
        (when (not end) (setf end (position #\> name :from-end t)))
        (subseq name (+ start 1) end)
    )
)

(defun test-parse (&key (discretizer  #'equal-width))
    (parse-name discretizer)
)
