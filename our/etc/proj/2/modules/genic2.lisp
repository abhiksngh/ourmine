;Genic
;Params   k = fixxed number of centers
;         n = size of each generation
;optional m = multiple of k centers default 2
(defun Genic(tbl k n &optional(multi 2))
  (let* ((m (* multi k))
         (rtntable (table-clone tbl))
         (w (make-array m :initial-element 1))
         (c (gen-centroids rtntable m))
         (mindis)
         (count 0))

    (dolist (record (table-all rtntable))
      (incf count)
      (setf mindis (Euclidean-distance c record))
      (setf (aref c mindis)
    )   
  ))     
    

(defun gen-centroids (tbl m &optional(factor .01))
  (let ((alist (sample-population (normalize-table tbl) m factor))
        rtnlist)
    (dotimes (n m rtnlist)
      (push rtnlist (eg-features (pop alist))))))

(defun min-distance (record c)
  (let ((min most-positive-single-float)
        fthis
        fthat
        (n 0))
    (dolist (ele c)
      (if (numberp ele)
          (progn
            (setf fthis (cons fthis ele))
            (setf fthat (cons fthat (nth n (eg-features record))))
            (incf n))
          (
     
            
          
          

    
      
   
