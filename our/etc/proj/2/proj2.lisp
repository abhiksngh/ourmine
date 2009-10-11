(defmethod header-deep-copy ((column discrete))
  (let ((new-column (make-discrete)))
    (setf (discrete-name new-column) (discrete-name column))
    (setf (discrete-classp new-column) (discrete-classp column))
    (setf (discrete-ignorep new-column) (discrete-ignorep column))
    (setf (discrete-uniques new-column) (copy-list (discrete-uniques column)))
    new-column))
  
(defmethod header-deep-copy ((column numeric))
  (let ((new-column (make-numeric)))
    (setf (numeric-name new-column) (numeric-name column))
    (setf (numeric-classp new-column) (numeric-classp column))
    (setf (numeric-ignorep new-column) (numeric-ignorep column))
    new-column))

(defun eg-deep-copy (eg)
  (let ((new-eg (make-eg)))
    (setf (eg-features new-eg) (copy-list (eg-features eg)))
    (setf (eg-class new-eg) (eg-class eg))
    new-eg))

(defun table-deep-copy (tbl)
  (let ((new-tbl (make-table)))
    (setf (table-name new-tbl) (table-name tbl))
    (dolist (column (table-columns tbl))
      (push (header-deep-copy column) (table-columns new-tbl)))
    (setf (table-columns new-tbl) (nreverse (table-columns new-tbl)))
    (setf (table-class new-tbl) (table-class tbl))
    (dolist (eg (table-all tbl))
      (push (eg-deep-copy eg) (table-all new-tbl)))
    (setf (table-all new-tbl) (nreverse (table-all new-tbl)))
    (setf (table-indexed new-tbl) nil)
    new-tbl))

;;Takes a table structure of training data and a table structure of test data and
;;returns a table structure of training data consisting of the 10 nearest neighbors
;;from the original training set of each instance in the test set, with duplicates
;;removed.
(defun burak-filter (train test)
  (setf train (table-deep-copy train))
  (let ((train-instances nil))
    (dolist (eg (egs test))
      (setf train-instances (append (knn2 eg train 10) train-instances)))
    (setf (table-all train) (remove-duplicates train-instances :test #'equalp))
    train))

;;Takes a table structure containing training data and a list of table structures
;;containing test data and returns a table structure of training data consisting of
;;the union of the 10 nearest neighbors in the original training set of each instance 
;;in each test set.
(defun super-burak-filter (train test-sets)
  (setf train (table-deep-copy train))
  (let ((train-instances nil))
    (dolist (test test-sets)
      (setf train-instances (append (table-all (burak-filter train test)) train-instances)))
    (setf (table-all train) (remove-duplicates train-instances :test #'equalp))
    train))

;;Takes a table structure and replaces all of the values in each numeric column
;;with log(value).  If the value is less than 0.0001, it is replaced with log(0.0001).
;;Returns a modified copy of the table structure.
(defun numeric-preprocessor (tbl)
  (setf tbl (table-deep-copy tbl))
  (let ((classi (table-class tbl)))
    (dolist (eg (egs tbl))
      (doitems (feature i (eg-features eg))
        (let ((column-name (header-name (nth i (table-columns tbl)))))
          (unless (= classi i)
              (unless (unknownp feature)
                (if (numericp column-name)
                  (setf (nth i (eg-features eg)) (log (max 0.0001 feature)))))))))
    tbl))

;;Takes a table structure and randomly removes instances from the non-minority classes
;;until all classes have the same frequency.
;;Returns a modified copy of the table structure.
(defun sub-sample (tbl)
  (setf tbl (table-deep-copy tbl))
  (multiple-value-bind (mclass mcount) (find-minority-class tbl)
    (dolist (klass (remove mclass (klasses tbl)))
      (do ((rows-removed 0)
           (classi (table-class tbl)))
          ((>= rows-removed (- (gethash (list klass klass) (header-f (table-class-header tbl))) mcount)))
          (let ((randomi (random (length (table-all tbl)))))
            (cond ((equalp klass (nth classi (eg-features (nth randomi (table-all tbl)))))
                    (setf (table-all tbl) (delete (nth randomi (table-all tbl)) (table-all tbl)))
                    (incf rows-removed))))))
    tbl))

;;Takes a table structure and returns the symbol representing the minority class and 
;;the number of instances of the minority class.
(defun find-minority-class (tbl)
  (xindex tbl)
  (let ((minority-class nil)
        (minority-class-count most-positive-fixnum))
    (maphash #'(lambda (k v)
                (cond ((< v minority-class-count)
                      (setf minority-class k)
                      (setf minority-class-count v))))
             (header-f (table-class-header tbl)))
    (values (car minority-class) minority-class-count)))

(defun learn (train test &key (k 1)
                   (prep #'identity) ;Takes 1 table returns 1 table
                   (discretizer #'identity) ;Takes 1 table returns 1 table
                   (clusterer #'default-clusterer) ;Takes k and 1 table returns a list of tables
                   (fss #'identity) ;Takes 1 table returns 1 table
                   (classifier-train #'identity) ;Takes 1 table returns 1 table with training metadata
				   (classifier #'identity)) ;Takes 1 test instance and table with training metadata and returns prediction
  (let ((clusters nil)
		(results nil))
    (setf train (funcall prep train))
    (setf test (funcall prep test))
    (setf train (funcall discretizer train))
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
				(format t "~a, ~a, ~a, ~a, ~a, ~a, ~a, ~a, ~a, ~a~%" a b c d accuracy precision pd pf f g))))))

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
				(mapcar #'eg-class (table-all test)) results)
		(maphash #'(lambda (k v) k (setf d-sum (+ d-sum v))) d)
		(maphash #'(lambda (k v) k (setf (gethash k a) (- d-sum v))) d)
		(values a b c d)))

