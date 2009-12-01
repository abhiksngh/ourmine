(defun generateSlices(setList prep norm discretizer &optional (stream nil))
  (let ((trainSlices)
        (testSlices))
    (dolist (per-set setList)
    (let* ((soft-labFullList (list 0 18 13 12 1 3 11 6 8 9 5 10 4 17 16 15 14))
        (nasaFullList (list 1 17 3 2 22 25 4 13 14 15 12 16 11 7 8 5 6))
        (soft-labReducedList (list 0 0 3))
        (nasaReducedList (list 0 18 13))
        (currentData (funcall discretizer (funcall norm (funcall prep (if (or (not (eql (search "SHARED" (parse-name per-set)) 0))
                                  (not (eql (search "COMBINED" (parse-name per-set)) 0)))
                               (prune-columns (funcall per-set) soft-labFullList)
                               (prune-columns (funcall per-set) nasaFullList)))))))
        (print currentData)
     
        (loop for k from 1 to 5
             do
             (multiple-value-bind (trainlist testlist) (bins (build-a-data (format nil "Set: ~A Round: ~A" (table-name currentData) k)
                                                                                (columns-header (table-columns currentData))
                                                                                (shuffle (features-as-a-list currentData))))
               (doitems (per-train num trainlist)
                 (push per-train trainSlices)
                 (push (nth num testlist) testSlices))))))
    (multiple-value-bind (returnTrain returnTest) (randomizeSlices trainSlices testSlices)
      (values returnTrain returnTest))))

(defun randomizeSlices(trainSlices testSlices)
    (let* ((randomizedList (make-list (length trainSlices)))
         (returnTrainSlices (make-list (length trainSlices)))
         (returnTestSlices (make-list (length testSlices))))
    (setf randomizedList (shuffle (doitems (per-num n randomizedList randomizedList)
               (setf (nth n randomizedList) n))))
    (doitems (num number randomizedList)
      (setf (nth number returnTrainSlices) (nth num trainSlices))
      (setf (nth number returnTestSlices) (nth num testSlices)))
    (values returnTrainSlices returnTestSlices)))          
             
             
(defun runLearnSet(&optional (bsq nil) (filename "output.dat")
                   &key (prep #'numval1)
                        (norm #'normalizedata)
                        (discretizer  #'equal-width)
                        (classify     #'nb))
    (let* ((setList (list #'shared-cm1 
                          #'shared-kc1 
                          #'shared-kc2 
                     ;     #'shared-kc3  
                     ;     #'shared-mw1 
                     ;     #'shared-mc2 
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
           (tpdslice) (tpfslice) ; pd/pf scores for each slice
           (fpdslice) (fpfslice)
           (tsofar) (fsofar) ; true/false scores for running train set
           (tpdsofar) (tpfsofar) ; pd/pf scores for running train set
           (fpdsofar) (fpfsofar)
           (taccslice) (tprecslice) (faccslice) (fprecslice) (taccsofar) (tprecsofar) (faccsofar) (fprecsofar)
           (tfslice) (tgslice) (ffslice) (fgslice) (tfsofar) (tgsofar) (ffsofar) (fgsofar)
           (train-so-far))   ; running train set (builds as it goes)
      
      (multiple-value-bind (trainSliceList testSliceList) (generateSlices setList prep norm discretizer stream)
        (setf train-so-far (first trainSliceList))
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
          (setf tpdslice (float(pd (first tslice)
                                  (second tslice)
                                  (third tslice)
                                  (fourth tslice))))
          (setf tpfslice (float(pf (first tslice)
                                  (second tslice)
                                  (third tslice)
                                  (fourth tslice))))
          (setf tpdsofar (float(pd (first tsofar)
                                  (second tsofar)
                                  (third tsofar)
                                  (fourth tsofar))))
          (setf tpfsofar (float(pf (first tsofar)
                                  (second tsofar)
                                  (third tsofar)
                                  (fourth tsofar))))
          (setf fpdslice (float (pd (first fslice)
                                    (second fslice)
                                    (third fslice)
                                    (fourth fslice))))
          (setf fpfslice (float (pf (first fslice)
                                    (second fslice)
                                    (third fslice)
                                    (fourth fslice))))
          (setf fpdsofar (float (pd (first fsofar)
                                    (second fsofar)
                                    (third fsofar)
                                    (fourth fsofar))))
          (setf fpfsofar (float (pf (first fsofar)
                                    (second fsofar)
                                    (third fsofar)
                                    (fourth fsofar))))
          (setf taccslice (float(acc (first tslice)
                                    (second tslice)
                                    (third tslice)
                                    (fourth tslice))))
          (setf tprecslice (float(prec (first tslice)
                                  (second tslice)
                                  (third tslice)
                                  (fourth tslice))))
          (setf taccsofar (float(acc (first tsofar)
                                  (second tsofar)
                                  (third tsofar)
                                  (fourth tsofar))))
          (setf tprecsofar (float(prec (first tsofar)
                                  (second tsofar)
                                  (third tsofar)
                                  (fourth tsofar))))
          (setf faccslice (float (acc (first fslice)
                                    (second fslice)
                                    (third fslice)
                                    (fourth fslice))))
          (setf fprecslice (float (prec (first fslice)
                                    (second fslice)
                                    (third fslice)
                                    (fourth fslice))))
          (setf faccsofar (float (acc (first fsofar)
                                    (second fsofar)
                                    (third fsofar)
                                    (fourth fsofar))))
          (setf fprecsofar (float (prec (first fsofar)
                                    (second fsofar)
                                    (third fsofar)
                                    (fourth fsofar))))
          (setf tfslice (float(f-calc (first tslice)
                                    (second tslice)
                                    (third tslice)
                                    (fourth tslice))))
          (setf tgslice (float(g (first tslice)
                                  (second tslice)
                                  (third tslice)
                                  (fourth tslice))))
          (setf tfsofar (float(f-calc (first tsofar)
                                  (second tsofar)
                                  (third tsofar)
                                  (fourth tsofar))))
          (setf tgsofar (float(g (first tsofar)
                                  (second tsofar)
                                  (third tsofar)
                                  (fourth tsofar))))
          (setf ffslice (float (f-calc (first fslice)
                                    (second fslice)
                                    (third fslice)
                                    (fourth fslice))))
          (setf fgslice (float (g (first fslice)
                                    (second fslice)
                                    (third fslice)
                                    (fourth fslice))))
          (setf ffsofar (float (f-calc (first fsofar)
                                    (second fsofar)
                                    (third fsofar)
                                    (fourth fsofar))))
          (setf fgsofar (float (g (first fsofar)
                                    (second fsofar)
                                    (third fsofar)
                                    (fourth fsofar))))

          ; if slice is better than 'so-far' add the slice's train to total 
          (when (> (- (balance tpdslice tpfslice) .15) (balance tpdsofar tpfsofar))
            (format t "relearning ~%")
            (setf train-so-far (combine-sets train-so-far (burak per-train (nth i testSliceList)))))

          ; prints the pd/pf stats for the 'so-far' train set
          (format stream "normalize, equalwidth, naivebayes,slice,~A,~A,~A,~A,~A,~A,~A,~A,~A,~A,~A,~A~%" "TRUE"
              (first tslice) (second tslice) (third tslice) (fourth tslice) 
               taccslice tprecslice tpdslice tpfslice tfslice tgslice (balance tpdslice tpfslice)
          )
          (format stream "normalize, equalwidth, naivebayes,slice,~A,~A,~A,~A,~A,~A,~A,~A,~A,~A,~A,~A~%" "FALSE"
              (first fslice) (second fslice) (third fslice) (fourth fslice)
               faccslice fprecslice fpdslice fpfslice ffslice fgslice (balance fpdslice fpfslice)
          )
          (format stream "normalize, equalwidth, naivebayes,sofar,~A,~A,~A,~A,~A,~A,~A,~A,~A,~A,~A,~A~%" "TRUE"
              (first tsofar) (second tsofar) (third tsofar) (fourth tsofar)
               taccsofar tprecsofar tpdsofar tpfsofar tfsofar tgsofar (balance tpdsofar tpfsofar)
          )
          (format stream "normalize, equalwidth, naivebayes,sofar,~A,~A,~A,~A,~A,~A,~A,~A,~A,~A,~A,~A~%" "FALSE"
              (first fsofar) (second fsofar) (third fsofar) (fourth fsofar)
               faccsofar fprecsofar fpdsofar fpfsofar ffsofar fgsofar (balance fpdsofar fpfsofar)
          )
 
          (incf slice-count)))
        (close stream)))

(defun balance(pd pf)
  (- 1 (/
    (sqrt
         (+
          (square
           (-
            0
            pf))
          (square
           (-
            1
            pd))))
        (sqrt 2))))

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
