(defun learn (trainList
              testList
              &key (dataFileArgs nil)
                   (prep #'numval1)
                   (dataSplitFunc #'bins)
                   (norm #'normalizedatatrainandtest)
                   ;(k            8)
                   (rowReducer   #'doNothing)
                   (discretizer  #'equal-width)
                   ;(cluster      #'(lambda (data) (kmeans k data))) 
                   ;(fss          #'b-squared)
                   (classify     #'nb))
  (if (not(listp trainList))
      (setf trainList (list trainList)))
  (if (not(listp testList))
      (setf testList (list testList)))
  (doitems (per-data-train i trainList) 
    (let* ((trainSet (if (tablep per-data-list)
                        per-data-list
                        (funcall dataFile)))
           (testSet (if (tablep (nth i testList))
                        (nth i testList)
                        (funcall (nth i testList))))
           (trainSet (funcall prep trainSet))
           (testSet (funcall prep testSet))
           (multiple-value-bind (trainSet testSet) (funcall norm trainSet testSet)
             (testSet (funcall discretizer dataSet)))
        (multiple-value-bind (train test) (funcall dataSplitFunc dataSet)
            (multiple-value-bind (trueClass falseClass) (funcall classify train test)
            (printHeaderLine)
        (printLine prep rowReducer discretizer classify 'TRUE trueClass)
        (printLine prep rowReducer discretizer classify 'FALSE falseClass))))
    T))

(defun printHeaderLine ()
  (format t "prep, rowReducer, discretizer, classifier, class, ~Ta,~Tb,~Tc,~Td,~Tacc,~Tprec,~Tpd,~Tpf,~Tf,~Tg~%"))

(defun printLine(prep rowReducer discretizer classifier class resultsList)
              (format t "~a, ~a, ~a, ~a,~T~a,~T~a,~T~a,~T~a,~T~a,~T~a,~T~a,~T~a,~T~a,~T~a,~T~a~%" (parse-name prep) (parse-name rowReducer) (parse-name discretizer) (parse-name classifier) class (first resultsList) (second resultsList) (third resultsList) (fourth resultsList)
                   (acc (first resultsList)
                        (second resultsList)
                        (third resultsList)
                        (fourth resultsList))
                   (prec (first resultsList)
                         (second resultsList)
                         (third resultsList)
                         (fourth resultsList))
                   (pd (first resultsList)
                       (second resultsList)
                       (third resultsList)
                       (fourth resultsList))
                   (pf (first resultsList)
                       (second resultsList)
                       (third resultsList)
                       (fourth resultsList))
                   (f-calc (first resultsList)
                      (second resultsList)
                      (third resultsList)
                      (fourth resultsList))
                   (g (first resultsList)
                      (second resultsList)
                      (third resultsList)
                      (fourth resultsList))))

(defun prec(a b c d)
  (/
   d
   (if (and
        (eql c 0)
        (eql d 0))
       (log 0.001)
       (+ c d))))

(defun acc(a b c d)
  (/
   (+ a d)
   (if (and
        (eql a 0)
        (eql b 0)
        (eql c 0)
        (eql d 0))
       (log 0.001)
       (+ a b c d))))

(defun pd(a b c d)
  (/
   d
   (if
    (and
     (eql b 0)
     (eql d 0))
    (log 0.0001)
    (+ b d))))

(defun pf (a b c d)
  (/
   c
   (if (and
        (eql a 0)
        (eql c 0))
       (log 0.001)
       (+ a c))))

(defun f-calc (a b c d)
  (/ (* 2 (prec a b c d) (acc a b c d)) (+ (prec a b c d) (acc a b c d))))

(defun g (a b c d)
  (/ (* 2 (pf a b c d) (pd a b c d)) (+ (pf a b c d) (pd a b c d))))


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
