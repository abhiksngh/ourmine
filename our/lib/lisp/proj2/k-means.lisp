(defun k-means (train &optional (k 2))
  (let* ((instances (get-features (table-all train)))
         (size (length instances))
         (listK '())
         (lstCentroids '())
         (oldCentroids '())
         (clusters '()))
    (dotimes (i k)
      (setf listK (cons (get-rand-k size listK) listK)))
    (setf lstCentroids (get-centroids listK instances))
    (setf oldCentroids (copy-tree lstCentroids))
    (setf clusters (make-clusters lstCentroids))
    (setf clusters (create-new-clusters instances lstCentroids clusters))
    (setf lstCentroids (new-centroids clusters))
    (do ()
       ( (check-all-centroids oldCentroids lstCentroids) clusters)
      (setf clusters (create-new-clusters instances lstCentroids (make-clusters lstCentroids)))
      (setf oldCentroids (copy-tree lstCentroids))
      ;(format t "Old Centorids ~A~%" oldCentroids)
      (setf lstCentroids (new-centroids clusters)))))
      ;(format t "New Centorids ~A~%" lstCentroids))))
      
    


    

;;move instances into clusters
(defun create-new-clusters (instances centroids clusters)
  (dolist (inst instances clusters)
    (let* ((cls (calc-dist inst centroids)))
      (setf (nth cls clusters) (cons inst (nth cls clusters))))))


;; determine all the centroids have moved
(defun check-all-centroids (oldcents newcents)
  (if (or (null oldcents)
          (null newcents))
      t
      (if (not (centroids-move (car oldcents) (car newcents)))
          (return-from check-all-centroids nil)
          (check-all-centroids (cdr oldcents) (cdr newCents)))))

;; determine if the centroids have moved
(defun centroids-move (oldcents newcents &optional (indx 0))
  (if (not (equal (nth indx oldcents)
                  (nth indx newcents)))
      (return-from centroids-move nil)
      (if (= indx (length oldcents))
          (return-from centroids-move t)
          (centroids-move oldcents newcents (incf indx)))))

;;get random position from the total size
(defun get-rand-k (size lst)
  (let* ((rand (random size)))
    (while (member rand lst)
      (setf rand (random size)))
    rand))

;;get the centroids in the random positions
(defun get-centroids (pos instances)
  (if (null pos) nil
      (cons (nth (car pos) instances) (get-centroids (cdr pos) instances))))


;;calculate the distance from a list of centroids
(defun calc-dist (inst lstCentroids)
  (let* ((wins (car lstCentroids))
         (max (euc inst wins)))
    (dolist (obj (cdr lstCentroids))
      (let ((score (euc inst obj)))
        (when (< score max)
          (setf wins obj))))
    (position wins lstCentroids)))

;;make clusters from centroids
(defun make-clusters (lstCentroids)
  (if (null lstCentroids) nil
      (cons (list (car lstCentroids)) (make-clusters (cdr lstCentroids)))))

;;claculate mean of clusters
(defun cluster-mean (cluster)
   (let* ((sum (apply #'mapcar #'+ cluster))
          (len (length cluster)))
     (dolist (obj sum)
       (setf (nth (position obj sum) sum)(float (/ obj len))))
     sum))

;;define the new centroids
(defun new-centroids (lstClusters)
  (let* ((lst '()))
    (dolist (cls lstClusters lst)
      (setf lst (append lst (list (cluster-mean cls)))))))


(defun make-data-k ()
  (data
   :name   'weather
   :columns '($att1 $att2 $att3 $att4)
   :egs    '((10    5  45   20 ) 
	     (3    56  4   10 ) 
	     (4    4  4   30  ) 
             (5    5  5   20.2 )
             (10    6  6   20.1 )
             (34    67  64   20.7)
             (10    5  45   20 ) 
	     (3    56  4   10 ) 
	     (4    4  4   30  ) 
             (5    5  5   20.2 )
             (10    6  6   20.1 )
             (34    67  64   20.7)
             (10    5  45   20 ) 
	     (6    56  4   10 ) 
	     (8    4  4   30  ) 
             (9    5  5   20.2 )
             (7    6  6   20.1 )
             (6    67  64   20.7)
             (9    5  45   20 ) 
	     (23    56  4   10 ) 
	     (6    4  4   30  ) 
             (8    5  5   20.2 )
             (9    6  6   20.1 )
             (8    67  64   20.7)
             (10    5  4   20 ) 
	     (3    56  7   10 ) 
	     (4    4  67   30  ) 
             (5    5  67   20.2 )
             (10    6  67   20.1 )
             (34    67  64   7.7)
             (10    5  45   5 ) 
	     (3    56  4   78 ) 
	     (4    4  4   67  ) 
             (5    5  5   45.2 )
             (10    6  6   67.1 )
             (34    67  64   67.7)
             )))


