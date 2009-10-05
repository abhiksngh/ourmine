(defun test-data()
  (data
   :name 'test
   :columns '($number1 symbol $number2 stuff)
   :egs '((0 bye 1 true)
          (.2 hey 1 true)
          (.5 hey 1 true)
          (1 hey 1 false)
          (1 bye 1 false)
          (.7 hey 1 false)
          (.3 bye 1 true)
          (0 bye 1 false)
          )))

(defun kmeans (k)
  (let* ((tbl (xindex (test-data)))
         (centroid-list (kmeans-find-centroid k (f tbl))) ;create a numeric list of what rows are centroids
         (centroid0 '()) ;list for actual centroid data
         (n 0))
    (dolist (i centroid-list) ;this grabs the centroid data
      (push (nth i (table-all tbl)) centroid0)) ;puts the centroid data in centroid0
    (dolist (row (table-all tbl)) ;checks all rows for distance
      (if (member n centroid-list) ;if the row being checked is already a centroid
          '(centroid) ;does nothing
          (kmeans-distance centroid0 row (table-columns tbl))) ;finds which centroid is closest to the row
      (setf n (+ n 1)))))


(defun kmeans-find-centroid (k length)
  (let ((centroid-list '())) 
    (if (<= k length) ;if there is going to be more centroids then rows of data
        (progn
          (dotimes (n k)
            (let ((number (random length))) ;choose a centroid random
              (if (member number centroid-list) ;checks if the random number is already in the list
                  (setf n (- n 1)) ;if it was already in the list subtract 1 from n
                  (push number centroid-list)))) ;if it wasn't already in the list push it onto the list
          (sort centroid-list #'<))))) ;sort so I could read it better when testing it

(defun kmeans-move-centroid ())

(defun kmeans-distance (centroids row columns)
  (let ((n 0)
        (i 0)
        (closenode 0)
        (distance1 0)
        (distance2 0))
    (dolist (centroid centroids closenode) ;go through the list of centroids
      (dolist (datan (eg-features row)) ;go through the data
        (if (numericp (header-name (nth n columns))) ;if the column is numeric do number comparison
            (setf distance1 (+ distance1 (- (* datan datan) (* (nth n (eg-features centroid)) (nth n (eg-features centroid)))))) ;a squared - b squared
            (progn
              (if (samep datan (nth n (eg-features centroid))) ;if the discrete data is the same then do nothing
                  '(nothing)
                  (setf distance1 (+ distance1 1))))) ;if it was different add 1 to the difference
        (setf n (+ n 1))) ;counter to track which data is being checked
      (if (= i 0) ;if it was the first centroid looked at do stuff
          (progn
            (setf distance2 distance1) ;so we can compare data
            (setf closenode 0) ;say that the first centroid was closest to the row
            (setf i 1)) ;increase the centroid looked at by 1
          (progn
            (if (< distance1 distance2) ;if the new distance from the ith centroid is less then the original
                (progn
                  (setf closenode i) ;say that the ith centroid is closest to the row
                  (setf i (+ i 1)) ;increase the centroid being looked at
                  (setf distance2 distance1))))) ;set the current best centroid as distance2
      (setf n 0)))) ;restart the data counter
