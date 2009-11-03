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

(defun masslearn ()
    (runlearnset nil "nv_norm_not_freq.dat" 
                 :rowReducer #'donothing1 
                 :discretizer #'equal-freq)
    (runlearnset nil "nv_norm_not_width.dat" 
                 :rowReducer #'donothing1 
                 :discretizer #'equal-width)
    (runlearnset t "nv_norm_not_freq_bsq.dat" 
                 :rowReducer #'donothing1 
                 :discretizer #'equal-freq)
    (runlearnset t "nv_norm_not_width_bsq.dat" 
                 :rowReducer #'donothing1 
                 :discretizer #'equal-width)
    (runlearnset nil "nv_norm_sub_freq.dat" 
                 :rowReducer #'sub-sample 
                 :discretizer #'equal-freq)
    (runlearnset nil "nv_norm_sub_width.dat" 
                 :rowReducer #'sub-sample 
                 :discretizer #'equal-width)
    (runlearnset t "nv_norm_sub_freq_bsq.dat" 
                 :rowReducer #'sub-sample 
                 :discretizer #'equal-freq)
    (runlearnset t "nv_norm_sub_width_bsq.dat" 
                 :rowReducer #'sub-sample 
                 :discretizer #'equal-width)
;    (runlearnset nil "nv_norm_bur_freq.dat"
;                 :rowReducer #'burak
;                 :discretizer #'equal-freq-train-test)
;    (runlearnset nil "nv_norm_bur_width.dat"
;                 :rowReducer #'burak
;                 :discretizer #'equal-width-train-test)
;    (runlearnset t "nv_norm_bur_freq_bsq.dat"
;                 :rowReducer #'burak
;                 :discretizer #'equal-freq-train-test)
;    (runlearnset t "nv_norm_bur_width_bsq.dat"
;                 :rowReducer #'burak
;                 :discretizer #'equal-width-train-test)
    (runlearnset nil "baseline.dat"
                 :norm #'donothing
                 :rowReducer #'donothing
                 :discretizer #'donothing1)

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
                          #'ar3 #'ar4 
                          #'ar5))
           (stream (open filename :direction :output 
                                  :if-does-not-exist :create
                                  :if-exists :supersede))
          (train) (test) (var))
        (dolist (per-set setList)
            (format stream "~A~%" (parse-name per-set))
            (setf var (funcall discretizer (funcall per-set)))
            (multiple-value-bind (trainList testList) 
                (if bsq 
                    (bins (b-squared var))   ; b-squared col red
                    (bins var)               ; no col reduction
;                    (nvalues 0.8 (b-squared(funcall per-set)))
  ;                  (nvalues 0.8 (funcall per-set))
                )
                (knn-learn trainList testList stream :prep prep
                                                 :norm norm
                                                 :rowReducer rowReducer 
    ;                                             :discretizer discretizer
                                                 )
                (format stream "~%")
            )
        )
        (close stream)
    )
)

(defun learn (trainList
              testList
              stream
              &key (prep #'numval1)
                   (norm #'normalizedatatrainandtest)
                   (rowReducer   #'sub-sample)
   ;                (discretizer  #'equal-width-train-test)
                   (classify     #'nb))
    (when (not (listp trainList))
        (setf trainList (list trainList))
    )
    (when (not (listp testList))
        (setf testList (list testList))
    )

    (doitems (per-data-train i trainList) 
        (let* ((trainSet (if (tablep per-data-train)
                             per-data-train
                             (funcall per-data-train)))
               (testSet (if (tablep (nth i testList))
                            (nth i testList)
                            (funcall (nth i testList))))
               (trainSet (funcall prep trainSet))
               (testSet (funcall prep testSet)))

            ; normalize both train and test data sets
            (multiple-value-bind (trainSet testSet) 
                (funcall norm trainSet testSet)
;(format t "before: ~A" (length (table-all (xindex trainSet))))
                ; perform row reduction on train set
                (setf trainSet (funcall rowReducer trainSet testSet))
;(format t "  after: ~A~%" (length (table-all (xindex trainSet))))
                    ; perform discretization on both data sets
;                (multiple-value-bind (trainSet testSet) 
 ;                   (funcall discretizer trainSet testSet)

                    ; perform classificiation on both data sets
                    (multiple-value-bind (trueClass falseClass) 
                        (funcall classify trainSet testSet)

                        ; print metrics
                        (printLine stream 'TRUE trueClass)
                        (printLine stream 'FALSE falseClass)
                    )
                )
  ;          )
        T)
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
