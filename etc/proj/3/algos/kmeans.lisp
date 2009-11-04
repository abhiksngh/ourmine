;;; K-Means:

;;; Claimee: Elijah

(print " - Loading k-Means") ;; Output for a pretty log

(defun new-random-centroid (table &optional (num-needed 1))
  (let ((newclusters nil) (num-fields (length (table-all table))))
    (dotimes (n num-needed newclusters)
      (setf newclusters (append (list (nth (random num-fields) (table-all table))) newclusters))
    )
  )
)

(defun compute-euclidian-distance 


