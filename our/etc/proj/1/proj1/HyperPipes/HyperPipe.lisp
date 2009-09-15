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
  (let ((pipe (FindPipe pipes (ExperienceInstance-class experience))))
     (dotimes (current (length (ExperienceInstance-attributes experience)) pipe)
       (let ((currentBound (nth current (HyperPipe-numericBounds pipe)))
             (currentExperience (nth current (ExperienceInstance-attributes experience))))
         (if (not (null currentExperience))
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
    (if (= (HyperPipe-class pipe) class)
        (return-from FindPipe pipe)))
  (return-from FindPipe nil)
  )

;Calculate distribution of attribute ranges it falls in vs it doesnt

(defun calculateDistribution (pipe newExperience)
  (let ((count 0)
        (numAttributes (length (ExperienceInstance-attributes newExperience))))
    (dotimes (current numAttributes pipe)
      (let ((currentBound (nth current (HyperPipe-numericBounds pipe)))
            (currentExperience (nth current (ExperienceInstance-attributes newExperience))))
        (if (or
             (and (not (null currentExperience))
                  (not (numberp currentExperience))
                  (member currentExperience (NumericBound-nonNumeric currentBound)))
             (and (numberp currentExperience)
                 (>= currentExperience (NumericBound-min currentBound))
                 (<= currentExperience (NumericBound-max currentBound))))
            (incf count))
        ))
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
   


(defun demoHyperPipes()
  (print "*************Demoing HyperPipes**************")
  (setf MyHyperPipes (CreateHyperPipes 5 '(0 1 2)))
  (print MyHyperPipes)
  
  (AddExperience MyHyperPipes (make-ExperienceInstance :attributes '(289 17548 245 76 yellow) :class 0))
  (AddExperience MyHyperPipes (make-ExperienceInstance :attributes '(685 9029 289 84 red) :class 0))
  (AddExperience MyHyperPipes (make-ExperienceInstance :attributes '(342 10000 200 100 yellow) :class 0))
  (AddExperience MyHyperPipes (make-ExperienceInstance :attributes '(543 18392 180 95 red) :class 0))
  (AddExperience MyHyperPipes (make-ExperienceInstance :attributes '(21 4674 313 343 red) :class 1))
  (AddExperience MyHyperPipes (make-ExperienceInstance :attributes '(64 6859 587 1864 green) :class 1))
  (AddExperience MyHyperPipes (make-ExperienceInstance :attributes '(45 3948 394 321 red) :class 1))
  (AddExperience MyHyperPipes (make-ExperienceInstance :attributes '(81 5000 432 891 blue) :class 1))
  (AddExperience MyHyperPipes (make-ExperienceInstance :attributes '(-23 1180 65 2300 yellow) :class 2))
  (AddExperience MyHyperPipes (make-ExperienceInstance :attributes '(8 1008 42 1097 orange) :class 2))
  (setf MyQuestion (make-ExperienceInstance :attributes '(365 8000 400 98 blue)))
  (print MyHyperPipes)
  (setf distributions (doDistributions MyQuestion MyHyperPipes))
  (print distributions)
  (setf distributions (normalizeResults distributions))
  (print distributions)
  )