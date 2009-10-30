;;Returns a list of clusters containing a single cluster.
(defun default-clusterer (tbl &optional (k 1))
  (update-table-centroid tbl)
  (list tbl))

;;Randomly selects k rows from tbl and then creates a cluster with no rows
;;for each one.  Returns a list of clusters.
(defun get-random-clusters (tbl k)
  (setf tbl (table-deep-copy tbl))
  (let ((all-rows (get-table-rows tbl))
        (clusters nil))
    (setf (table-all tbl) nil)
    (dotimes (i k)
      (let ((randomi (random (length all-rows)))
            (new-cluster (table-deep-copy tbl)))
        (setf (table-centroid new-cluster) (nth randomi all-rows))
        (setf all-rows (remove (nth randomi all-rows) all-rows))
        (push new-cluster clusters)))
    clusters))

;;Returns the cluster from clusters that has the smallest distance to instance.
(defun get-nearest-cluster (instance clusters)
  (let ((nearest-cluster nil)
        (nearest-cluster-distance most-positive-fixnum)
        (distance 0))
    (dolist (cluster clusters)
      (setf distance (euclid-distance instance (get-table-centroid cluster) cluster))
      (if (< distance nearest-cluster-distance)
        (setf nearest-cluster-distance distance
              nearest-cluster cluster)))
    nearest-cluster))

;;Returns a list of k clusters from tbl.
(defun kmeans (tbl k)
  (setf tbl (table-deep-copy tbl))
  (let ((clusters (get-random-clusters tbl k))
        (rows (get-table-rows tbl)))
    (do ((centroid-changed t))
        ((not centroid-changed))
      (mapcar #'delete-table-rows clusters)
      (dolist (row rows)
        (push row (table-all (get-nearest-cluster row clusters))))
      (setf centroid-changed nil)
      (dolist (cluster clusters)
        (let ((prev-centroid (eg-deep-copy (get-table-centroid cluster))))
          (update-table-centroid tbl)
          (if (not (equalp prev-centroid (get-table-centroid cluster)))
            (setf centroid-changed t)))))
    clusters))

(deftest kmeans-test ()
  (check
    (and
      (equalp nil (set-difference (table-all (ar5)) (table-all (car (kmeans (ar5) 1))) :test #'equalp))
      (equalp (length (table-all (ar5))) (length (table-all (car (kmeans (ar5) 1))))))))



