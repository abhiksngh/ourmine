(defun max-w (w)
  (let ((max (* -1 most-positive-single-float)))
    (dolist (ele w max)
      (if (> ele max)
          (setf max ele)))))
    
;(defun prob-surviv (index w)
;  (let ((sum 0))
;    (dolist (i w)
;      (incf sum (aref w 1)))
;    (/ (aref w index) sum)))
    
(defun move-center (alist w record)
  (let ((rtnlist)
        (n 0))
    (dolist (ele alist)
      (setf rtnlist (cons rtnlist (/(+ (* w ele) (nth n record)) (+ w 1))))
      (incf n))
    rtnlist))

(defun gen-centroids (tbl m &optional(factor 1.0))
  (let ((alist (sample-population (normalize-table tbl) m factor))
        (rtnlist))  
    (dotimes (n m rtnlist)
      (push (eg-features (pop alist)) rtnlist))))

(defun new-center (tbl)
   (elt (gen-centroids tbl 2)0))
      
(defun closest-cluster (record c &key (distance nil))
  (let ((min most-positive-single-float)
        (rtnlist)
        (dist 0))
    
    (dolist (ele c)
      (setf dist (eg-distance record ele))
      (if (< dist min)
          (progn
            (setf min dist)
            (setf rtnlist ele)))
      (setf dist 0))

    (if distance
        min
        rtnlist)))
    

     
;Genic
;Params   k = fixxed number of centers
;         n = size of each generation
;optional m = multiple of k centers default 2
(defun genic(tbl k &optional(multi 2))
  (let* ((m (* multi k))
;         (rtnlist)
         (w (make-hash-table))
         (c (gen-centroids tbl m)))  
;         (index 0)
;         (count 0))))
    (dolist (ele c)
      (setf (gethash ele w) 1))))

   ; (dolist (record (table-all tbl))
    ;  (min-distance record c)
      
;      (incf count)
;      (setf index (min-distance record c))
;;     (setf (nth index c) (move-center (nth index c) (aref w index) (eg-features record)))
;     (incf (aref w index))
;
;      (when (=(mod count n) 0)
;        (dolist (i w)
;          (when (< (prob-surviv i w) (park-miller-randomizer))
 ;           (setf (nth i c) (new-center tbl m))
;            (setf (aref w i) 1))))
;      )
;    (while (< rtnlist k)
;      (setf rtnlist (cons rtnlist (nth (next-best-w w) c))))
;    (setf (table-columns tbl) (append (table-columns tbl) `(,(make-discrete :name 'clusters)))) 
;    (dolist (record (table-all tbl) tbl)
;      (setf (eg-features record)
;            (append (eg-features record) (format nil "~a" (min-distance rtnlist)))))
;  ))         
          


    
      
   
