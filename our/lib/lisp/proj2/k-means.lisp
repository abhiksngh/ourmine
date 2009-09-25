(defun k-means (train &optional (k 2))
  (let* ((instances (get-features (table-all train)))
         (size (length instances))
         (listK '())
         (lstCentroids '())
         (clusters '()))
    (dotimes (i k)
      (setf listK (cons (get-rand-k size listK) listK)))
    (setf lstCentroids (get-centroids listK instances))
    (setf clusters (make-clusters lstCentroids))
    (dolist (inst instances clusters)
      (let* ((cls (calc-dist inst lstCentroids)))
        (setf (nth cls clusters) (cons inst (nth cls clusters)))))))
      



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
