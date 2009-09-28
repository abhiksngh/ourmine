; testing function for the sub-sampling function
(defun test-sampling ()
    (sub-sampling (ar3) "data_sub.dat")
)

;------------------------------------------------------------------------------
; SUB-SAMPLING FUNCTION - 
; ARGUMENTS
 ; - INPUT: a table of data, an output filename
 ; - RETURN: N/A
 ; - BYPRODUCT: creates a file of sub-sampled data

; SUB-SAMPLING ALGORITHM
; sort the data by class into files (ie. each file contains all instances)
; for each class file
;   record the number of entries in the file
; select the file with the minimum number of entries
; for each class file
;   write n lines from the class file to a new compiled data file
;     (where n is the minimum number of data entries from a class)
;------------------------------------------------------------------------------
(defun sub-sampling (data outfile)
    (let* ((class-list (class-sort data)) ; sort data into class files
           (min-lines nil)
           (outstream (open outfile :direction :output
                                    :if-exists :supersede
                                    :if-does-not-exist :create)))
        ; for every class file
        (dolist (class-value class-list)
            (let* ((path (make-pathname :name (format nil "./~A.dat" class-value)))
                   (instream (open path :direction :input))
                   (line-count 0))

                ; count the number of lines in the file
                (loop for line = (read-line instream nil :eof)
                      until (eql line :eof)
                    do
                        (setf line-count (+ line-count 1))
                )

                ; update the minimum number of lines
                (if (and min-lines)
                    (if (< line-count min-lines)
                        (setf min-lines line-count)
                        () ; do nothing
                    )
                    (setf min-lines line-count)
                )
                (close instream)
            )
        )

        ; for every class file
        (dolist (class-value class-list)
            (let* ((path (make-pathname :name (format nil "./~A.dat" class-value)))
                   (instream (open path :direction :input))
                   (line-count 0))

                ; write the minimum number of lines to the new data file
                (loop for line = (read-line instream nil :eof)
                      until (= line-count min-lines)
                    do
                        (format outstream "~A~%" line)
                        (setf line-count (+ line-count 1))
                )
                (close instream)
                (delete-file path)
            )
               
        )
        (close outstream)
    )
)
