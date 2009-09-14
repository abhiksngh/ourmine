(load "learn/hungarian-14-heart-disease")
(load "learn/vote")

(defun hp (train test &key (stream t))
  (let* (
        (all  (table-all test))
        (max-array (buildMinMaxArr train))
        (min-array (buildMinMaxArr train))
        (seen-array (buildSeenArr train)))
    (hp-train train min-array max-array seen-array)
    (dolist (instance all)
      (let* ((got     (hp-mostContained test instance min-array max-array seen-array))
	     (want    (eg-class instance))
	     (success (eql got want)))
	(format stream "~a ~a ~a ~%"  got want
                (if success "   " "<--"))))))

(defun hp-train (tbl min-array max-array seen-array)
  (let ((all-instances (table-all tbl))
        (classi (table-class tbl)))
     (dolist (per-instance all-instances)
       (let* ((all-features (eg-features per-instance))
              (per-instance-class (nth (table-class tbl) all-features)))
         (doitems (per-feature i all-features)
           (let ((col-title (header-name (nth i (table-columns tbl)))))
             (unless (= classi i)
               (unless (unknownp per-feature)
                 (cond ((numericp col-title)
                       (if (> per-feature (grabMinMaxValue tbl max-array per-instance-class i))
                           (setMinMaxValue tbl max-array per-instance-class i per-feature))
                       (if (< per-feature (grabMinMaxValue tbl min-array per-instance-class i))
                           (setMinMaxValue tbl min-array per-instance-class i per-feature)))
                       (t (setSeenArr tbl seen-array per-instance-class i per-feature)))))))))))

(defun hp-contains (tbl min-array max-array seen-array klass i value)
  (if (numericp (header-name (nth i (table-columns tbl))))
        (if (and
             (>= (grabMinMaxValue tbl max-array klass i) value)
             (<= (grabMinMaxValue tbl min-array klass i) value)
             )1 0)
        (if (= (grabSeenValue tbl seen-array klass i value) 1)
            1
            0)))

(defun hp-mostContained (tbl instance min-array max-array seen-array)
  (let ((best most-negative-fixnum)
        (what "")
        (count 0)
        (classi (table-class tbl))
        (all-attributes (eg-features instance))
        (all-klasses (klasses tbl)))
    (dolist (per-klass all-klasses what)
      (setf count 0)
      (doitems (per-attribute i all-attributes)
              (unless (= classi i)
                (unless (unknownp per-attribute)
                  (setf count (+ count (hp-contains tbl min-array max-array seen-array per-klass i per-attribute))))))
      (setf count (/ count (- (table-width tbl) 1)))
      (cond ((>= count best)
             (setf best count)
             (setf what per-klass))))))
      
    
;;Helpers functions follow!

(defun buildMinMaxArr (tbl)
  (make-array (list (length (klasses tbl)) (table-width tbl)) :initial-element 0))

(defun setMinMaxValue (tbl arr klass i value)
  (setf (aref arr (position klass (klasses tbl))
              i)
        value))

(defun grabMinMaxValue (tbl arr klass i)
  (aref arr (position klass (klasses tbl))
        i))

(defun buildSeenArr (tbl)
  (let ((maxValue 0))
    (dolist (per-column (table-columns tbl))
      (if (typep per-column 'discrete)
          (setf maxValue (max maxValue (length(discrete-uniques per-column))))))
    (make-array (list (length (klasses tbl)) (table-width tbl) maxValue) :initial-element 0)))

(defun setSeenArr (tbl arr klass i value)
  (setf (aref arr (position klass (klasses tbl))
              i
              (position value
                        (discrete-uniques
                         (nth i (table-columns tbl)))))
        1))

(defun grabSeenValue (tbl arr klass i value)
  (aref arr (position klass (klasses tbl)) i
        (position value
                  (discrete-uniques
                         (nth i (table-columns tbl))))))
