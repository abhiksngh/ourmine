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

(defun kmeans (k)
  (let* ((tbl (xindex (test-data2)))
        (centroid-list (kmeans-find-centroid k (f tbl))) ;create a numeric list of what rows are centroids
        (centroid0 '()) ;list for actual centroid data
        (n 0)
        (done-moving nil))
    (dotimes (i (length centroid-list));this grabs the centroid data
      (push (nth (nth i centroid-list) (table-all tbl)) centroid0)) ;puts the centroid data in centroid0
    (setf centroid0 (reverse centroid0))
    (let ((cluster '())) ;creates a list that will have each centroid with a list to itself to store the rows
      (dolist (i centroid-list) 
        (push '() cluster))
      (setf cluster (reverse cluster))
      (dolist (row (table-all tbl)) ;checks all rows for distance
        (if (member n centroid-list) ;if the row being checked is already a centroid
            '(centroid) ;does nothing
            (push row (nth (kmeans-distance centroid0 row (table-columns tbl)) cluster))) ;finds which centroid is closest to the row and then pushes the row to the cluster list
        (incf n))
      (dotimes (i (length centroid-list)) ;do each centroid to find the median
        (let ((new-centroid nil))
          (setf new-centroid (kmeans-move-centroid (nth i cluster) (nth i centroid0) (table-columns tbl))) ;move the centroids in the cluster list
          (if (samep new-centroid (nth i centroid0))
              (progn
                (if (= i 0)
                    (setf done-moving t)
                    (progn
                      (if (equal done-moving nil)
                          '(nothing)
                          (setf done-moving t)))))
              (progn
                (setf (nth i centroid0) new-centroid)
                (setf done-moving nil))))))))
              
(defun kmeans-find-centroid (k length)
  (let ((centroid-list '())) 
    (when (<= k length) ;if there is going to be more centroids then rows of data
      (dotimes (n k centroid-list)
        (let ((number (random length)));choose a centroid random
          (if (member number centroid-list) ;checks if the random number is already in the list
              (decf n) ;if it was already in the list subtract 1 from n
              (push number centroid-list)))))));if it wasn't already in the list push it onto the list

(defun kmeans-move-centroid (cluster centroid columns)
  (let ((n 0))
    (dolist (col columns centroid)
      (if (numericp (header-name col))
          (progn
            (let ((number-list '()))
              (dolist (row cluster)
                (if (numberp (nth n (eg-features row)))
                    (push (nth n (eg-features row)) number-list))
              (setf number-list (qsort number-list))
              (if (oddp (length number-list))
                  (setf (nth n (eg-features centroid)) (nth (floor (/ (length number-list) 2)) number-list))
                  (setf (nth n (eg-features centroid)) (even-numeric-median number-list)))))))
          (progn
            (let ((freq-list '())
                  (freq-count '()))
              (dolist (row cluster)
                (push (nth n (eg-features row)) freq-list))
              (dolist (row freq-list)
                (if (member row freq-count)
                    (progn
                      ( ))
                    (push `(,row 1) freq-count)))
              )) ;find the most common symbol
      (incf n))))
                
       
(defun kmeans-distance (centroids row columns)
  (let ((i 0)
        (distance1 0)
        (distance2 0)
        (close-cent 0))
    (dolist (current-cent centroids close-cent) ;do every centroid and return which was the best
      (let ((n 0)) ;to keep an eye on which column of data is being looked at
        (dolist (datan (eg-features row)) ;check the rows data
          (if (numericp (header-name (nth n columns))) ;if that column is header
              (progn
                (if (and (numberp datan) (nth n (eg-features current-cent))) ;makes sure that both data are numbers
                    (setf distance1 (+ distance1 (square (- datan (nth n (eg-features current-cent)))))) ;(row - distance) squared
                    (incf distance1))) ;if the row or the centroid had blank data or ? just say it's distance is 1
              (progn
                (if (samep datan (nth n (eg-features
                                         current-cent))) ;if discrete check if the symbol is the same
                    '(nothing) ;if it is the same do nothing
                    (incf distance1)))) ;if it is different add 1
          (incf n))) ;increase the column being checked
      (setf distance1 (sqrt distance1)) ;once all columns are done take the square root of it
      (if (= i 0) ;if this was the first centroid being checked it becomes the current best
          (setf distance2 distance1) ;distance2 is the current best
          (progn
            (when (< distance1 distance2) ;if the current centroid is better then last it becomes the best
              (setf close-cent i) 
              (setf distance2 distance1))))
      (setf distance1 0) ;reset the current distance
      (incf i)))) ;do the next centroid


(defun even-numeric-median (numbers)
  (let ((f (nth (- (/ (length numbers) 2) 1) numbers))
        (s (nth (/ (length numbers) 2) numbers)))
    (/ (+ f s) 2)))


(defun qsort (list)
  (if (<= (length list) 1)
      list
      (progn
        (let ((pivot (car list))
              (less-then '())
              (great-then '()))
          (dolist (n (cdr list) (append (qsort less-then) `(,pivot) (qsort great-then)))
            (if (<= n pivot)
                (push n less-then)
                (push n great-then)))))))

