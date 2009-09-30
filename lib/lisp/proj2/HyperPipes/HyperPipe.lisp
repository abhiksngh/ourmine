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
          (print "adding new pipe")
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



(defun doDistributions (newExperience HyperPipes)
  (let ((distributions (list)))
    (dolist (pipe HyperPipes distributions)
      ;(print (HyperPipe-class pipe))
      ;(print (calculateDistribution pipe newExperience))
      (setf distributions (append distributions (list (list (HyperPipe-class pipe) (calculateDistribution pipe newExperience)))))
    
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


(defun demoHyperPipesNew(&optional (dataFileName "primary-tumor"))
  (print "*************Demoing HyperPipes**************")
  ;(load (concatenate `string "HyperPipes/Data/" dataFileName ".lisp"))

  (let ((MyHyperPipes (list))
        (totalChecks 0)
        (totalRight 0)
        (outputFile (open "outputFile.txt" :direction :output :if-does-not-exist :create :if-exists :overwrite)))
    (with-open-file (stream (concatenate `string "proj2/HyperPipes/Data/" dataFileName ".lisp"))
      (do ((line (read-line stream nil) (read-line stream nil))) ((null line))
        (let* ((attributeValues (eval (read-from-string line)))
               (tiedClasses (GetTiedClasses MyHyperPipes attributeValues))
               (successOrFailure (find (nth (- (length attributeValues) 1) attributeValues) tiedClasses))
               )
          (format t "~%Expected Result: ~a Actual Result: ~a" (nth (- (length attributeValues) 1) attributeValues) tiedClasses)
          (incf totalChecks)
          (if (not (null successOrFailure))
              (progn
                (incf totalRight)
                (format outputFile "~a ~a~%" 1 (length tiedClasses))
                )
              (format outputFile "~a ~a~%" 0 (length tiedClasses))
              )
          (print successOrFailure)
          (setf MyHyperPipes (AddExperienceNew MyHyperPipes (make-ExperienceInstance :attributes (remove-nth (- (length attributeValues) 1) attributeValues) :class (nth (- (length attributeValues) 1) attributeValues))))
          )
        )
      )
    (print (/ totalRight totalChecks))
    MyHyperPipes
    )



    ;
    ;(let ((Accuracy 0)
    ;      (Total 0))

    ;(dolist (currentDataPoint (table-all dataTable))
    ;  (let* ((currentAttributes (EG-features currentDataPoint))
    ;         (DistributionResults (doDistributions (make-ExperienceInstance :attributes (remove-nth (table-class dataTable) (eg-features currentDataPoint))) MyHyperPipes))
    ;         (normalizedResults (normalizeResults DistributionResults)))
    ;    (let ((HighestValue ())
    ;          (currentMax most-negative-fixnum))


    ;      (dolist (result normalizedResults)
    ;        (if (>= (second result) currentMax)
    ;            (progn
    ;              (if (= (second result) currentMax)
    ;                  (setf HighestValue (append HighestValue (list (first result))))
    ;                  (setf HighestValue (list (first result)))
    ;                  )
    ;              (setf currentMax (second result))
                 
    ;              )
    ;            )
            
    ;        )
    ;      (if (find (nth (table-class dataTable) (eg-features currentDataPoint)) HighestValue)
    ;          (incf Accuracy))
    ;      (incf Total)
    ;      (format t "~%Expected Result: ~a Actual Result: ~a" (nth (table-class dataTable) (eg-features currentDataPoint)) HighestValue)
    ;      )
    ;    )
    ;  )
    ;(format t "~%~%The accuracy is ~a" (/ Accuracy Total))
    ;)
    ;(setf MyQuestion (make-ExperienceInstance :attributes '(365 8000 400 98 blue)))
    ;(print MyHyperPipes)
    ;(setf distributions (doDistributions MyQuestion MyHyperPipes))
    ;(print distributions)
    ;(setf distributions (normalizeResults distributions))
    ;(print distributions)
    ;)
  )

(defun GetTiedClasses(MyHyperPipes AttributeValues)
  (let* ((currentMax most-negative-fixnum)
        (HighestValue ())
        (DistributionResults (doDistributions (make-ExperienceInstance :attributes (remove-nth (- (length AttributeValues) 1) AttributeValues)) MyHyperPipes))
        (normalizedResults (normalizeResults DistributionResults)))
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
    HighestValue
    
    )
  )

(defun FindCentroid(HyperPipes)
  (let ((currentCentroid nil)
        (currentMax 0))
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
        (print (list currentCount (HyperPipe-class currentPipe)))
        (if (> currentCount currentMax)
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


