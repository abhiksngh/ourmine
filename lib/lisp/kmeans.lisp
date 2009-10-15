(defun test-data2()
  (data
   :name 'test
   :columns '($number1 symbol $number2 stuff)
   :egs '((0.0 bye 1.0 true)
          (0.2 hey 1.0 true)
          (0.5 hey 1.0 true)
          (1.0 hey 1.0 false)
          (1.0 bye 1.0 false)
          )))

;;KMEANS
;;This function clusters all the rows around centroids
;;Parameters: k, the amount of centroids to create
;;Returns: ?
;;Author David Asselstine

(defun kmeans (k)
  (let* ((tbl (xindex (test-data2)))
         (centroid-list (kmeans-find-centroid k (f tbl)))
         (centroid0 '())
         (rem-rows '())
         (done nil))
    (dolist (i centroid-list)
      (push (nth i (table-all tbl)) centroid0)) 
    (setf centroid0 (reverse centroid0))
    (dotimes (i (f tbl))
      (if (not (member i centroid-list))
        (push (nth i (table-all tbl)) rem-rows)))
    (loop while (not done) do
         (let ((cluster '())
               (n 0))
           (dotimes (i (length centroid-list))
             (push '() cluster))
           (dolist (row rem-rows)
             (push row (nth (kmeans-closest-centroid centroid0 row (table-columns tbl)) cluster)))
           (dolist (current-clust cluster)
             (let ((new-centroid (kmeans-move-centroid current-clust (nth n centroid0) (table-columns tbl))))
               (if (= n 0)
                   (if (samep new-centroid (nth n centroid0))
                       (setf done t)
                       (setf (nth n centroid0) new-centroid))
                   (if (not (samep new-centroid (nth n centroid0)))
                       (progn
                         (setf (nth n centroid0) new-centroid)
                         (setf done nil)))))
             (incf n))))))
                          
;;KMEANS-MOVE-CENTROID
;;Moves centroids to the median of all rows closest to it
;;Parameters: cluster, rows that are closest to centroid. centroid, centroid being moved. columns, the columns
;;Returns: the new centroids features
;;Author David Asselstine

(defun kmeans-move-centroid (cluster centroid columns)
  (let ((n 0))
    (dolist (col columns centroid)
      (if (numericp (header-name col))
          (let ((number-list '()))
            (dolist (row cluster)
              (if (numberp (nth n row))
                  (push (nth n row) number-list))
              (setf number-list (qsort number-list))
              (setf (nth n centroid) (numeric-median number-list))))
          (let ((freq-list '()))
            (dolist (row cluster)
              (push (nth n row) freq-list))
            (setf (nth n centroid) (most-freq-symbol freq-list))))
      (incf n))))

;;KMEANS-FIND-CENTROID
;;Randomly chooses k rows to be centroids
;;Parameters: k, number of centroids to be found. length, total number of rows available
;;Returns: list with the row numbers for the centroids
;;Author David Asselstine

(defun kmeans-find-centroid (k length)
  (let ((centroid-list '())) 
    (when (<= k length)
      (dotimes (n k centroid-list)
        (let ((number (random length)))
          (if (member number centroid-list)
              (decf n) 
              (push number centroid-list)))))))
                
;;KMEANS-CLOSEST-CENTROID
;;It finds which centroid is closest to the row being checked
;;Parameter: centroids, list of the centroids. row, the row being checked. columns
;;Returns: Number corresponding to the closest centroid
;;Author David Asselstine

(defun kmeans-closest-centroid (centroids row columns)
  (let ((best-centroid 0)
        (distance 0)
        (i 0))
    (dolist (current-cent centroids best-centroid)
      (if (= i 0)
          (setf distance (euc-distance row current-cent columns))
          (progn
            (when (< (euc-distance row current-cent columns) distance)
              (setf distance (euc-distance row current-cent columns))
              (setf best-centroid i))))
      (incf i))))
