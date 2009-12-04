;;takes a table structure of test data and a list of symbols representing the
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

(defstruct statistics
  prep row-reducer discretizer clusterer fss classifier
  class
  a b c d
  acc prec
  pd pf
  f g)

;;Returns a new initialized statistics structure.
(defun make-stat (prep row-reducer discretizer clusterer fss classifier class a b c d acc prec pd pf f g)
  (make-statistics :prep prep :row-reducer row-reducer :discretizer discretizer :clusterer clusterer :fss fss :classifier classifier :class class
                   :a a :b b :c c :d d :acc acc :prec prec :pd pd :pf pf :f f :g g))

;;Outputs the data in each statistics structure in stats.
;;Writes to standard output unless a file-name is specified, in which case it
;;creates the file if it doesn't exist and overwrites it if it does.
(defun statistics-output (stats &key (file-name nil))
  (let ((str (or (not file-name) (open file-name :direction :output :if-exists :supersede))))
    (format str "prep, row-reducer, discretizer, clusterer, fss, classifier, class, a, b, c, d, acc, prec, pd, pf, f, g~%")
    (dolist (stat stats)
      (format str "~a, ~a, ~a, ~a, ~a, ~a, ~a, ~a, ~a, ~a, ~a, ~,1F, ~,1F, ~,1F, ~,1F, ~,1F, ~,1F~%" 
        (string-downcase (format nil "~a" (function-name (statistics-prep stat))))
        (string-downcase (format nil "~a" (function-name (statistics-row-reducer stat))))
        (string-downcase (format nil "~a" (function-name (statistics-discretizer stat))))
        (string-downcase (format nil "~a" (function-name (statistics-clusterer stat))))
        (string-downcase (format nil "~a" (function-name (statistics-fss stat))))
        (string-downcase (format nil "~a" (function-name (statistics-classifier stat))))
        (string-downcase (format nil "~a" (statistics-class stat)))
        (statistics-a stat)
        (statistics-b stat)
        (statistics-c stat)
        (statistics-d stat)
        (* 100 (statistics-acc stat))
        (* 100 (statistics-prec stat))
        (* 100 (statistics-pd stat))
        (* 100 (statistics-pf stat))
        (* 100 (statistics-f stat))
        (* 100 (statistics-g stat))))
    (if file-name (close str))))

;;Removes the columns from instance that aren't in the train table.
(defun remove-instance-columns (instance train test)
  (setf instance (eg-deep-copy instance))
  (doitems (column-header columni (get-table-column-headers test))
    (if (not (find (header-name column-header) (get-table-column-headers train) :key #'header-name :test #'equalp))
      (setf (nth columni (eg-features instance)) nil)))
  (setf (eg-features instance) (delete nil (eg-features instance)))
  instance)

;;Classifies each row in test using data in train.
;;Returns a statistics structure for each class.
;;Train and test should have updated metadata before being passed to learner.
;;This shouldn't be a problem, since all tables should have updated metadata at
;;time of creation.
(defun learner (train test &key (k 1)
                                (prep #'identity) ;Takes 1 table returns 1 table
                                (row-reducer #'all-rows)
                                (discretizer #'identity) ;Takes 1 table returns 1 table
                                (clusterer #'default-clusterer) ;Takes 1 table and k returns a list of tables
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
    (setf clusters (funcall clusterer train k))
	(dolist (cluster clusters)
		(setf cluster (funcall fss cluster))
		(setf cluster (funcall classifier-train cluster)))
	(dolist (instance (table-all test))
	  (let ((nearest-cluster (get-nearest-cluster instance clusters)))
		  (push (funcall classifier (eg-features (remove-instance-columns instance nearest-cluster test)) nearest-cluster) results)))
	(setf results (nreverse results))
	(multiple-value-bind (ah bh ch dh) (p-metrics test results)
		(dolist (class (list 'true 'false))
			(let* ((a (if (gethash class ah) (gethash class ah) 0)) ;;tn
				     (b (if (gethash class bh) (gethash class bh) 0)) ;;fn
  				   (c (if (gethash class ch) (gethash class ch) 0)) ;;fp
	  			   (d (if (gethash class dh) (gethash class dh) 0)) ;;tp
    			   (accuracy (/ (+ a d) (+ a b c d)))
				     (precision (if (zerop (+ c d)) 0 (/ d (+ c d))))
				     (pd (if (zerop (+ b d)) 0 (/ d (+ b d))))
				     (pf (if (zerop (+ a c)) 0 (/ c (+ a c))))
				     (f (if (zerop (+ precision pd)) 0 (/ (* 2 precision pd) (+ precision pd))))
  				   (g (if (zerop (+ pf pd)) 0 (/ (* 2 (- 1 pf) pd) (+ (- 1 pf) pd)))))
  			(push (make-stat prep row-reducer discretizer clusterer fss classifier class a b c d accuracy precision pd pf f g) statistics)))
  	statistics)))

(deftest learner-test ()
  (check
    (equalp
      (learner (ar3) (ar3) :discretizer #'10bins-eq-width :classifier-train #'nb-train :classifier #'nb-classify)
      (list (make-stat #'identity #'all-rows #'10bins-eq-width #'default-clusterer #'identity #'nb-classify 'true 54 2 1 6 20/21 6/7 3/4 1/55 4/5 6/169)
            (make-stat #'identity #'all-rows #'10bins-eq-width #'default-clusterer #'identity #'nb-classify 'false 6 1 2 54 20/21 27/28 54/55 1/4 36/37 108/271)))))

;;Wrapper for learner function that outputs the results to standard output.
(defun learn (train test &key (k 1)
                              (prep #'identity)
                              (row-reducer #'all-rows)
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
  (learn (ar3) (ar3) :discretizer #'10bins-eq-freq :row-reducer #'burak-filter :classifier-train #'nb-train :classifier #'nb-classify)
  (learn (ar4) (ar4) :discretizer #'10bins-eq-freq :row-reducer #'burak-filter :classifier-train #'nb-train :classifier #'nb-classify)
  (learn (ar5) (ar5) :discretizer #'10bins-eq-freq :row-reducer #'burak-filter :classifier-train #'nb-train :classifier #'nb-classify))

;;M by N cross validation that splits test into n bins and then classifies each
;;bin using the data in train.  This is repeated M times.
(defun cross-val-cc (train test &key (k 1)
                                     (prep #'identity)
                                     (row-reducer #'all-rows)
                                     (discretizer #'identity)
                                     (clusterer #'default-clusterer)
                                     (fss #'identity)
                                     (classifier-train #'identity)
                                	   (classifier #'identity)
                                	   (defect-class 'true)
                                	   (file-name nil)
                                	   (m 10)
                                	   (n 10))
  (funcall discretizer train)
  (funcall discretizer test)
  (let ((results nil))
    (dotimes (i m)
      (let ((test-bins (split-preprocessor (table-deep-copy test) n)))
        (dolist (test-bin test-bins)
          (setf results (nconc (learner (table-deep-copy train) test-bin :k k 
                                                                         :prep prep 
                                                                         :row-reducer row-reducer
                                                                         :discretizer discretizer 
                                                                         :clusterer clusterer 
                                                                         :fss fss 
                                                                         :classifier-train classifier-train 
                                                                         :classifier classifier)
                               results)))))
    (statistics-output (filter #'(lambda (result) (and (equalp (statistics-class result) defect-class) result)) results) :file-name file-name)))

;;M by N cross validation that splits tbl into n bins and then classifies
;;each bin using the data in table created by combining the other bins.
;;This is repeated M times.
(defun cross-val-wc (tbl &key (k 1)
                              (prep #'identity)
                              (row-reducer #'all-rows)
                              (discretizer #'identity)
                              (clusterer #'default-clusterer)
                              (fss #'identity)
                              (classifier-train #'identity)
                        	    (classifier #'identity)
                        	    (defect-class 'true)
                        	    (file-name nil)
                        	    (m 10)
                        	    (n 10))
  (funcall discretizer tbl)
  (let ((results nil))
    (dotimes (i m)
      (let ((bins (split-preprocessor (table-deep-copy tbl) n)))
        (dolist (bin bins)
          (setf results (nconc (learner (apply #'combine-preprocessor (mapcar #'table-deep-copy (remove bin bins))) bin :k k 
                                                                                                                        :prep prep 
                                                                                                                        :row-reducer row-reducer
                                                                                                                        :discretizer discretizer 
                                                                                                                        :clusterer clusterer 
                                                                                                                        :fss fss 
                                                                                                                        :classifier-train classifier-train 
                                                                                                                        :classifier classifier)
                                results)))))
    (statistics-output (filter #'(lambda (result) (and (equalp (statistics-class result) defect-class) result)) results) :file-name file-name)))

(defun cross-val-wc-demo ()
  (cross-val-wc (ar4) :row-reducer #'sub-sample :discretizer #'10bins-eq-freq :classifier-train #'nb-train :classifier #'nb-classify)
  (cross-val-wc (ar4) :row-reducer #'sub-sample :discretizer #'10bins-eq-freq :classifier-train #'nb-train :classifier #'nb-classify :file-name "test.txt"))

(defun cross-val-cc-demo ()
  (cross-val-cc (ar3) (ar4) :row-reducer #'burak-filter :discretizer #'10bins-eq-freq :classifier-train #'nb-train :classifier #'nb-classify)
  (cross-val-cc (ar3) (ar4) :row-reducer #'burak-filter :discretizer #'10bins-eq-freq :classifier-train #'nb-train :classifier #'nb-classify :file-name "test.csv"))

(defun nb-numeric-demo ()
  (cross-val-cc (numeric-preprocessor (ar3)) (numeric-preprocessor (ar4)) :classifier-train #'nb-train :classifier #'nb-classify)
  (cross-val-cc (numeric-preprocessor (ar3)) (numeric-preprocessor (ar4)) :classifier-train #'nb-train :classifier #'nb-classify :file-name "test.csv"))

(defun stable-theory (tbls &key (k 1)
                                (prep #'identity)
                                (row-reducer #'all-rows)
                                (discretizer #'identity)
                                (clusterer #'default-clusterer)
                                (fss #'identity)
                                (classifier-train #'identity)
                                (classifier #'identity)
                                (defect-class 'true)
                                (file-name nil)
                                (min-defect-rows 25)
                                (m 5)
                                (n 5))
  (let ((test-tbls nil)
        (train nil)
        (results nil)
        (prev-g most-positive-fixnum))
    (dolist (tbl tbls)
      (setf tbl (funcall prep tbl))
      (setf tbl (funcall discretizer tbl))
      (setf test-tbls (nconc test-tbls (split-preprocessor tbl (max 1 (floor (/ (get-table-class-frequency tbl defect-class) min-defect-rows)))))))
    (setf train (car test-tbls))
    (setf test-tbls (cdr test-tbls))
    (dolist (test (shuffle test-tbls))
      (let ((new-g 0)
            (cv-results nil)
            (result nil))
        (dotimes (i m)
          (dolist (test-bin (split-preprocessor (table-deep-copy test) n))
            (setf cv-results (nconc (learner (table-deep-copy train) test-bin :k k 
                                                            :row-reducer row-reducer
                                                            :clusterer clusterer 
                                                            :fss fss 
                                                            :classifier-train classifier-train 
                                                            :classifier classifier)
                                    cv-results))))
        (setf cv-results (filter #'(lambda (result) (and (equalp (statistics-class result) defect-class) result)) cv-results))
        (setf cv-results (sort cv-results #'< :key #'statistics-g))
        (setf result (nth (floor (/ (length cv-results) 2)) cv-results))
        (setf new-g (statistics-g result))
        (if (< (- new-g 0.05)  prev-g)
          (setf train (combine-preprocessor train test)))
        (setf prev-g new-g)
        (push result results)))
    (setf results (nreverse results))
    (statistics-output (filter #'(lambda (result) (and (equalp (statistics-class result) defect-class) result)) results) :file-name file-name)))

(defun stable-theory-demo ()
	(stable-theory (list (ar3com)(ar4com)(ar5com)(pc1com)(kc1com)(kc2com)(cm1com)) :prep #'numeric-preprocessor :discretizer #'10bins-eq-freq :classifier-train #'nb-train :classifier #'nb-classify))

