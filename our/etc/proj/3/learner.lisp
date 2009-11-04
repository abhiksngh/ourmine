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
                              (row-reducer #'default-row-reducer)
                              (row-reducer2 #'default-row-reducer)
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
    (setf train (funcall row-reducer2 train test))
    (setf clusters (funcall clusterer train k))
	(dolist (cluster clusters)
		(setf cluster (funcall fss cluster))
		(setf cluster (funcall classifier-train cluster)))
	(dolist (instance (table-all test))
		(push (funcall classifier (eg-features instance) (get-nearest-cluster instance clusters)) results))
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
                              (row-reducer #'default-row-reducer)
                              (row-reducer2 #'default-row-reducer)
                              (discretizer #'identity)
                              (clusterer #'default-clusterer)
                              (fss #'identity)
                              (classifier-train #'identity)
                          	  (classifier #'identity))
  (statistics-output (learner train test :k k 
                                         :prep prep 
                                         :row-reducer row-reducer
                                         :row-reducer2 row-reducer2
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
                                  (row-reducer #'default-row-reducer)
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
                                           (row-reducer2 #'(lambda (train test) train))
                                           (discretizer #'identity)
                                           (clusterer #'default-clusterer)
                                           (fss #'identity)
                                           (classifier-train #'identity)
                                      	   (classifier #'identity)
                                      	   (defect-class 'true)
                                      	   (file-name nil))
  (setf train (funcall row-reducer train test))
  (setf train (funcall row-reducer2 train test))
  (let ((results nil))
    (dotimes (i 100)
      (multiple-value-bind (test-90 test-10) (split-preprocessor25 test)
        (setf results (append (learner train test-10 :k k 
                                                  :prep prep 
                                                  ;:row-reducer row-reducer
                                                  :discretizer discretizer 
                                                  :clusterer clusterer 
                                                  :fss fss 
                                                  :classifier-train classifier-train 
                                                  :classifier classifier)
                              results))))
    (statistics-output (filter #'(lambda (result) (and (equalp (nth 6 result) defect-class) result)) results) :file-name file-name)))

(defun cross-val-cc (train test &key (k 1)
                                     (prep #'identity)
                                     (row-reducer #'default-row-reducer)
                                     (discretizer #'identity)
                                     (clusterer #'default-clusterer)
                                     (fss #'identity)
                                     (classifier-train #'identity)
                                	   (classifier #'identity)
                                	   (defect-class 'true)
                                	   (file-name nil)
                                	   (m 10)
                                	   (n 10))
  (let ((results nil))
    (dotimes (i m)
      (let ((test-bins (split-preprocessor test n)))
        (dolist (test-bin test-bins)
          (setf results (append (learner train test-bin :k k 
                                                        :prep prep 
                                                        :row-reducer row-reducer
                                                        :discretizer discretizer 
                                                        :clusterer clusterer 
                                                        :fss fss 
                                                        :classifier-train classifier-train 
                                                        :classifier classifier)
                                results)))))
    (statistics-output (filter #'(lambda (result) (and (equalp (nth 6 result) defect-class) result)) results) :file-name file-name)))

(defun cross-val-wc (tbl &key (k 1)
                              (prep #'identity)
                              (row-reducer #'default-row-reducer)
                              (discretizer #'identity)
                              (clusterer #'default-clusterer)
                              (fss #'identity)
                              (classifier-train #'identity)
                        	    (classifier #'identity)
                        	    (defect-class 'true)
                        	    (file-name nil)
                        	    (m 10)
                        	    (n 10))
  (let ((results nil))
    (dotimes (i m)
      (let ((bins (split-preprocessor tbl n)))
        (dolist (bin bins)
          (setf results (append (learner (apply #'combine-preprocessor (remove bin bins :test #'equalp)) bin  :k k 
                                                                                                              :prep prep 
                                                                                                              :row-reducer row-reducer
                                                                                                              :discretizer discretizer 
                                                                                                              :clusterer clusterer 
                                                                                                              :fss fss 
                                                                                                              :classifier-train classifier-train 
                                                                                                              :classifier classifier)
                                results)))))
    (statistics-output (filter #'(lambda (result) (and (equalp (nth 6 result) defect-class) result)) results) :file-name file-name)))

(defun cross-validation-demo ()
  (cross-validation (shared_PC1) :row-reducer #'burak-filter :discretizer #'10bins-eq-freq :classifier-train #'nb-train :classifier #'nb-classify)
  (cross-validation (shared_PC1) :row-reducer #'burak-filter :discretizer #'10bins-eq-freq :classifier-train #'nb-train :classifier #'nb-classify :file-name "test.txt"))

(defun cross-validation-demo2 ()
  (cross-validation2 (ar3) (ar4) :row-reducer #'burak-filter :row-reducer2 #'micro-sample-n25 :discretizer #'10bins-eq-freq :classifier-train #'nb-train :classifier #'nb-classify)
  (cross-validation2 (ar3) (ar4) :row-reducer #'burak-filter :row-reducer2 #'micro-sample-n25 :discretizer #'10bins-eq-freq :classifier-train #'nb-train :classifier #'nb-classify :file-name "test.csv"))

(defun cross-val-wc-demo ()
  (cross-val-wc (shared_PC1) :row-reducer #'burak-filter :discretizer #'10bins-eq-freq :classifier-train #'nb-train :classifier #'nb-classify)
  (cross-val-wc (shared_PC1) :row-reducer #'burak-filter :discretizer #'10bins-eq-freq :classifier-train #'nb-train :classifier #'nb-classify :file-name "test.txt"))

(defun cross-val-cc-demo ()
  (cross-val-cc (ar3) (ar4) :row-reducer #'burak-filter :discretizer #'10bins-eq-freq :classifier-train #'nb-train :classifier #'nb-classify)
  (cross-val-cc (ar3) (ar4) :row-reducer #'burak-filter :discretizer #'10bins-eq-freq :classifier-train #'nb-train :classifier #'nb-classify :file-name "test.csv"))

