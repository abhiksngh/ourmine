; testing function for bins 
(deftest test-bins ()
    (let* ((nbins 10)
          (n-instances (negs (ar3)))) 
        (bins (class-sort (ar3)) nbins n-instances) ; sort the data into n bins
        (build-data-sets nbins) ; build train and test data sets from the bins
    )
)

;------------------------------------------------------------------------------
; SORTING FUNCTION - creates a file for each class of data
                 ; - all instances of that class are placed
                 ; - in that class file
; ARGUMENTS
 ; - INPUT: a table of data
 ; - RETURN: list of known classes
 ; - BYPRODUCT: creates a file for each class

; SORTING ALGORITHM
 ; read in an instance from the file
 ; if the class is unknown
    ; add to the list of known classes
 ; else
    ; write the instance to the class file for that class
;------------------------------------------------------------------------------
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

; search a list for a passed argument
(defun list-search (class-list class-arg)
    (let ((found nil))
        (dolist (per-class class-list)
            (if (equal per-class class-arg)
                (return-from list-search t)
                () ; do nothing
            ) 
        )
        (and found) ; return true if found
    )
)

;------------------------------------------------------------------------------
; BIN FUNCTION- places instances into n bins randomly and evenly

; ARGUMENTS
 ; - INPUT: a list of known classes, desired # of bins, total # of instances
 ; - OUTPUT: n bins of randomized data

; BIN ALGORITHM
; while the list of classes is not empty
    ; grab a class from the list of known classes
    ; for each instance of data in the class file
        ; randomly select one of the bins (files)
        ; while the bin is full
            ; move to the next bin
        ; place the value in the bin
;------------------------------------------------------------------------------
(defun bins (class-list nbins n-instances)
    ; create an array to track instance counts in each bin 
    (let* ((bin-count (make-array nbins 
                             :initial-element (ceiling (/ n-instances nbins)))))
        ; for each class in the class list
        (dolist (class-file class-list)
            (let* ((path (make-pathname :name (format nil "~A.dat" class-file)))
                   (instream (open path :direction :input))
                   (rand (random nbins)) ; random bin
                   (free (aref bin-count rand))) ; number of free spots in bin

                ; for each instance of data in the class file
                (loop for line = (read-line instream nil :eof) 
                      until (eql line :eof)
                    do
                    (loop until (/= free 0) ; search for a non-full bin
                          do
                              (setf rand (random nbins)
                                    free (aref bin-count rand))
                    )
                    ; write the instance to the bin
                    (let* ((bin-path (make-pathname 
                                     :name (format nil "./bins/~A.dat" rand)))
                           (outstream (open bin-path :direction :output
                                                     :if-exists :append
                                                     :if-does-not-exist :create)))
                        (format outstream "~A~%" line)
                        (setf (aref bin-count rand) (- (aref bin-count rand) 1)
                              rand (random nbins)
                              free (aref bin-count rand))
                        (close outstream)
                    )
                )
                (close instream)
                (delete-file path) ; clean up tmp files
            )
        )
    )
)

;------------------------------------------------------------------------------
; BUILD-DATA-SETS FUNCTION- constructs a test set of data from 10% of the data
;                           and a training set of data from the remaining 90%

; ARGUMENTS
 ; - INPUT: the number of files being used for data
 ; - OUTPUT: training and test data as seperate files train.dat & test.dat

; BUILD-DATA-SETS ALGORITHM
; build output streams for each file
; determine how many files will be used for test vs. train
; call the consolidate helper function to build sets
;------------------------------------------------------------------------------
(defun build-data-sets (nfiles)
    (let* ((test (ceiling (/ nfiles 10)))
           (test-path (make-pathname :name "./bins/test.dat"))
           (test-stream (open test-path :direction :output
                                        :if-exists :append
                                        :if-does-not-exist :create))
           (train-path (make-pathname :name "./bins/train.dat"))
           (train-stream (open train-path :direction :output
                                          :if-exists :append
                                          :if-does-not-exist :create)))

        (consolidate 0 (- test 1) test-stream)
        (consolidate test (- nfiles 1) train-stream)

    )
)

;------------------------------------------------------------------------------
; CONSOLIDATE FUNCTION- consolidates multiple files into a single file

; ARGUMENTS
 ; - INPUT: numbers indicating the start & end file names (all file names are
 ;          assumed to be of the form #.dat 
 ;          an output stream representing the file to be written to
 ; - OUTPUT: all output goes to the specified output stream

; CONSOLIDATE ALGORITHM
; for every file from start.dat to end.dat 
;  - read each lines in the file
;  - write the line to the specified output stream
; delete the file fragments
;------------------------------------------------------------------------------
(defun consolidate (start end out-stream) 
    (loop for i from start to end
        do
            (let* ((path (make-pathname :name (format nil "./bins/~A.dat" i)))
                   (instream (open path :direction :input)))
                (loop for line = (read-line instream nil :eof)
                      until (eql line :eof)
                    do
                        (format out-stream "~A~%" line)
                )
                (delete-file path)
            )
    )
    (close out-stream)
)
