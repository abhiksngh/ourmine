(deftest test-numval ()
    (let* ((data (numval (ar3)))
          (all-instances (table-all data)))
        (dolist (per-instance all-instances)
            (let ((all-features (eg-features per-instance)))
                (dolist (per-feature all-features)
                    (format t "~A " per-feature)
                )
            )
            (format t "~%")
        )
    )
)

; Replaces numerical values less than 0.0001 with 0.0001
;  and performs a log on all numerical data
;  Passes through all symbolic data untouched
; Returns the processed table 
(defun numval (data)
    (let* ((str (open "./tmp.dat" :direction :output
                                  :if-exists :supersede))
          (eg-set)) 

        ; build file of processed instances
        (let ((all-instances (table-all data)))
            (dolist (per-instance all-instances) ; for every instance
                (let* ((all-features (eg-features per-instance)))
                    (format str "(")
                    (doitems (per-feature i all-features) ; for every feature
                        (when (/= 0 i) (format str " "))
                        (if (numberp per-feature)
                            (if (< per-feature 0.0001)
                                (format str "~A" (log 0.0001))
                                (format str "~A" (log per-feature)))
                            (format str "~A" per-feature)
                        )
                    )
                    (format str ")~%")
                )
            )
        )
        (close str)

        (setf str (open "./tmp.dat" :direction :input))

        ; read all instances from the file and build instance list
        (loop for line = (read-line str nil :eof)
              until (eql line :eof)
            do
                (push line eg-set)
        )
       
        (close str)
        (delete-file "./tmp.dat") ; clean up tmp file

        ; build new data-set
        (data :name 'log-set
              :columns (columns-header (table-columns data))
              :egs eg-set
        )
    )
)

