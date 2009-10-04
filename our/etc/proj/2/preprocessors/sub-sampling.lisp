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
(defun sub-sampling (data)
    (let* ((class-list (class-sort data)) ; sort data into class files
           (min-lines nil)
           (outstream (open "tmp.dat" :direction :IO
                                      :if-exists :supersede
                                      :if-does-not-exist :create))
           (eg-set))

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

        (loop for line = (read-line outstream nil :eof)
              until (eql line :eof)
            do
                (push line eg-set)
        )

        (close outstream)
        (delete-file "./tmp.dat")

        (data :name 'sub-samp-set
              :columns (columns-header (table-columns data))
              :egs eg-set
        )
    )
)

(defun class-sort (data)
    (let ((all-instances (table-all data))
          (classi (table-class data))
          (n-instances (negs data))
          (class-list (list )))

    ; for every instance, grab the class value
    (dolist (per-instance all-instances)
        (let* ((all-features (eg-features per-instance))
               (per-instance-class (nth classi all-features)))

            ; check class value against array of classes
            (if (list-search class-list per-instance-class)
                () ; if found, do nothing
                (setf class-list (append class-list (list per-instance-class)))
            )

            ; open a stream to that class file with name "stream"
            (let* ((path (make-pathname :name (format nil "~A.dat" per-instance-class)))
                   (stream (open path :direction :output
                                      :if-exists :append
                                      :if-does-not-exist :create)))
                ; write the instance to the class-file
                (doitems (per-feature i all-features)
                    (format stream "~A " per-feature)
                )
       
                (format stream "~%")
                (close stream)
            )
        )           
    )
      class-list ; return the list of valid classes
  )
)
