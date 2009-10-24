;Create one hyperpipe per class each hyperpipe will contain a list of bins(min and max for each attribute) and the class it was created for
(defun CreateHyperPipes (numberOfAttributes Classes)
  (let ((HyperPipes (list)))
    (dolist (currentClass Classes HyperPipes)
      (setf HyperPipes (append HyperPipes
                               (list (make-HyperPipe :numericBounds (let ((numericBounds (list)))
                                                                (dotimes (i numberOfAttributes numericBounds)
                                                                  (setf numericBounds (append numericBounds (list (make-NumericBound)))))) :class currentClass)))))))

(defun CreateSingleHyperPipe (numberOfAttributes Class)
  (let ((HyperPipe nil))
    (setf HyperPipe (make-HyperPipe :numericBounds (let ((numericBounds (list)))
                                                     (dotimes (i numberOfAttributes numericBounds)
                                                       (setf numericBounds (append numericBounds (list (make-NumericBound)))))) :class Class))))
;Add experience to the HyperPipes. The function first finds the appropriate pipe for this experience based on the experience class.
;Then for each attribute update the bin with the new min and max if the experience attribute is smaller than the current min or
;larger than the current max.
(defun AddExperience (pipes experience)
  ;(print (ExperienceInstance-class experience))
  (let ((pipe (FindPipe pipes (ExperienceInstance-class experience))))
    
     (dotimes (current (length (ExperienceInstance-attributes experience)) pipe)
       (let ((currentBound (nth current (HyperPipe-numericBounds pipe)))
             (currentExperience (nth current (ExperienceInstance-attributes experience))))
         
         (if (not (equal currentExperience '?))
             (if (numberp currentExperience)
                 (progn
                   (setf (NumericBound-min currentBound) (min currentExperience (NumericBound-min currentBound)))
                   (setf (NumericBound-max currentBound) (max currentExperience (NumericBound-max currentBound)))
                   )
                 (setf (NumericBound-nonNumeric currentBound) (remove-duplicates (append (NumericBound-nonNumeric currentBound) (list currentExperience))))
                 )
             )
                   
         )
       )
     pipes)
  )

(defun AddExperienceNew (pipes experience)
  ;(print (ExperienceInstance-class experience))
  (let ((pipe (FindPipe pipes (ExperienceInstance-class experience))))
    (if (null pipe)
        (progn
          ;(print "adding new pipe")
          (setf pipes (append pipes (list (CreateSingleHyperPipe (length (ExperienceInstance-attributes experience)) (ExperienceInstance-class experience)))))
          (setf pipe (FindPipe pipes (ExperienceInstance-class experience)))
          )
        )
        
    
     (dotimes (current (length (ExperienceInstance-attributes experience)) pipe)
       (let ((currentBound (nth current (HyperPipe-numericBounds pipe)))
             (currentExperience (nth current (ExperienceInstance-attributes experience))))
         
         (if (not (equal currentExperience '?))
             (if (numberp currentExperience)
                 (progn
                   (setf (NumericBound-min currentBound) (min currentExperience (NumericBound-min currentBound)))
                   (setf (NumericBound-max currentBound) (max currentExperience (NumericBound-max currentBound)))
                   (if (= (NumericBound-numOccured currentBound) 0)
                       (progn
                         (setf (NumericBound-numOccured currentBound) 1)
                         (setf (NumericBound-mean currentBound) currentExperience)
                         )
                       (progn
                         (setf (NumericBound-mean currentBound) (/ (+ (* (NumericBound-mean currentBound) (NumericBound-numOccured currentBound)) currentExperience) (+ (NumericBound-numOccured currentBound) 1)))
                         (incf (NumericBound-numOccured currentBound))
                         )
                       )
                   )
                 (setf (NumericBound-nonNumeric currentBound) (remove-duplicates (append (NumericBound-nonNumeric currentBound) (list currentExperience))))
                 )
             )
                   
         )
       )
     pipes)
  )

;Find the pipe that is appropriate for this class. This will be used to direct experience to the correct HyperPipe
(defun FindPipe (pipes class)
  (dolist (pipe pipes)
    (if (equal (HyperPipe-class pipe) class)
        (return-from FindPipe pipe)))
  (return-from FindPipe nil)
  )

;Calculate distribution of attribute ranges it falls in vs it doesnt

(defun calculateDistribution (pipe newExperience)
  ;(print newExperience)
  (let ((count 0)
        (numAttributes (length (ExperienceInstance-attributes newExperience))))
    (dotimes (current numAttributes pipe)
      (let ((currentBound (nth current (HyperPipe-numericBounds pipe)))
            (currentExperience (nth current (ExperienceInstance-attributes newExperience))))
        (if (or
             (and (not (equal currentExperience '?))
                  (not (numberp currentExperience))
                  (member currentExperience (NumericBound-nonNumeric currentBound)))
             (and (numberp currentExperience)
                 (>= currentExperience (NumericBound-min currentBound))
                 (<= currentExperience (NumericBound-max currentBound))))
            (incf count))
        ))
    ;(print count)
    ;(print numAttributes)
    (/ count numAttributes)
    )
  )
(defun calculateDistributionNew (pipe newExperience countType meanType)
  ;(print newExperience)
  (let ((count 0)
        (numAttributes (length (ExperienceInstance-attributes newExperience))))
    (dotimes (current numAttributes pipe)
      (let ((currentBound (nth current (HyperPipe-numericBounds pipe)))
            (currentExperience (nth current (ExperienceInstance-attributes newExperience))))
        (if (or
             (and (not (equal currentExperience '?))
                  (not (numberp currentExperience))
                  (member currentExperience (NumericBound-nonNumeric currentBound)))
             (and (numberp currentExperience)
                 (>= currentExperience (NumericBound-min currentBound))
                 (<= currentExperience (NumericBound-max currentBound))))
            (if (= countType 0)
                (incf count)
                (incf count (calculateDistanceFromMean (NumericBound-min currentBound) (NumericBound-max currentBound) (NumericBound-mean currentBound) currentExperience meanType))
                )
            )
        ))
    ;(print count)
    ;(print numAttributes)
    (/ count numAttributes)
    )
  )



(defun doDistributions (newExperience HyperPipes countType meanType)
  (let ((distributions (list)))
    (dolist (pipe HyperPipes distributions)
      ;(print (HyperPipe-class pipe))
      ;(print (calculateDistribution pipe newExperience))
      (setf distributions (append distributions (list (list (HyperPipe-class pipe) (calculateDistributionNew pipe newExperience countType meanType)))))
    
    )
    ;(print distributions)
    distributions
  ))

(defun normalizeResults (distributions)
  (let ((sum (eval (append '(+) (mapcar #'second distributions)))))
    (dolist (currentDist distributions distributions)
      (if (<= sum 0)
          (setf (second currentDist) (/ 1 (length distributions)))
          (setf (second currentDist) (/ (second currentDist) sum))
          )
      )
    )
  )
   

;Appropriate Data Files:
;audiology
;kr-vs-kp
;primary-tumor
;vehicle
;vote
;weather.nominal
;weather2
;weathernumerics
;vowel
;splice
(defun demoHyperPipes(&optional (dataFileName "audiology"))
  (print "*************Demoing HyperPipes**************")
  (load (concatenate `string "tests/data/" dataFileName ".lisp"))
  (let* ((dataTable (eval (read-from-string (concatenate `string "(" dataFileName ")"))))
         (MyHyperPipes (CreateHyperPipes (- (length (table-columns dataTable)) 1) (discrete-uniques (nth (table-class dataTable) (table-columns dataTable))))))
    ;(print MyHyperPipes)
    (dolist (currentDataPoint (table-all dataTable))
      (let ((currentAttributes (EG-features currentDataPoint)))
        (AddExperience MyHyperPipes (make-ExperienceInstance :attributes (remove-nth (table-class dataTable) (eg-features currentDataPoint)) :class (eg-class currentDataPoint)))
        )
      )

    ;
    (let ((Accuracy 0)
          (Total 0))
    ;(dotimes (i 100)
    (dolist (currentDataPoint (table-all dataTable))
      (let* ((currentAttributes (EG-features currentDataPoint))
             (DistributionResults (doDistributions (make-ExperienceInstance :attributes (remove-nth (table-class dataTable) (eg-features currentDataPoint))) MyHyperPipes))
             (normalizedResults (normalizeResults DistributionResults)))
        (let ((HighestValue ())
              (currentMax most-negative-fixnum))
          ;(print DistributionResults)
          (print normalizedResults)
          (dolist (result normalizedResults)
            (if (>= (second result) currentMax)
                (progn
                  (if (= (second result) currentMax)
                      (setf HighestValue (append HighestValue (list (first result))))
                      (setf HighestValue (list (first result)))
                      )
                  (setf currentMax (second result))
                 
                  )
                )
            
            )
          (if (find (nth (table-class dataTable) (eg-features currentDataPoint)) HighestValue)
              (progn
                (incf Accuracy)
                (format outputFile "~a ~a~%" 1 (length HighestValue))
                )
              (format outputFile "~a ~a~%" 0 (length HighestValue))
              )
          (incf Total)
          (format t "~%Expected Result: ~a Actual Result: ~a" (nth (table-class dataTable) (eg-features currentDataPoint)) HighestValue)
          )
        )
      )
    (format t "~%~%The accuracy is ~a" (/ Accuracy Total))
    )
    ;(setf MyQuestion (make-ExperienceInstance :attributes '(365 8000 400 98 blue)))
    ;(print MyHyperPipes)
    ;(setf distributions (doDistributions MyQuestion MyHyperPipes))
    ;(print distributions)
    ;(setf distributions (normalizeResults distributions))
    ;(print distributions)
    )
  )

    (defun remove-nth(n l)
	(if (> (- n 1) (length l))
		l
		(if (= n 0)
			(cdr l)
			(cons (car l) (remove-nth (- n 1) (cdr l))))))
 
(defun testFileRead(fileName)
  (let ((fileStream (open (concatenate `string "proj2/HyperPipes/Data/" fileName))))
    
    (eval (read-from-string (read-line fileStream)))
    )
  )


(defun demoHyperPipesNew(&key (dataFileName "primary-tumor") (Alpha 0) (countType 0) (meanType 0) (oldway 0) (useCentroid 0) (overfitDetect 0) (overfitRevert 0))
  (format t "*************Demoing HyperPipes**************~%")
  ;(load (concatenate `string "HyperPipes/Data/" dataFileName ".lisp"))

  (let* ((MyHyperPipes (list))
        (totalChecks 0)
        (totalRight 0)
        (outputFileName (concatenate `string "proj2/HyperPipes/OutputFiles/outputFile-" dataFileName (format nil "~a" countType) (format nil "~a" meanType) (format nil "~a" useCentroid) "-" (format nil "~a" (round (* Alpha 100))) "-" (format nil "~a" oldway) "-" (format nil "~a" overfitDetect) "-" (format nil "~a" overfitRevert) ".txt"))
         
                                     
         
        (outputFile nil))
    (ignore-errors
        (delete-file outputFileName)
        )
    (with-open-file (outputFile outputFileName :direction :output :if-does-not-exist :create :if-exists :supersede)
    (with-open-file (stream (concatenate `string "proj2/HyperPipes/Data/" dataFileName ".lisp"))
      (do ((line (read-line stream nil) (read-line stream nil))) ((null line))
        (let* ((attributeValues (eval (read-from-string line)))
               (tiedClasses (GetTiedClasses2 MyHyperPipes attributeValues Alpha countType meanType oldway))
               (tiedClasses (TrimTiedClasses tiedClasses MyHyperPipes useCentroid))
               (successOrFailure (find (nth (- (length attributeValues) 1) attributeValues) tiedClasses))
               )
          
;          (format t "~%Expected Result: ~a Actual Result: ~a" (nth (- (length attributeValues) 1) attributeValues) tiedClasses)
;          (format t "~%Success?: ~a~%" successOrFailure)
          (incf totalChecks)
          ;(setf outputFile (open outputFileName :direction :output :if-does-not-exist :create :if-exists :append))
          ;(print tiedClasses)
          (if (null successOrFailure)
              (write-line (format nil "~a ~a ~a ~a" 0 (length tiedClasses) tiedClasses  (last attributeValues)) outputFile)
;              (format t "~a ~a ~a~%" 0 (length tiedClasses) tiedClasses)
              (progn
                (incf totalRight)
;                (format t "Verified Success")
                (write-line (format nil "~a ~a ~a ~a" 1 (length tiedClasses) tiedClasses (last attributeValues)) outputFile)
;                (format t "~a ~a ~a~%" 1 (length tiedClasses) tiedClasses)
                )
              )
;          (close outputFile)
          ;(print successOrFailure)
          (setf MyHyperPipes (AddExperienceNew MyHyperPipes (make-ExperienceInstance :attributes (remove-nth (- (length attributeValues) 1) attributeValues) :class (nth (- (length attributeValues) 1) attributeValues))))
          (if (= overfitDetect 1)
              (progn
                (logRow MyHyperPipes attributeValues)
                (logResult MyHyperPipes tiedClasses (car (last attributeValues)))
                (detectOverfit MyHyperPipes 30 .35)
                )
              )
          (if (= overfitRevert 1)
              (progn
                (logHistResult MyHyperPipes tiedClasses (car (last attributeValues)))
                (detectOverfitHist MyHyperPipes 30 .35)
                )
              )
          )
        )
      ;(close outputFile)
      )
    )
    ;(print (float (/ totalRight totalChecks)))
    ;(print Alpha)
    ;MyHyperPipes
    (float (/ totalRight totalChecks))
    
    )


  )

(defun demoHyperPipesBatchNew(&key (dataFileName "primary-tumor") (Alpha 0) (countType 0) (meanType 0) (oldway 0) (useCentroid 0) (learn .6))
  (format t "*************Demoing HyperPipes**************~%")
  ;(load (concatenate `string "HyperPipes/Data/" dataFileName ".lisp"))

  (let* ((MyHyperPipes (list))
        (totalChecks 0)
        (totalRight 0)
         (numberOfLines 0)
         (numberToLearn 1)
         (currentLine 1)
        (outputFileName (concatenate `string "proj2/HyperPipes/OutputFiles/outputFileBATCH-" dataFileName (format nil "~a" countType) (format nil "~a" meanType) (format nil "~a" useCentroid) "-" (format nil "~a" (round (* Alpha 100))) "-" (format nil "~a" oldway) ".txt"))
         (outputFileName2 (concatenate `string "proj2/HyperPipes/OutputFiles/outputFileBATCH-" dataFileName (format nil "~a" countType) (format nil "~a" meanType) (format nil "~a" useCentroid) "-" (format nil "~a" (round (* Alpha 100))) "-" (format nil "~a" oldway) "-PLOT.txt"))
        (outputFile nil))
    (ignore-errors
        (delete-file outputFileName)
        (delete-file outputFileName2)
        )
    
    (with-open-file (stream (concatenate `string "proj2/HyperPipes/Data/" dataFileName ".lisp"))
      (do ((line (read-line stream nil) (read-line stream nil))) ((null line))
        (incf numberOfLines)
        )
      )
    (setf numberToLearn (ceiling (* numberOfLines learn)))
    
    (with-open-file (stream (concatenate `string "proj2/HyperPipes/Data/" dataFileName ".lisp"))
      (do ((line (read-line stream nil) (read-line stream nil))) ((null line))

        (if (<= currentLine numberToLearn)
            (let* ((attributeValues (eval (read-from-string line))))
              (setf MyHyperPipes (AddExperienceNew MyHyperPipes (make-ExperienceInstance :attributes (remove-nth (- (length attributeValues) 1) attributeValues) :class (nth (- (length attributeValues) 1) attributeValues))))
              )
            (let* ((attributeValues (eval (read-from-string line)))
                   (tiedClasses (GetTiedClasses2 MyHyperPipes attributeValues Alpha countType meanType oldway))
                   (tiedClasses (TrimTiedClasses tiedClasses MyHyperPipes useCentroid))
                   (successOrFailure (find (nth (- (length attributeValues) 1) attributeValues) tiedClasses))
                   )
                                        ;(format t "~%Expected Result: ~a Actual Result: ~a" (nth (- (length attributeValues) 1) attributeValues) tiedClasses)
              (incf totalChecks)
              (setf outputFile (open outputFileName :direction :output :if-does-not-exist :create :if-exists :append))
                                        ;(print tiedClasses)
              (if (not (null successOrFailure))
                  (progn
                    (incf totalRight)
                    (format outputFile "~a ~a ~a ~a~%" 1 (length tiedClasses) tiedClasses (last attributeValues))
                    )
                  (format outputFile "~a ~a ~a ~a~%" 0 (length tiedClasses) tiedClasses (last attributeValues))
                  )
              (close outputFile)
                                        ;(print successOrFailure)
              ;(setf MyHyperPipes (AddExperienceNew MyHyperPipes (make-ExperienceInstance :attributes (remove-nth (- (length attributeValues) 1) attributeValues) :class (nth (- (length attributeValues) 1) attributeValues))))
              )
            )
        (incf currentLine)
        )
      ;(close outputFile)
      )
    ;(print (float (/ totalRight totalChecks)))
    ;(print Alpha)
    ;MyHyperPipes
    (setf outputFile (open outputFileName2 :direction :output :if-does-not-exist :create :if-exists :append))
    (format outputFile "~a~%" (float (/ totalRight totalChecks)))
    (close outputFile)
    
    
    )


  )


(defun GetTiedClasses(MyHyperPipes AttributeValues Alpha)
  (let* ((currentMax most-negative-fixnum)
         (HighestValue ())
         (DistributionResults (doDistributions (make-ExperienceInstance :attributes (remove-nth (- (length AttributeValues) 1) AttributeValues)) MyHyperPipes))
         (normalizedResults (normalizeResults DistributionResults))
         (minValue nil)
         (maxValue nil)
         (adjustmentValue nil)
         )
    (dolist (result normalizedResults)
      (if (>= (second result) currentMax)
          (setf currentMax (second result))
          )
      )

    (setf adjustmentValue (* currentMax Alpha))
    (setf minValue (- currentMax adjustmentValue))
    (setf maxValue (+ currentMax adjustmentValue))
    
    (dolist (result normalizedResults)
       (if (and (>= (second result) minValue) (<= (second result) maxValue))
           (setf HighestValue (append HighestValue (list (first result))))
           )
       )
    HighestValue
    )
  )

(defun GetTiedClasses2(MyHyperPipes AttributeValues Alpha countType meanType oldway)
  (let* ((currentMax most-negative-fixnum)
         (HighestValue ())
         (DistributionResults (doDistributions (make-ExperienceInstance :attributes (remove-nth (- (length AttributeValues) 1) AttributeValues)) MyHyperPipes countType meanType))
         (normalizedResults DistributionResults)
         ;(normalizedResults (normalizeResults DistributionResults))
         (minValue nil)
         (maxValue nil)
         (adjustmentValue nil)
         )
    (dolist (result normalizedResults)
      (if (>= (second result) currentMax)
          (setf currentMax (second result))
          )
      )
    ;(print normalizedResults)
    ;make it so it adjust the same for every one (1 up or 1 down etc... rather than depending on the currentMax
    ;(setf adjustmentValue (* (- (length AttributeValues) 1) Alpha))
    ;(setf adjustmentValue Alpha)
    (setf adjustmentValue (* currentMax Alpha))
    (setf minValue (- currentMax adjustmentValue))
    ;(print normalizedResults)
    ;(format t "currentMax: ~a adjustmentValue: ~a minValue: ~a~%" currentMax adjustmentValue minValue)
    ;(setf maxValue (+ currentMax adjustmentValue))
    
    (dolist (result normalizedResults)
;      (print result)
       (if (>= (second result) minValue)
           (progn
             ;(format t "Result ~a is greater than ~a~%" result minValue)
             (if (= oldway 1)
                 (setf HighestValue (list (first result)))
                 (progn 
                   (setf HighestValue (append (list (first result)) HighestValue ))
;                   (print "We appended")
                   )
                 )
             )
           )
       )
;    (print HighestValue)
    HighestValue
    )
  )


(defun FindCentroid(HyperPipes)
  (let ((currentCentroid nil)
        (currentMax 0))
    ;(print HyperPipes)
    (dolist (currentPipe HyperPipes)
      (let* ((currentCount 0)
            (pipeBounds (HyperPipe-numericBounds currentPipe))
            (numberOfAttributes (length pipeBounds))
            )
        (dolist (checkPipe HyperPipes)
          (if (not (equal currentPipe checkPipe))
              (progn
                (dotimes (i numberOfAttributes)
                  (let ((pipeBound (nth i pipeBounds))
                        (checkBound (nth i (HyperPipe-numericBounds checkPipe)))
                        (foundOverlap nil))
                    (if (or (and (> (NumericBound-min pipeBound) (NumericBound-min checkBound)) (< (NumericBound-min pipeBound) (NumericBound-max checkBound))) (and (< (NumericBound-max pipeBound) (NumericBound-max checkBound)) (> (NumericBound-max pipeBound) (NumericBound-min checkBound))))
                        (setf foundOverlap t)
                        )
                    (dolist (currentDiscrete (NumericBound-nonNumeric pipeBound))
                      (if (find currentDiscrete (NumericBound-nonNumeric checkBound))
                          (setf foundOverlap t)
                          )
                      )
                    (if foundOverlap
                        (incf currentCount)
                        )
                    )
                  )

                )
              )
          )
        ;(print (list currentCount (HyperPipe-class currentPipe)))
        (if (>= currentCount currentMax)
            (progn
              (setf currentMax currentCount)
              (setf currentCentroid currentPipe)
              )
            )
        )
      )
    (list currentMax (HyperPipe-class currentCentroid))
    )
  )


(defun calculateDistanceFromMean(min max mean value &optional (type 0))
  (if (or (= max min) (not (numberp value)))
      1
      (if (= type 0)
          (/
           (-
            (- max min)
            (abs (- value mean))
            )
           (- max min)
           )
          (let ((largestGap nil))
            (setf largestGap (max (- max mean) (- mean min)))
            (/ (- largestGap (abs (- value mean))) largestGap)
            )
          )
      )
  )


(defun TrimTiedClasses(tiedClasses MyHyperPipes useCentroid)
  (if (or (= 0 useCentroid) (null tiedClasses) (null MyHyperPipes) (< (length tiedClasses) 2))
      tiedClasses
      (progn
        (let ((listOfPipes ())
              (foundClass nil))
          (dolist (currentClass tiedClasses)
            (let ((currentFoundPipe (FindPipe MyHyperPipes currentClass)))
              (if (not (null currentFoundPipe))
                  (setf listOfPipes (append listOfPipes (list currentFoundPipe)))
                  )
  
              )
            )
          ;(print listOfPipes)
          (setf foundClass (FindCentroid listOfPipes))
          ;(print foundClass)
          (setf foundClass (list (second foundClass)))
          foundClass
          )


        )
      )
  )
