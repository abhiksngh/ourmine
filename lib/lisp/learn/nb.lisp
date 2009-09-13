(defun nb (train test &key (stream t))
  (let* ((acc 0)
	(all  (table-all test))
	(max  (length all)))
    (dolist (one all (/ acc max))
      (let* ((got     (bayes-classify (eg-features one) (xindex train)))
	     (want    (eg-class one))
	     (success (eql got want)))
	(incf acc (if success 1.0 0.0))
	(format stream "~a ~a ~a ~a~%"  got want  
		(round (* 100 (/ acc max)))
		(if success "   " "<--"))))))

(defun nb-simple (train test &key (stream t))
  (xindex train)
  (dolist (one (table-all test))
    (let* ((got     (bayes-classify (eg-features one) train))
	   (want    (eg-class one))
	   (success (eql got want)))
      (format stream "~a ~a ~a~%"  got want (if (eql got want) "   " "<--")))))

(defun bayes-classify (one tbl &optional (m 2) (k 1))
  (let* ((classes        (klasses tbl))
         (nclasses       (nklasses tbl))
         (n              (f        tbl))
         (classi         (table-class tbl))
         (like           most-negative-fixnum)
         (classification (first classes)))
    (dolist (class classes)
      (let* ((prior (/ (+ (f tbl class) k)
                       (+  n (* k nclasses))))
             (tmp   (log prior)))
        (doitems (feature i one)
          (unless (= classi i)
            (unless (unknownp feature)
              (let ((delta (/ (+ (f tbl class i feature)
                                 (* m prior))
                              (+ (f tbl class) m))))
                (incf tmp (log delta))))))
        (when (> tmp like)
          (setf like tmp
                classification class) )))
    classification))

(load "tests/data/audiology.lisp")
(load "tests/data/kr-vs-kp.lisp")
(load "tests/data/primary-tumor.lisp")
(load "tests/data/vehicle.lisp")
(load "tests/data/vote.lisp")
(load "tests/data/weather.nominal.lisp")
(load "tests/data/weather2.lisp")
(load "tests/data/weathernumerics.lisp")

(defun hyperpipes-test ()
  (hyperpipes (audiology) (audiology))
  (hyperpipes (kr-vs-kp) (kr-vs-kp))
  (hyperpipes (primary-tumor) (primary-tumor))
  (hyperpipes (vehicle) (vehicle))
  (hyperpipes (vote) (vote))
  (hyperpipes (weather.nominal) (weather.nominal))
  (hyperpipes (weather2) (weather2))
  (hyperpipes (weather-numerics) (weather-numerics)))

;Uses the instances in train to build the seen array and then
;uses the instances in test to test the classifier.
(defun hyperpipes (train test &key (stream t))
  (format stream "~a~%" (table-name train))
  (multiple-value-bind (seen-array max-array min-array) (hyperpipes-train train)
    (dolist (instance (table-all test))
      (let* ((got (hyperpipes-most-contained test instance seen-array max-array min-array))
             (want (eg-class instance))
             (success (eql got want)))
        (format stream "~a ~a ~a~%"  got want (if success "   " "<--"))))))

(defun hyperpipes-train (tbl)
  (let* ((instances (table-all tbl))
         (classi (table-class tbl))
         (seen-array (create-seen-array tbl))
         (max-array (create-numeric-array tbl most-negative-fixnum))
         (min-array (create-numeric-array tbl most-positive-fixnum)))
    (dolist (instance instances)  ;; loop thru the instances
      (let* ((features (eg-features instance))
             (instance-class (nth (table-class tbl) features)))
        (doitems (feature i features)  ;; loop thru the attribute values for an instance
          (let ((column-name (header-name (nth i (table-columns tbl)))))
            (unless (= classi i)
              (unless (unknownp feature)
                (cond ((numericp column-name) ;; handle numeric attributes
                        (if (> feature (get-numeric-value tbl max-array instance-class i))
                            (set-numeric-array tbl max-array instance-class i feature))
                        (if (< feature (get-numeric-value tbl min-array instance-class i))
                            (set-numeric-array tbl min-array instance-class i feature)))
                      (t  ;; handle enum attributes
                        (set-seen-array tbl seen-array instance-class i feature)))))))))
    (values seen-array max-array min-array)))

(defun hyperpipes-most-contained (tbl instance seen-array max-array min-array)
  (let ((best -1)
        (what nil)
        (classes (klasses tbl))
        (classi (table-class tbl))
        (features (eg-features instance)))
    (dolist (class classes) ;; loop thru the classes
      (let ((count 0))
        (doitems (feature i features) ;; loop thru the attribute values for an instance
          (unless (= classi i)
            (unless (unknownp feature)
              (setf count (+ count (hyperpipes-contains tbl seen-array max-array min-array class i feature))))))
        (setf count (/ count (1- (table-width tbl))))
        (cond ((>= count best)
                (setf best count)
                (setf what class)))))
    what))

(defun hyperpipes-contains (tbl seen-array max-array min-array klass i value)
  (cond ((numericp (header-name (nth i (table-columns tbl))))
          (if (and (>= (get-numeric-value tbl max-array klass i) value) 
                   (<= (get-numeric-value tbl min-array klass i) value))
              1
              0))
        (t
          (if (= (get-seen-value tbl seen-array klass i value) 1)
              1
              0))))

;; Creates an array whose dimensions are number of classes X number of attribute columns X max number of attribute values
(defun create-seen-array (tbl)
  (let ((nclasses (length (klasses tbl)))
        (nattr (table-width tbl))
        (value-count-max 0))
    (dolist (col (table-columns tbl))
      (if (typep col 'discrete)
          (setf value-count-max (max (length (discrete-uniques col)) value-count-max))))
    (make-array (list nclasses nattr value-count-max) :initial-element 0)))

;; Records a value in the seen array
(defun set-seen-array (tbl seen-array klass i value)
  (setf (aref seen-array (position klass (klasses tbl))
                         i
                         (position value (discrete-uniques (nth i (table-columns tbl)))))
        1))

;; Returns a value from the seen array
(defun get-seen-value (tbl seen-array klass i value)
  (aref seen-array (position klass (klasses tbl))
                         i
                         (position value (discrete-uniques (nth i (table-columns tbl))))))

;; Creates an array for storing min or max values 
(defun create-numeric-array (tbl initial-value)
  (let ((nclasses (length (klasses tbl)))
        (nattr (table-width tbl)))
    (make-array (list nclasses nattr) :initial-element initial-value)))

;; Sets a value in a min or max array
(defun set-numeric-array (tbl numeric-array klass i value)
  (setf (aref numeric-array (position klass (klasses tbl))
                            i)
        value))

;; Returns a value from a min or max array
(defun get-numeric-value (tbl numeric-array klass i)
  (aref numeric-array (position klass (klasses tbl)) i))

(defun stress-test-nb (&optional (repeats 10000))
  (with-output-to-string (str)
    (dotimes (i repeats t)
      (random-test-nb1 0.2 str)))
  t)

  (defun make-weather (eg)
    (data :name    'weather 
	  :columns '(forecast temp humidity windy play)  
	  :egs      eg))
  
(let 
    ((egs     '((sunny    hot  high   FALSE skip) 
		(sunny    hot  high   TRUE  skip)
		(rainy    cool normal TRUE  skip)     
		(sunny    mild high   FALSE skip)
		(overcast cool normal TRUE  play)
		(overcast hot  high   FALSE play)
		(rainy    mild high   FALSE play)
		(rainy    cool normal FALSE play)
		(sunny    cool normal FALSE play)
		(rainy    mild normal FALSE play)
		(rainy    mild high   TRUE  skip)
		(sunny    mild normal TRUE  play)
		(overcast mild high   TRUE  play)
		(overcast hot  normal FALSE play))))
  
  (defun random-test-nb1 (&optional (n 0.3) (str t))
    (let* (train test (k (* n (length egs))))
      (dolist (eg (shuffle egs))
        (if (> (decf k) 0)
          (push eg test)
          (push eg train)))
      (nb (make-weather train)
          (make-weather test)
          :stream str)))
  
  (defun self-test-nb ()
    (nb (make-weather egs) 
        (make-weather egs)))
 
  (defun self-simple-test-nb ()
    (nb-simple  (make-weather egs) 
                (make-weather egs)))
)
