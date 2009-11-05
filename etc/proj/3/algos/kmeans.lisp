;;; K-Means:

;;; Claimee: Elijah

(print " - Loading k-Means") ;; Output for a pretty log

(defun deep-copy-clusters (clusters)
  (dolist (cluster clusters clusters)
     (setf cluster (make-eg :features (copy-list (eg-features cluster)) :class (eg-class cluster)))))

(defun new-random-centroids (table &optional (num-needed 1))
  (if (> num-needed (length (table-all table)))
      (setf num-needed (length (table-all table))))
  (let ((newclusters nil) (num-fields (length (table-all table))))
    (dotimes (n num-needed newclusters)
      (setf newclusters (append (list (nth (random num-fields) (table-all table))) (deep-copy-clusters newclusters)))
    )
  )
)

(defun compute-euclidean-distance (cluster row columns)
  (let ((summ 0) 
        (c (eg-features cluster))
        (r (eg-features row)))
    (dotimes (i (length c))
      (if (numeric-p (nth i columns))
          (setf summ (+ summ (expt (- (nth i c) (nth i r)) 2)))))
    (sqrt summ)))

(defun classify-row (clusters row columns)
  (let ((assignment -1) (temp 0) (distance 0))
    (dotimes (i (length clusters)) 
      (if (or (< (setf temp (compute-euclidean-distance (nth i clusters) row columns)) distance) (= assignment -1))
          (progn (setf assignment i)
                 (setf distance temp)))) assignment))

(defun classify-table (clusters table)
  (let ((assignments NIL))
    (dolist (row (table-all table) assignments)
      (setf assignments (append assignments (list (classify-row clusters row (table-columns table))))))))

;;;(defun adjust-cluster (cluster table assignments)
;;;  (let 

(defun set-cluster-numeric-means (clusters table assignments)
  (let ((counts NIL))
    (dotimes (i (length clusters) clusters)
      (dotimes (j (length (table-all table)))
        (if (= i (nth j assignments))
            (progn 
             (dotimes (k (length (eg-features (nth j (table-all table)))))
              (if (numeric-p (nth k table-columns table))
                  (setf (nth k (eg-features (nth i clusters))) (+ (nth k (eg-features (nth i clusters))) (nth k (eg-features (nth j (table-all table))))))))
             (      
