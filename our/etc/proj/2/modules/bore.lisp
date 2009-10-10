; bore.lisp
;
; Implements the BORE pre-processor.

(defun bore (dataset columnnames)
  (let ((normalval (make-array (length columnnames) :initial-element nil))
	(datatable (copy-table dataset)))
    (dolist (record (table-all datatable))
      (format t "~a~%" record))))
