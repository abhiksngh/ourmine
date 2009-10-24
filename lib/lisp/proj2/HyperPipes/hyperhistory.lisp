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

(defun detectOverfitHist (HyperPipes &optional (Interval 100) (Cutoff .35) (outputFile t))
  (setf out-tmp (open "overfittinglog.txt" :direction :output :if-does-not-exist :create :if-exists :append))
  (dolist (currentPipe HyperPipes)
    (if (> (HyperPipe-Guessed currentPipe) Interval)
        (progn

          (if (< (/ (HyperPipe-CorrectGuess currentPipe) (HyperPipe-Guessed currentPipe)) Cutoff)
              (if (> (HyperPipe-logged currentPipe) 0)
                  (progn
                    (format out-tmp "BEGIN OLD:~%~a ~%" currentPipe)
                    (revert-pipe currentPipe)
                    (format out-tmp "BEGIN REVERTED:~% ~a ~%~%~%" currentPipe)
                    (format outputFile "#I did it I did it, yay! for ~a~%" (HyperPipe-class currentPipe))
                    )
                  )
              (logGoodPipe currentPipe)
              
              )


          (setf (HyperPipe-Guessed currentPipe) 0)
          (setf (HyperPipe-CorrectGuess currentPipe) 0)
          )
        )
    )
  (close out-tmp)
  )

(defun logGoodPipe(pipe)
   (setf (aref (HyperPipe-hist pipe) 0) (copyNumericBounds (HyperPipe-numericBounds pipe)))
   (incf (HyperPipe-logged pipe))
  )

(defun revert-pipe(pipe)
  (setf (HyperPipe-numericBounds pipe) (aref (HyperPipe-hist pipe) 0))
  )
