;; K-Means++
;; Randomly pick one center, k, from the data-set
;; Calculate distance, D(k), for each record from the current center
;; Pick another center with the probability of D(k)^2
;; Continue until k centers have been choose

;; Main function for executing k-means++ clusterer
(defun k-means(k-data-set k)
	(let* (
               (cp-table (copy-table k-data-set))
               (egs-total (negs k-data-set))
               (number-of-centroids 1)
               (centroid0 (create-centroid egs-total))
               (centroid-list (list centroid0))
               (distance-table)
               (distance-transposed)
               (clusters)
               )
               
		
		;; Create our other centroids based on probability of D(X)^2
		;; We shouldn't need to care what position each centroid is in the list
		;; as we can just take each row number individually and do whatever
		;; Also, create our distance-table to compute closet instance to each centroid
          (dotimes (number-of-centroids k)
            (setf centroid-list (push (create-centroid egs-total centroid-list) centroid-list)))
          (print "centroid list")
          (print centroid-list)

          (setf distance-table (create-distance-table egs-total centroid-list))
          (print distance-table)
          
          (setf distance-transposed (transpose distance-table))
          (print distance-transposed)
               
			
          ;Put each instance with it's respective centroid
          (setf cluster-g (create-cluster-groups distance-transposed centroid-list ))

          ;(print clusters)
               		
          )
        )
       
		
;; Pick a random point to be our centroid if first centroid
;; Otherwise pick new centroid based on D(X)^2
;; I'm sure there's a more optimal way to do this
(defun create-centroid(num &optional (clist '()))
	(let (
              (n (random num))
              (randomNumber)
              )
		(if (eql clist nil)
                    (setf randomNumber n)
                    (if (member n clist)
                        (create-centroid num clist)
                        (setf randomNumber n)))))

;; Create a distance table for each centroid
(defun create-distance-table(num clist &optional (temp-list '()))
	   (let* ((n temp-list)
		 (z)
		 (m (car clist))
		 (o 1)
                 (final-list)
                 )
			(dotimes (o num)
				(push (abs (- (- m o) 1)) z))
				(setf z (reverse z))
				(if (eql (cdr clist) nil) (setf final-list (push z temp-list))
					(create-distance-table num (cdr clist) (push z temp-list)))))

;; Create our clusters
;; Goes through our transposed table to check for the least value to the centroid
;; Once the least value is found, push it to a list or push X if group contains a centroid
(defun create-cluster-groups (groups centroid-list &optional (temp-list '()))
	(let* (
              (l1 temp-list)
              (final-list)
              (temp-var)
              (temp-list2 '())
              (element)
              (element2)
              (n)
              (mm))
          
         
          (print "creating cluster groups")
          (print "transposed distance-table")
          (print groups)

          (dolist (n groups); element)
           
            (setf temp-var nil)
            (dolist (m n); element2)
 
              (if (eql temp-var nil)
                  (setf temp-var (+ m 1))
                  (cond ((eql m 0) (setf temp-var '(x)); if distance = 0, is centroid
                         (lt m temp-var) (setf temp-var  m))))); find least value
                  

            (if (eql temp-var 0)
                (setf temp-var 'x))
            
            (push temp-var temp-list))
        
                                        ;(progn
        (setf final-list (reverse temp-list))))

;(defun get-data (table)
;  (let ((table-data))
;    (mapcar #'eg-features (table-all table))))

;; Check to see if clusters are no longer movable
;(defun check-movable() )

;; Calculate the mean of our two selected points in our centroid
(defun calculate-centroid-mean(cent-list)
  (let* ((sum 0)
         )
    (dolist (number cent-list)
      (setf sum (+ sum number)))
    (/ sum (length cent-list))))

