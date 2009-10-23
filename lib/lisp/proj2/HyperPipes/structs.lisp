(defstruct ExperienceInstance attributes class)

(defstruct HyperPipe numericBounds class (hist (make-array 100)) (histIndex 0) (Guessed 0) (CorrectGuess 0) (logged 0))

(defstruct NumericBound (min most-positive-fixnum) (max most-negative-fixnum) (mean nil) (numOccured 0) (nonNumeric (list)))

(defun copyNumericBounds (inputBounds)
  (let ((newBounds ()))
    (dolist (bound inputBounds newBounds)
      (setf newBounds (append newBounds (list (copy-numericbound bound))))
      )
    )
  )
