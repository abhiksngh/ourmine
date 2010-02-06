(defstruct (data (:print-function data-print)) 
  rows 
  (n 0) 
  (classes (make-hash-table)) 
  (h (make-hash-table :test 'equal)))

(defun data-print (d s k)
  (declare (ignore k))
  (format s "#S~a" 
          `(data n ,(data-n d) classes ,(data-classes d))))

