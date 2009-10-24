(defun logHistResult(HyperPipes ReturnedClasses Actual)
  (dolist (currentClass ReturnedClasses)
    
    (let ((pipe (FindPipe HyperPipes currentClass)))
      (incf (HyperPipe-Guessed pipe))
      (if (equal currentClass Actual)
          (incf (HyperPipe-CorrectGuess pipe))
          )
      )
    )
  )

(defun detectOverfitHist (HyperPipes &optional (Interval 30) (Cutoff .35))
  (dolist (currentPipe HyperPipes)
    (if (> (HyperPipe-Guessed currentPipe) Interval)
        (progn

          (if (< (/ (HyperPipe-CorrectGuess currentPipe) (HyperPipe-Guessed currentPipe)) Cutoff)
              (if (> (HyperPipe-logged currentPipe) 0)
                  (progn
                    (revert-pipe currentPipe)
                    (format t "I did it I did it, yay! for ~a~%" (HyperPipe-class currentPipe))
                    )
                  )
              (logGoodPipe currentPipe)
              
              )


          (setf (HyperPipe-Guessed currentPipe) 0)
          (setf (HyperPipe-CorrectGuess currentPipe) 0)
          )
        )
    )
  )

(defun logGoodPipe(pipe)
   (setf (aref (HyperPipe-hist pipe) 0) (copyNumericBounds (HyperPipe-numericBounds pipe)))
   (incf (HyperPipe-logged pipe))
  )

(defun revert-pipe(pipe)
  (setf (HyperPipe-numericBounds pipe) (aref (HyperPipe-hist pipe) 0))
  )
