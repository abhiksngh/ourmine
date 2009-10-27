(defstruct BestPipeHistory class (oldPipes (make-array 10)) (pipeIndex 0) (oldRows (make-array 100)) (rowIndex 0) (rowsLogged 0))

(defun logBestPipeRow(PipeHistories attributeValues)
  (let ((pipe (FindHistoryPipe PipeHistories (car (last attributeValues)))))
    ;(print pipe)
    (if (> (BestPipeHistory-rowIndex pipe) 99)
        (setf (BestPipeHistory-rowIndex pipe) 0)
        )
    (setf (aref (BestPipeHistory-oldRows pipe) (HyperPipe-rowIndex pipe)) attributeValues)
    (incf (BestPipeHistory-rowsLogged pipe))
    )
  )

(defun logBestPipePipe(PipeHistories currentPipe)
  (let ((pipe (FindHistoryPipe PipeHistories (car (last attributeValues)))))
    (if (null pipe)
        (progn
          (setf PipeHistories (append PipeHistories (list (make-BestPipeHistory :class (car (last attributeValues))))))
          (setf pipe (FindHistoryPipe PipeHistories (car (last attributeValues))))
          )
        )
    ;(print pipe)
    (if (> (BestPipeHistory-pipeIndex pipe) 9)
        (setf (BestPipeHistory-pipeIndex pipe) 0)
        )
    (setf (aref (BestPipeHistory-oldPipes pipe) (HyperPipe-pipeIndex pipe)) attributeValues)
    )
  )


(defun FindHistoryPipe (PipeHistories class)
  (dolist (currentPipe PipeHistories)
    (if (eql (BestPipeHistory-class currentPipe) class)
        (return-from FindHistoryPipe currentPipe)
        )
    )
  nil
  )

(defun logBestPipeResult(HyperPipes ReturnedClasses Actual)
  (dolist (currentClass ReturnedClasses)
    
    (let ((pipe (FindPipe HyperPipes currentClass)))
      (incf (HyperPipe-Guessed pipe))
      (if (equal currentClass Actual)
          (incf (HyperPipe-CorrectGuess pipe))
          )
      )
    )
  )

(defun detectBestPipeOverfit(HyperPipes &optional (Interval 30) (Cutoff .35) (outputFile t))
  (dolist (currentPipe HyperPipes)
    (if (> (HyperPipe-Guessed currentPipe) Interval)
        (progn
          (logBestPipePipe PipeHistories currentPipe)
          (if (< (/ (HyperPipe-CorrectGuess currentPipe) (HyperPipe-Guessed currentPipe)) Cutoff)
              (progn
		 ;test accuracy of all pipes in PipeHistories for this class
                
                )
              )


          (setf (HyperPipe-Guessed currentPipe) 0)
          (setf (HyperPipe-CorrectGuess currentPipe) 0)
          )
        )
    )
  )
