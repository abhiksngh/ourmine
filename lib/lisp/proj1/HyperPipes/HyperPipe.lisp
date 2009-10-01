;Create one hyperpipe per class each hyperpipe will contain a list of bins(min and max for each attribute) and the class it was created for
(defun CreateHyperPipes (numberOfAttributes Classes)
  (let ((HyperPipes (list)))
    (dolist (currentClass Classes HyperPipes)
      (setf HyperPipes (append HyperPipes
                               (list (make-HyperPipe :numericBounds (let ((numericBounds (list)))
                                                                (dotimes (i numberOfAttributes numericBounds)
                                                                  (setf numericBounds (append numericBounds (list (make-NumericBound)))))) :class currentClass)))))))
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
    (print distributions)
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
              (incf Accuracy))
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
  (let ((fileStream (open (concatenate `string "HyperPipes/Data/" fileName))))
    (print (read-line fileStream))
    (print "next line:")
    (print (read-line fileStream))
    )
  )
 
