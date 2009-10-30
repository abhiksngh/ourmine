;;Returns k randomly selected rows from tbl.
(defun get-k-instances (tbl k)
  (setf tbl (table-deep-copy tbl))
  (let ((all-rows (get-table-rows tbl))
        (select-rows nil))
    (dotimes (i k)
      (let ((randomi (random (length all-rows))))
        (push (nth randomi all-rows) select-rows)
        (setf all-rows (remove (nth randomi all-rows) all-rows))))
    select-rows))

;;Returns the centroid that is closest to row.
(defun get-nearest-centroid (tbl row centroids)
  (let ((nearest-centroid nil)
        (nearest-centroid-distance most-positive-fixnum))
    (dolist (centroid centroids)
      (let ((centroid-distance (euclid-distance row centroid tbl)))
        (if (< centroid-distance nearest-centroid-distance)
          (setf nearest-centroid-distance centroid-distance
                nearest-centroid centroid))))
    nearest-centroid))

;;Returns the mean of the values in columni if it is an ordered column.
(defun get-column-average (rows columni)
  (let ((sum 0))
    (dolist (row rows)
      (incf sum (nth columni (eg-features row))))
    (/ sum (length rows))))

;;Returns a new centroid for each centroid in centroid-rows.
(defun get-new-centroids (tbl centroid-rows)
  (let ((new-centroids nil))
    (maphash #'(lambda (k v) 
                (let ((new-centroid (eg-deep-copy k)))
                  (doitems (column-header columni (get-table-column-headers tbl))
                    (if (column-header-orderedp column-header)
                      (setf (nth columni (eg-features new-centroid)) (get-column-average v columni))))
                  (push new-centroid new-centroids)))
             centroid-rows)
    new-centroids))

;;Returns a new table structure for each centroid in centroid-rows.
(defun get-new-clusters (tbl centroid-rows)
  (let ((new-clusters nil))
    (maphash #'(lambda (k v)
                (let ((new-cluster nil))
                  (setf new-cluster (table-deep-copy tbl))
                  (setf (table-all new-cluster) v)
                  (push new-cluster new-clusters)))
             centroid-rows)
    new-clusters))

;;Returns a list of k table structures.
(defun kmeans (tbl k)
  (setf tbl (table-deep-copy tbl))
  (let ((centroids (get-k-instances tbl k))
        (rows (get-table-rows tbl))
        (centroid-rows (make-hash-table)))
    (do ((prev-centroids nil))
        ((equalp centroids prev-centroids))
      (clrhash centroid-rows)
      (dolist (row rows)
        (push row (gethash (get-nearest-centroid tbl row centroids) centroid-rows)))
      (setf prev-centroids centroids)
      (setf centroids (get-new-centroids tbl centroid-rows)))
    (get-new-clusters tbl centroid-rows)))

(deftest kmeans-test ()
  (check
    (and
      (equalp nil (set-difference (table-all (ar5)) (table-all (car (kmeans (ar5) 1))) :test #'equalp))
      (equalp (length (table-all (ar5))) (length (table-all (car (kmeans (ar5) 1))))))))

;;Stub for a clusterer that returns a list of table structures containing only the training
;;set.
(defun default-clusterer (k train)
	k
	(list train))

;;Stub for a function that returns the closest cluster to an instance.
;;Returns the first cluster in clusters.
(defun get-cluster (instance clusters)
	instance
	(car clusters))

;;Training function for naive bayes.  Takes a table structure of training data and 
;;returns the same table structure with index data.
(defun nb-train (train)
	(xindex train))

;;Takes an instance and a table structure containing training data and returns
;;a symbol representing the predicted class of the instance.
(defun nb-classify (instance train)
	(bayes-classify instance train))

;;Takes a table structure of test data and a list of symbols representing the
;;predicted classes for each instance in the test data and returns 4 hash tables
;;indexed by class, containing the A, B, C, and D measures for each class.
(defun p-metrics (test results)
	(let ((a (make-hash-table)) ;;tn
		    (b (make-hash-table)) ;;fn
		    (c (make-hash-table)) ;;fp
		    (d (make-hash-table)));;tp
		(dolist (class (get-table-classes test))
		  (mapcar #'(lambda (want got)
		            (cond ((and (not (equalp want class))
		                        (not (equalp got class)))
		                    (inch class a))
		                  ((and (equalp want class)
		                        (not (equalp got class)))
		                    (inch class b))
		                  ((and (not (equalp want class))
		                        (equalp got class))
		                    (inch class c))
		                  ((and (equalp want class)
		                        (equalp got class))
		                    (inch class d))))
		          (mapcar #'eg-class (get-table-rows test))
		          results))
    (values a b c d)))

(defun statistics-output (stats &key (file-name nil))
  (let ((str (or (not file-name) (open file-name :direction :output :if-exists :supersede))))
    (format str "prep, row-reducer, discretizer, cluster, fss, classify, class, a, b, c, d, acc, prec, pd, pf, f, g~%")
    (dolist (stat stats)
      (format str "~a, ~a, ~a, ~a, ~a, ~a, ~a, ~a, ~a, ~a, ~a, ~,1F, ~,1F, ~,1F, ~,1F, ~,1F, ~,1F~%" 
        (string-downcase (format nil "~a" (function-name (nth 0 stat))))
        (string-downcase (format nil "~a" (function-name (nth 1 stat))))
        (string-downcase (format nil "~a" (function-name (nth 2 stat))))
        (string-downcase (format nil "~a" (function-name (nth 3 stat))))
        (string-downcase (format nil "~a" (function-name (nth 4 stat))))
        (string-downcase (format nil "~a" (function-name (nth 5 stat))))
        (string-downcase (format nil "~a" (nth 6 stat)))
        (nth 7 stat)
        (nth 8 stat)
        (nth 9 stat)
        (nth 10 stat)
        (* 100 (nth 11 stat))
        (* 100 (nth 12 stat))
        (* 100 (nth 13 stat))
        (* 100 (nth 14 stat))
        (* 100 (nth 15 stat))
        (* 100 (nth 16 stat))))
    (if file-name (close str))))

(defun learner (train test &key (k 1)
                              (prep #'identity) ;Takes 1 table returns 1 table
                              (row-reducer #'(lambda (train test) train))
                              (discretizer #'identity) ;Takes 1 table returns 1 table
                              (clusterer #'default-clusterer) ;Takes k and 1 table returns a list of tables
                              (fss #'identity) ;Takes 1 table returns 1 table
                              (classifier-train #'identity) ;Takes 1 table returns 1 table with training metadata
                          	  (classifier #'identity)) ;Takes 1 test instance and table with training metadata and returns prediction
  (let ((clusters nil)
		    (results nil)
		    (statistics nil))
    (setf train (funcall prep train))
    (setf test (funcall prep test))
    (setf train (funcall discretizer train))
    (setf test (funcall discretizer test))
    (setf train (funcall row-reducer train test))
    (setf clusters (funcall clusterer k train))
	(dolist (cluster clusters)
		(setf cluster (funcall fss cluster))
		(setf cluster (funcall classifier-train cluster)))
	(dolist (instance (table-all test))
		(push (funcall classifier (eg-features instance) (get-cluster instance clusters)) results))
	(setf results (nreverse results))
	(multiple-value-bind (ah bh ch dh) (p-metrics test results)
		(dolist (klass (klasses train))
			(let* ((a (if (gethash klass ah) (gethash klass ah) 0)) ;;tn
				     (b (if (gethash klass bh) (gethash klass bh) 0)) ;;fn
  				   (c (if (gethash klass ch) (gethash klass ch) 0)) ;;fp
	  			   (d (if (gethash klass dh) (gethash klass dh) 0)) ;;tp
    			   (accuracy (/ (+ a d) (+ a b c d)))
				     (precision (if (zerop (+ c d)) 0 (/ d (+ c d))))
				     (pd (if (zerop (+ b d)) 0 (/ d (+ b d))))
				     (pf (if (zerop (+ a c)) 0 (/ c (+ a c))))
				     (f (if (zerop (+ precision pd)) 0 (/ (* 2 precision pd) (+ precision pd))))
  				   (g (if (zerop (+ pf pd)) 0 (/ (* 2 pf pd) (+ pf pd)))))
  			(push (list prep row-reducer discretizer clusterer fss classifier klass a b c d accuracy precision pd pf f g) statistics)))
  	statistics)))

(deftest learner-test ()
  (check
    (equalp
      (mapcar #'(lambda (stat) (subseq stat 7)) (learner (ar3) (ar3) :discretizer #'10bins-eq-width :classifier-train #'nb-train :classifier #'nb-classify))
      '((54 2 1 6 20/21 6/7 3/4 1/55 4/5 6/169)
        (6 1 2 54 20/21 27/28 54/55 1/4 36/37 108/271)))))

(defun learn (train test &key (k 1)
                              (prep #'identity)
                              (row-reducer #'(lambda (train test) train))
                              (discretizer #'identity)
                              (clusterer #'default-clusterer)
                              (fss #'identity)
                              (classifier-train #'identity)
                          	  (classifier #'identity))
  (statistics-output (learner train test :k k 
                                         :prep prep 
                                         :row-reducer row-reducer
                                         :discretizer discretizer 
                                         :clusterer clusterer 
                                         :fss fss 
                                         :classifier-train classifier-train 
                                         :classifier classifier)))

(defun learn-demo ()
  (learn (ar3) (ar3) :discretizer #'10bins-eq-freq :classifier-train #'nb-train :classifier #'nb-classify)
  (learn (ar4) (ar4) :discretizer #'10bins-eq-freq :classifier-train #'nb-train :classifier #'nb-classify)
  (learn (ar5) (ar5) :discretizer #'10bins-eq-freq :classifier-train #'nb-train :classifier #'nb-classify))

(defun average-cross-val-results (results)
  (let ((avg-result nil))
    (setf avg-result (car results))
    (mapcar #'(lambda (result)
              (doitems (column i (subseq result 7))
                (incf (nth (+ i 7) avg-result) column)))
            (cdr results))
    (doitems (column i (subseq avg-result 7))
      (setf (nth (+ i 7) avg-result) (/ column (length results))))
    avg-result))

(defun cross-validation (tbl &key (k 1)
                                  (prep #'identity)
                                  (row-reducer #'(lambda (train test) train))
                                  (discretizer #'identity)
                                  (clusterer #'default-clusterer)
                                  (fss #'identity)
                                  (classifier-train #'identity)
                              	  (classifier #'identity)
                              	  (defect-class 'true)
                              	  (file-name nil))
  (let ((results nil))
    (dotimes (i 100)
      (multiple-value-bind (train test) (split-preprocessor tbl)
        (setf results (append (learner train test :k k 
                                                  :prep prep 
                                                  :row-reducer row-reducer
                                                  :discretizer discretizer 
                                                  :clusterer clusterer 
                                                  :fss fss 
                                                  :classifier-train classifier-train 
                                                  :classifier classifier)
                              results))))
    (statistics-output (filter #'(lambda (result) (and (equalp (nth 6 result) defect-class) result)) results) :file-name file-name)))

(defun cross-validation2 (train test  &key (k 1)
                                           (prep #'identity)
                                           (row-reducer #'(lambda (train test) train))
                                           (discretizer #'identity)
                                           (clusterer #'default-clusterer)
                                           (fss #'identity)
                                           (classifier-train #'identity)
                                      	   (classifier #'identity)
                                      	   (defect-class 'true)
                                      	   (file-name nil))
  (let ((results nil))
    (dotimes (i 100)
      (multiple-value-bind (test-90 test-10) (split-preprocessor test)
        (setf results (append (learner train test :k k 
                                                  :prep prep 
                                                  :row-reducer row-reducer
                                                  :discretizer discretizer 
                                                  :clusterer clusterer 
                                                  :fss fss 
                                                  :classifier-train classifier-train 
                                                  :classifier classifier)
                              results))))
    (statistics-output (filter #'(lambda (result) (and (equalp (nth 6 result) defect-class) result)) results) :file-name file-name)))

(defun cross-validation-demo ()
  (cross-validation (ar3) :row-reducer #'burak-filter :discretizer #'10bins-eq-freq :classifier-train #'nb-train :classifier #'nb-classify)
  (cross-validation (ar3) :row-reducer #'burak-filter :discretizer #'10bins-eq-freq :classifier-train #'nb-train :classifier #'nb-classify :file-name "test.txt"))

(defun cross-validation-demo2 ()
  (cross-validation2 (ar3) (ar4) :row-reducer #'burak-filter :discretizer #'10bins-eq-freq :classifier-train #'nb-train :classifier #'nb-classify)
  (cross-validation2 (ar3) (ar4) :row-reducer #'burak-filter :discretizer #'10bins-eq-freq :classifier-train #'nb-train :classifier #'nb-classify :file-name "test.txt"))

