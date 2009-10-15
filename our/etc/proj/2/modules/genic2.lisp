;Genic
;Params   k = fixxed number of centers
;         n = size of each generation
;optional m = multiple of k centers default 2
(defun Genic(tbl k n &optional(multi 2))
  (let* ((m (* multi k))
         (rtnlist)
         (w (make-array m :initial-element 1))
         (c (gen-centroids tbl m))
         index
         (count 0))

    (dolist (record (table-all tbl))
      (incf count)
      (setf index (min-distance record c))
      (setf (nth index c) (move-center (nth index c) (aref w index) (eg-features record)))
      (incf (aref w index))

      (when (=(mod count n) 0)
        (dolist (i w)
          (when (< (prob-surviv i w) (park-miller-randomizer))
            (setf (nth i c) (new-center tbl m))
            (setf (aref w i) 1))))
      )
    w
  ))

(defun genic2(tbl (k 10) n &optional(multi 2))
  (let* ((m (* multi k))
         (w (make-array m :initial-element 1))
         (c (gen-centroids tbl m))
         index
         (count 0))

    (dolist (record (table-all tbl))
      (incf count)
      (setf index (min-distance record c))
      (setf (nth index c) (move-center (nth index c) (aref w index) (eg-features record)))
      (incf (aref w index))

      (when (=(mod count n) 0)
        (dolist (i w)
          (when (< (prob-surviv i w) (park-miller-randomizer))
            (setf (nth i c) (new-center rtntable m))
            (setf (aref w i) 1))))
      )

(defun max-w (w)
  (let (max (* -1 most-positive-single-float))
    (dolist (ele w)
      (if (> ele max)
          (setf max ele)))
    max))
    
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
     
            
          
          

    
      
   
