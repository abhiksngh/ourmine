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
	(let* ((a (make-hash-table))
		     (b (make-hash-table))
		     (c (make-hash-table))
		     (d (make-hash-table))
		     (d-sum 0))
		(mapcar #'(lambda (want got) 
					    (cond ((equalp want got)
							        (inch want d))
  						      (t (inch got c)
							        (inch want b))))
				    (mapcar #'eg-class (table-all test)) 
				    results)
		(maphash #'(lambda (k v) k (setf d-sum (+ d-sum v))) d)
		(maphash #'(lambda (k v) k (setf (gethash k a) (- d-sum v))) d)
		(values a b c d)))

(defun statistics-output (stats)
  (format t "prep, discretizer, cluster, fss, classify, class, a, b, c, d, acc, prec, pd, pf, f, g~%")
  (dolist (stat stats)
    (format t "~a, ~a, ~a, ~a, ~a, ~a, ~a, ~a, ~a, ~a, ~,1F, ~,1F, ~,1F, ~,1F, ~,1F, ~,1F~%" 
      (string-downcase (remove ">" (subseq (format nil "~a" (nth 0 stat)) (length "#<FUNCTION ")) :test #'string-equal))
      (string-downcase (remove ">" (subseq (format nil "~a" (nth 1 stat)) (length "#<FUNCTION ")) :test #'string-equal))
      (string-downcase (remove ">" (subseq (format nil "~a" (nth 2 stat)) (length "#<FUNCTION ")) :test #'string-equal))
      (string-downcase (remove ">" (subseq (format nil "~a" (nth 3 stat)) (length "#<FUNCTION ")) :test #'string-equal))
      (string-downcase (remove ">" (subseq (format nil "~a" (nth 4 stat)) (length "#<FUNCTION ")) :test #'string-equal))
      (string-downcase (format nil "~a" (nth 5 stat)))
      (nth 6 stat)
      (nth 7 stat)
      (nth 8 stat)
      (nth 9 stat)
      (* 100 (nth 10 stat))
      (* 100 (nth 11 stat))
      (* 100 (nth 12 stat))
      (* 100 (nth 13 stat))
      (* 100 (nth 14 stat))
      (* 100 (nth 15 stat)))))

(defun learner (train test &key (k 1)
                              (prep #'identity) ;Takes 1 table returns 1 table
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
    (setf clusters (funcall clusterer k train))
	(dolist (cluster clusters)
		(setf cluster (funcall fss cluster))
		(setf cluster (funcall classifier-train cluster)))
	(dolist (instance (table-all test))
		(push (funcall classifier (eg-features instance) (get-cluster instance clusters)) results))
	(setf results (nreverse results))
	(multiple-value-bind (ah bh ch dh) (p-metrics test results)
		(dolist (klass (klasses train))
			(let* ((a (if (gethash klass ah) (gethash klass ah) 0))
				     (b (if (gethash klass bh) (gethash klass bh) 0))
  				   (c (if (gethash klass ch) (gethash klass ch) 0))
	  			   (d (if (gethash klass dh) (gethash klass dh) 0))
    			   (accuracy (/ (+ a d) (+ a b c d)))
				     (precision (/ d (+ c d)))
				     (pd (/ d (+ b d)))
				     (pf (/ c (+ a c)))
				     (f (/ (* 2 precision pd) (+ precision pd)))
  				   (g (/ (* 2 pf pd) (+ pf pd))))
  			(push (list prep discretizer clusterer fss classifier klass a b c d accuracy precision pd pf f g) statistics)))
  	statistics)))

(deftest learner-test ()
  (check
    (equalp
      (mapcar #'(lambda (stat) (subseq stat 6)) (learner (ar3) (ar3) :discretizer #'10bins :classifier-train #'nb-train :classifier #'nb-classify))
      '((54 2 1 6 20/21 6/7 3/4 1/55 4/5 6/169)
        (6 1 2 54 20/21 27/28 54/55 1/4 36/37 108/271)))))

(defun learn (train test &key (k 1)
                              (prep #'identity)
                              (discretizer #'identity)
                              (clusterer #'default-clusterer)
                              (fss #'identity)
                              (classifier-train #'identity)
                          	  (classifier #'identity))
  (statistics-output (learner train test :k k 
                                         :prep prep 
                                         :discretizer discretizer 
                                         :clusterer clusterer 
                                         :fss fss 
                                         :classifier-train classifier-train 
                                         :classifier classifier)))

