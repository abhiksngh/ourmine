;Genic
;Params   k = fixxed number of centers
;         n = size of each generation
;optional m = multiple of k centers default 2
(defun Genic(tbl k n &optional(multi 2))
  (let* ((m (* multi k))
         (rtntable (table-clone tbl))
         (w (make-array m :initial-element 1))
         (c (gen-centroids rtntable m))
         index
         (count 0))

    (dolist (record (table-all rtntable))
      (incf count)
      (setf index (min-distance record c))
      (setf (nth index c) (move-center (nth index c) (aref w index) (eg-features record)))
      (incf (aref w index))

      (when (count ***mod n = 0)
        (dolist (i w)
          (when (< (prob-surviv i w) (park-miller-randomizer))
            (setf (nth i c) (new-center rtntable m))
            (setf (aref w i) 1))))
      ) 
  ))     

(defun prob-surviv (index w)
  (let ((sum 0))
    (dolist (i w)
      (incf sum (aref w 1)))
    (/ (aref w index) sum)))
    
(defun move-center (alist w record)
  (let ((rtnlist)
        (n 0))
    (dolist (ele alist)
      (setf rtnlist (cons rtnlist (/(+ (* w ele) (nth n record)) (+ w 1))))
      (incf n))
    rtnlist))

(defun new-center (tbl m)
  (pop (gen-centroids tbl m)))

(defun gen-centroids (tbl m &optional(factor .01))
  (let ((alist (sample-population (normalize-table tbl) m factor))
        rtnlist)
    (dotimes (n m rtnlist)
      (push rtnlist (eg-features (pop alist))))))

(defun min-distance (record c)
  (let ((min most-positive-single-float)
        fthis
        index
        (count 0)
        (n 0))
    (dolist (ele c)
      (dolist (item ele)
        (if (numberp item)
            (setf fthis (cons fthis item))
            (progn  
              (if (equal item (nth n (eg-features record)))
                  (setf fthis (cons fthis 0))
                  (setf fthis (cons fthis 1)))))
        (incf n))
      (setf n 0)
      (when (< (distance fthis) min)
        (setf min (distance fthis))
        (setf index count))
      (incf count))
    index))
     
            
          
          

    
      
   
