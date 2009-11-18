(defun runLearnSetNoBins(&optional (stream t))
    (let* ((setList (list #'shared-cm1 #'shared-kc1 #'shared-kc2 #'shared-kc3 #'shared-mw1 #'shared-mc2 #'shared-pc1)))
        (dolist (per-set setList)
            (format stream "~A~%" (parse-name per-set))
            (dolist (percent (list 0.1 0.15 0.2 0.25 0.3 0.35 0.4 0.45 0.5 0.55 0.6 0.65 0.7 0.75 0.8 0.85 0.9 0.95))
                (format stream "Train: ~a%, Test: ~a%~%" 
                    (round (* 100 percent)) 
                    (round (* 100 (- 1.0 percent)))
                )
                (multiple-value-bind (train test) (nvalues percent (funcall per-set))
                (learn train test))
                (format stream "~%")
            )
        )
    )
)


(defun runLearnSet(&optional (bsq nil) (filename "output.dat")
                   &key (prep #'numval1)
                        (norm #'normalizedatatrainandtest)
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
;                          #'ar3 
;                          #'ar4 
;                          #'ar5
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

    ; for each data set (10 total)
        (dolist (per-set setList)

        ; ** need to do column pruning depending on if it is nasa/softlab **
        (format t "~%~A:~%" (table-name (funcall per-set)))

        ; run this experiment with 5 different randomizations
            (loop for k from 1 to 3
                do
                (format t "~A.." k)
                (setf var 
                    (build-a-data (format nil "~A_rand_~A" (table-name (funcall per-set)) k) 
                        (columns-header (table-columns (funcall per-set)))
                        (shuffle (features-as-a-list (funcall per-set)))))
                (format stream "~A~%" (table-name var))
            
                ; split each randomization into 5 bins (80/20 train test)
                (multiple-value-bind (trainlist testlist) (bins var)
                    (when (not train-so-far)
                        (setf train-so-far (first trainlist))
                    )
 
                    ; for each of the 5 bins of this randomization
                    (doitems (per-train i trainlist) 

                        ; get perf scores for this slice
                        (multiple-value-bind (ts fs) 
                            (learn per-train (nth i testlist))
                            (setf tslice ts fslice fs)
                        )

                        ; get perf scores for train set so far
                        (multiple-value-bind (ts fs) 
                            (learn train-so-far (nth i testlist))
                            (setf tsofar ts fsofar fs))

                        ;** 'better' and 'worse' should probably be based on some % threshold
                        ; if scores are equal, don't change 'so-far', just move to next slice
                        ; if the slice is worse, ignore it, move to next slice

                        ; if slice is better than 'so-far' add the slice's train to total
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
 
                        (when (> (- pdslice pfslice) (- pdsofar pfsofar))
                            (setf train-so-far (combine-sets train-so-far per-train))
                        )

                        ; prints the pd/pf stats for the 'so-far' train set
                        (format stream "~A: TRUE~Tpd: ~A~Tpf: ~A~Tsize: ~A~%" slice-count 
                                pdsofar pfsofar (length (features-as-a-list train-so-far)))
                        (incf slice-count)
                    )    
                )
            )
        )
        (close stream)
    )
)

(defun combine-sets (base new)
    (build-a-data (table-name base) (columns-header (table-columns base)) 
                  (append (features-as-a-list base) (features-as-a-list new)))
)

(defun learn (trainset
              testset
              &key (prep #'numval1)
                   (norm #'normalizedatatrainandtest)
                   (rowReducer   #'donothing)
                   (discretizer  #'equal-width-train-test)
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

(defun printHeaderLine (stream prep norm rowReducer discretizer classifier)
    (format stream "prep: ~A~%normalizer: ~A~%rowReducer: ~A~%discretizer: ~A~%classifier: ~A~%" 
        (parse-name prep)
        (parse-name norm)
        (parse-name rowReducer)
        (parse-name discretizer)
        (parse-name classifier))

)

(defun printLine(stream class resultsList)
    (format stream "~a,~T~a,~T~a,~T~a,~T~a,~T~a,~T~a,~T~a,~T~a,~T~a,~T~a~%"   
                  class 
                  (first resultsList) 
                  (second resultsList) 
                  (third resultsList) 
                  (fourth resultsList)
                   (float (acc (first resultsList)
                        (second resultsList)
                        (third resultsList)
                        (fourth resultsList)))
                   (float (prec (first resultsList)
                         (second resultsList)
                         (third resultsList)
                         (fourth resultsList)))
                   (float(pd (first resultsList)
                       (second resultsList)
                       (third resultsList)
                       (fourth resultsList)))
                   (float(pf (first resultsList)
                       (second resultsList)
                       (third resultsList)
                       (fourth resultsList)))
                   (float(f-calc (first resultsList)
                      (second resultsList)
                      (third resultsList)
                      (fourth resultsList)))
                   (float(g (first resultsList)
                      (second resultsList)
                      (third resultsList)
                      (fourth resultsList)))))

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
