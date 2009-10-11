; oneR.lisp - Classifier
;
; Select for classes using one attribute
; NOTE: "Missing" is treated as a separate attribute value.

(defun oner (dataset)
  (let (
	(datatable (copy-table dataset))
	(classcount 0)
	(colindex nil)
	)
    ; Foreach column in the dataset
    (dolist (column (table-columns datatable))
      ; If the column is discrete.
      (if (typep column 'discrete)
	  (progn
	    (setf colindex (indexof column (table-columns datatable)))
	    (format t "Discrete? ~a~%Index ~a~%" (typep column 'discrete) colindex)
	    ; Foreach value in the column
	    (dolist (record (table-all datatable))
	      (format t "~a" (nth colindex (eg-features record)))
	      )
	    (format t "~%")
	    )
	  ))))
      ; Foreach value in column
      ; (dolist 


