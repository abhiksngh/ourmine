(defun k-means (train &optional (k 10) (iteration 20))
  (let* ((instances (get-features (table-all train)))
         (class (table-class train))
         (size (length instances))
         (listK '())
         (lstCentroids '())
         (oldCentroids '())
         (clusters '())
         (tmpcounter 0))
    (dotimes (i k)
      (setf listK (cons (get-rand-k size listK) listK)))
    (setf lstCentroids (get-centroids listK instances))
    (setf oldCentroids (copy-tree lstCentroids))
    (setf clusters (make-clusters lstCentroids))
    (setf clusters (create-new-clusters instances lstCentroids clusters class))
    (setf lstCentroids (new-centroids clusters class))
    (dotimes (i iteration clusters)
        (if (or (check-all-centroids oldCentroids lstCentroids)
                (< tmpcounter iteration))
        (progn
          (setf clusters (create-new-clusters instances lstCentroids (make-clusters lstCentroids) class))
          (incf tmpcounter)
          (setf oldCentroids (copy-tree lstCentroids))
           ;(format t "Old Centorids ~A~%" oldCentroids)
          (setf lstCentroids (new-centroids clusters class)))
        (return-from k-means clusters)))))

   

    

;;move instances into clusters
(defun create-new-clusters (instances centroids clusters class)
  (dolist (inst instances clusters)
    (let* ((cls (calc-dist (remove (nth class inst) inst) centroids)))
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
(defun cluster-mean (cls class)
   (let* ((cluster (mapcar #'(lambda(l) (remove (nth class l) l)) cls))
          (sum (apply #'mapcar #'+ cluster))
          (len (length cluster)))
     (dolist (obj sum)
       (setf (nth (position obj sum) sum)(float (/ obj len))))
     sum))

;;define the new centroids
(defun new-centroids (lstClusters class)
  (let* ((lst '()))
    (dolist (cls lstClusters lst)
      (setf lst (append lst (list (cluster-mean cls class)))))))


(defun make-data-k ()
  (data
   :name   'weather
   :columns '($att1 $att2 $att3 $att4 cls) 
   :egs    '((10    5  45   20 yes) 
	     (3    56  4   10 no) 
	     (4    4  4   30  no) 
             (5    5  5   20.2 yes)
             (10    6  6   20.1 no)
             (34    67  64   20.7 yes)
             (10    5  45   20 yes) 
	     (3    56  4   10 yes) 
	     (4    4  4   30  no) 
             (5    5  5   20.2 yes)
             (10    6  6   20.1 yes)
             (34    67  64   20.7 yes)
             (10    5  45   20 yes) 
	     (6    56  4   10 yes) 
	     (8    4  4   30  no) 
             (9    5  5   20.2 no)
             (7    6  6   20.1 no)
             (6    67  64   20.7 no)
             (9    5  45   20 yes) 
	     (23    56  4   10 yes) 
	     (6    4  4   30  no) 
             (8    5  5   20.2 yes)
             (9    6  6   20.1 yes)
             (8    67  64   20.7 no)
             (10    5  4   20 no) 
	     (3    56  7   10 no) 
	     (4    4  67   30 yes) 
             (5    5  67   20.2 yes)
             (10    6  67   20.1 yes)
             (34    67  64   7.7 yes)
             (10    5  45   5 yes) 
	     (3    56  4   78 yes) 
	     (4    4  4   67  yes) 
             (5    5  5   45.2 yes)
             (10    6  6   67.1 yes)
             (34    67  64   67.7 no)
             )))


