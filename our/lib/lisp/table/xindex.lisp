
;; xindex runs over the data and populates the "counts" of each column header.
(defun xindex (tbl)
  (dolist (eg (table-all tbl) tbl)
    (print (eg-features eg))
    (mapc #'(lambda (header datum) 
	      (xindex-datum header  
			    (eg-class eg) datum)) 
	  (table-columns tbl) 
	  (eg-features eg)))) 

(defmethod xindex-datum ((column discrete) class  datum)
  (let* ((key `(,class ,datum))
	 (hash (header-f column)))
    (incf (gethash key hash 0))))

(defmethod xindex-datum ((column numeric) class  datum)
  (let* ((key      class)
	 (hash     (header-f column))
	 (counter  (gethash  key hash (make-normal))))
    (setf (gethash key hash) counter) ; make sure the hash has the counter
    (add counter datum)))

