;# a pre-processor that replaces numeric value N with

;    * log(N< 0.0001 ? 0.0001 : N)
; use sonar file from data set (mostly numeric attributes)
; open file for reading
; for each row
  ; for each column
     ; if numeric
        ; if less than .0001
           ; set to .0001
        ; perform log(n)
   ;
;

; testing function for the numerical value function
(deftest test-numval ()
    (let* ((path (make-pathname :name "proc_data.dat"))
           (str (open path :direction :output
                           :if-exists :supersede)))
        (numval (ar3) :stream str)
    )
)

; Replaces numerical values less than 0.0001 with 0.0001
;  and performs a log on all numerical data
;  Passes through all symbolic data untouched 
(defun numval (data &key stream)
    (format stream "~a~%" (table-name data))
    (let ((all-instances (table-all data)))
        (dolist (per-instance all-instances)
            (let* ((all-features (eg-features per-instance)))
                (format stream "(")
                (doitems (per-feature i all-features)
                    (if (numberp per-feature)
                        (if (< per-feature 0.0001)
                            (format stream "~A " (log 0.0001))
                            (format stream "~A " (log per-feature)))
                        (format stream "~A " per-feature)
                    )
                )
                (format stream ")~%")
            )
        )
    )
    (close stream)
)
