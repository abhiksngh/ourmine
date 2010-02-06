(defstruct (data (:print-function data-print)) 
  rows 
  (h       (make-hash-table :test 'equal))
  (classes (make-hash-table))
)

(defun data-print (d s k)
  (declare (ignore k))
  (format s "#S~a" 
          `(data  classes ,(data-classes d))))

