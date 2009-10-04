;------------------------------------------------------------------------------
; EQUAL-WIDTH FUNCTION - discretizes the designated columns in the passed 
;                      - data set into N equal-width bins (only numeric)
;                      - N can be supplied, defaulted to 10, or calculated
;                      - via bin-logging algorithm by supplying a flag
; ARGUMENTS
 ; - INPUT: a table of data, a list of columns to discretize, the output
 ;          filename (Optional: number of bins N, flag for bin-logging)
 ; - RETURN: N/A
 ; - BYPRODUCT: creates a file with discretized data

; EQUAL-WIDTH ALGORITHM
; find the minimum and maximum values for each column of data
; calculate the bin-sizes based upon N and the min/max values
; convert the data into discretized form
;------------------------------------------------------------------------------
(defun equal-width (data col-list &key N bin-logging)
    (let* ((all  (table-all data))
          (max-array (buildDataArr data)) 
          (min-array (buildDataArr data))
          (bin-sizes (buildDataArr data)))

        (when (not col-list) ; nil flag indicates all columns should be used
            (setf col-list (build-list (table-width data)))
        )

        ; generate arrays of min/max for each column
        (build-arrays data min-array max-array col-list)

        ; find bin sizes based on data range and number of bins
        (cond 
            ((and N) (find-bin-sizes min-array max-array N bin-sizes))
            ((and bin-logging) 
             (find-bin-sizes min-array max-array (bin-log data col-list) bin-sizes))
            (t (find-bin-sizes min-array max-array 10 bin-sizes))
        )

        ; discretize the numeric data into the spec'd bins
        (convert-values data min-array bin-sizes)
    )
)

;-------------
(defun build-list (n)
    (let ((new-list (list )))
        (loop for i from 0 to n
            do
                (setf new-list (append new-list (list i)))
        )
        new-list 
    )
)

;------------------------------------------------------------------------------
; BUILD-ARRAYS FUNCTION - get the min and max values for each column

; ARGUMENTS
 ; - INPUT: a table of data, a list of columns, arrays to track min/max vals
 ; - RETURN: returns min and max arrays by reference
 ; - BYPRODUCT: N/A

; BUILD-ARRAYS ALGORITHM
; for each record
;  for each column in the column list
;    if the value is numeric
;      if there is no previous min/max recorded
;        set the min/max to current data 
;      else
;        if the value is less than current min, or greater than the max
;          set a new current min or max
;        else - do nothing
;------------------------------------------------------------------------------
(defun build-arrays (data min-array max-array col-list)
    (let ((all-instances (table-all data))
          (classi (table-class data))) ; which column is the class
        (dolist (per-instance all-instances) 
            (let* ((all-features (eg-features per-instance))
                   (per-instance-class (nth classi all-features)))
                (doitems (per-feature i all-features)
                    (unless (not (list-search col-list (+ i 1)))             
                        (unless (unknownp per-feature) ; 
                            (cond ((numberp per-feature) 
                                (if (grabValue max-array i) ; check for nil
                                    (if (> per-feature (grabValue max-array i))
                                        (setValue max-array per-feature i)
                                        () ; do nothing
                                    )
                                    (setValue max-array per-feature i)
                                )
                                (if (grabValue min-array i)
                                    (if (< per-feature (grabValue min-array i))
                                        (setValue min-array per-feature i)
                                        () ; do nothing
                                    )
                                    (setValue min-array per-feature i)
                                ))
                                
                            )
                        )
                    )
                )
            )
        )
    )
)

;------------------------------------------------------------------------------
; FIND-BIN-SIZES FUNCTION - calculate the bin sizes for each column

; ARGUMENTS
 ; - INPUT: arrays of min / max vals, a value of N bins, array for bin-sizes
 ; - RETURN: array of bin-sizes by reference
 ; - BYPRODUCT: N/A

; EQUAL-WIDTH ALGORITHM
; for every column of data
;   calculate the bin size based on min, max and N
;------------------------------------------------------------------------------
(defun find-bin-sizes (min-array max-array N bin-sizes)
    (let* ((max-val 0) (min-val 0) (i 0) (tmp 0) (len (length min-array)))
        (loop until (= i len)
            do
                (cond ((aref min-array i)
                    (setf min-val (aref min-array i))
                    (setf max-val (aref max-array i))
                    (cond ((listp N) 
                           (setf tmp (car N)))
                          (t (setf tmp N))
                    )
                    (setf tmp (/ (- max-val min-val) tmp ))
                    (setf (aref bin-sizes i) tmp)
                ))
                (setf i (+ i 1))
        )
    )
)

(defun setValue (arr value i)
    (setf (aref arr i) value)
)

(defun grabValue (arr i)
    (aref arr i)
)

(defun buildDataArr (data)
    (make-array (table-width data) :initial-element nil)
)

;------------------------------------------------------------------------------
; CONVERT-VALUES FUNCTION - discretize the passed data and place it into
;                           the new file 'filename'
; ARGUMENTS
 ; - INPUT: a set of data, an array of min values, the bin-sizes, filename
 ; - RETURN: N/A
 ; - BYPRODUCT: creates a file 'filename' full of discretized data

; CONVERT-VALUES ALGORITHM
; for every instance of data
;   for every feature of the instance
;   if the value isn't nil (representing no discretization)
;     run the value through the discretization function
;     write the new value to the new file
;   else
;     write the original value to the new file
;------------------------------------------------------------------------------
(defun convert-values (data min-array bin-sizes)
    (let* ((all-instances (table-all data))
           (str (open "./tmp.dat" :direction :IO
                                  :if-exists :supersede
                                  :if-does-not-exist :create))
           (eg-set))
    
        (dolist (per-instance all-instances)
            (let* ((all-features (eg-features per-instance)))
                (format str "(")
                (doitems (per-feature i all-features)
                    (if (aref min-array i) 
                        (format str "~A " (floor (/ (- per-feature (aref min-array i)) (aref bin-sizes i))))
                        (format str "~A " per-feature)
                    )
                )
            )
            (format str ")~%")
        )

        ; read all instances from the file and build instance list
        (loop for line = (read-line str nil :eof)
              until (eql line :eof)
            do
                (push line eg-set)
        )

        (close str)
        (delete-file "./tmp.dat") ; clean up tmp file

        ; build new data-set
        (data :name 'disc-set
              :columns (columns-header (table-columns data))
              :egs eg-set
        )
    )
)

;------------------------------------------------------------------------------
; BIN-LOG FUNCTION - calculate N for each column in the col-list using
;                    the bin-logging formula 
; ARGUMENTS
 ; - INPUT: a set of data, list of columns to calculate N for
 ; - RETURN: list of values of N (one for each column)
 ; - BYPRODUCT: N/A

; BIN-LOG ALGORITHM
; for every column in the col-list
;   calculate the value of N for the column
; return the list of value for N
;------------------------------------------------------------------------------
(defun bin-log (data col-list)
    (let* ((n-list (list )))
        (dolist (col col-list) 
            (setf n-list (append n-list (list (ceiling (log (unique-vals data col) 2)))))
        )
        n-list
    )
)

;------------------------------------------------------------------------------
; UNIQUE-VALS FUNCTION - calculate the # of unique values for a column of data
; ARGUMENTS
 ; - INPUT: a set of data, the column to count unique values
 ; - RETURN: the number of unique values in the column
 ; - BYPRODUCT: N/A

; UNIQUE-VALS ALGORITHM
; for each instance of data
;   if the column value has been seen before
;     do nothing
;   else
;     add the value to a list of known values
; count the length of the value list
;------------------------------------------------------------------------------
(defun unique-vals (data col)
    (let* ((all-instances (table-all data))
           (vals (list )))
        (dolist (per-instance all-instances)
            (let* ((all-features (eg-features per-instance)))
                (doitems (per-feature i all-features)
                    (when (= i col) ; only selected cols
                        (if (list-search vals per-feature)
                            () ; do nothing
                            (setf vals (append vals (list per-feature)))
                        )
                    )
                )
            )
        )
        (length vals)
    )
)
