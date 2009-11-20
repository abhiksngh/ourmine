(defun max-w (w)
  (let ((max most-negative-fixnum))
    (maphash (lambda (key value)
               (declare (ignore key))
               (when (> value max)
                 (setf max value))) w)
    max))
    
(defun prob-surviv (center w)
  (let ((sum 0))
    (maphash (lambda (key value) (declare (ignore key)) (incf sum value)) w)
    (/ (gethash center w) sum)))

(defun move-center (w center record tbl)
  (let ((rtnlist)
        (n 0))
    (dolist (ele center rtnlist)
      (when (typep (nth n (table-columns tbl)) 'numeric)
        (setf rtnlist (append rtnlist (list (/ (+ (* w ele) (nth n record)) (+ w 1))))))
      (when (typep (nth n (table-columns tbl)) 'discrete)
        (setf rtnlist (append rtnlist (list (coin-flip ele (nth n record))))))
      (incf n))))

(defun gen-centroids (tbl m &optional(factor 1.0))
  (let ((alist (sample-population tbl m factor))
        (rtnlist))  
    (dotimes (n m rtnlist)
      (push (eg-features (pop alist)) rtnlist))))

(defun new-center (tbl)
   (elt (gen-centroids tbl 2)0))
      
(defun closest-cluster (record c &key (distance nil))
  (let ((min most-positive-single-float)
        (rtnlist)
        (dist 0))
    
    (dolist (ele c)
      (setf dist (eg-distance record ele))
      (if (< dist min)
          (progn
            (setf min dist)
            (setf rtnlist ele)))
      (setf dist 0))

    (if distance
        min
        rtnlist)))
    
     
;Genic
;Params   k = fixxed number of centers
;         n = size of each generation
;optional m = multiple of k centers default 2
(defun genic(tbl k n &optional(multi 2))
  (let* ((m (* multi k))
         (w (make-hash-table :test #'equal))
         (c (gen-centroids tbl m))  
         (center)
         (tmp-center)
         (count 0))
    
    (dolist (ele c)
      (setf (gethash ele w) 1))

    (dolist (record (table-all tbl))
      (setf center (closest-cluster (eg-features record) c))
      (incf (gethash center w))
      (setf tmp-center (move-center (1- (gethash center w)) center (eg-features record) tbl))
      (setf c (substitute tmp-center center c))
      (setf (gethash tmp-center w) (gethash center w))
      (remhash center w)
      
      (incf count)

      (when (= (mod count n) 0)
        (dolist (ele c)
          (when (< (prob-surviv ele w) (park-miller-randomizer))
            (setf tmp-center (new-center tbl))
            (setf c (substitute tmp-center center c))
            (remhash center w)
            (setf (gethash tmp-center w) 1)))))
    (subseq (sort (copy-list c) #'> :key (lambda (x) (gethash x w))) 0 k)))



(defun genic2 (tbl k &optional (n (floor (/ (length (table-all tbl)) 10))) (multi 2))
  (let* ((m (* multi k))
         (w (make-hash-table :test #'equal))
         (c (gen-centroids tbl m))  
         (center)
         (tmp-center)
         (count 0))
    
    (dolist (ele c)
      (setf (gethash ele w) 1))

    (dolist (record (table-all tbl))
      (setf center (closest-cluster (eg-features record) c))
      (when (null (gethash center w))
        (setf (gethash center w) 1))
      (incf (gethash center w))
      (setf tmp-center (move-center (1- (gethash center w)) center (eg-features record) tbl))
      (setf c (substitute tmp-center center c))
      (setf (gethash tmp-center w) (gethash center w))
      (remhash center w)
      
      (incf count)
      (when (= (mod count n) 0)
        (let ((threshold (/ (max-w w) 2))
              (things-killed 0))
          (dolist (cluster c)
            (if (null (gethash cluster w))
              (setf (gethash cluster w) 1))
            (when (< (gethash cluster w) threshold)
              (setf c (remove cluster c))
              (remhash cluster w)
              (incf things-killed)))
          (when (= things-killed 0)
            (setf k (floor (* 1.5 k)))
            (when (< (length c) k)
              (let ((diff (- k (length c))))
                (dotimes (i diff)
                  (setf tmp-center (new-center tbl))
                  (setf (gethash tmp-center w) 1)
                  (push tmp-center c))))))))
    (if (< (length c) k)
        c
        (subseq (sort (copy-list c) #'> :key (lambda (x) (gethash x w))) 0 k))))
