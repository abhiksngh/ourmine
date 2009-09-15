;hyperpipes.lisp
;Group 11

(load "learn/vote") ;Split this data set into (vote-train) and (vote-test) due to overfitting.  Everyone was republican.
(load "learn/mushroom") ;Seems to work 2-3x faster than nb with ~10% less accuracy.
(load "learn/soybean")
(load "learn/primary-tumor") ;Performs very poorly
(load "learn/kr-vs-kp") ;Performs @ ~50%
(load "learn/cleveland-14-heart-disease")
(load "learn/hungarian-14-heart-disease")
(load "learn/sick")
(load "learn/sonar")
(load "learn/hypothyroid")

(defun test-hp ()
  (hp (vote-train) (vote-test)) ;Split this data set into (vote-train) and (vote-test) due to overfitting.  Everyone was Republican according to Hyperpipes!
   (hp (mushroom) (mushroom))
   (hp (soybean) (soybean))
   (hp (primary-tumor) (primary-tumor)) ;Performs very poorly
   (hp (kr-vs-kp) (kr-vs-kp)) ;Performs @ ~ 50%
   (hp (cleveland-14-heart-disease) (cleveland-14-heart-disease))
   (hp (sick) (sick))
   (hp (sonar) (sonar))
   (hp (hypothyroid) (hypothyroid))
   )


;(hp train test &key (stream t))


(defun hp (train test &key (stream t))
  (format stream "~a~%" (table-name train))
  (let* (
        (all  (table-all test))
        (max-array (buildMinMaxArr train))
        (min-array (buildMinMaxArr train))
        (seen-array (buildSeenArr train))
        (total-classified 0)
        (correctly-classified 0))
    ;;We use hp-train to accept a training set of data and generate arrays with min-values, max-values, and if we've seen any of those features.
    (hp-train train min-array max-array seen-array)
    (dolist (instance all)
      (incf total-classified)
      ;Query the mostContained function to discover the class in which the instance the most contained.
      (let* ((got     (hp-mostContained test instance min-array max-array seen-array))
	     (want    (eg-class instance))
	     (success (eql got want)))
        ;Print what we got, what we wanted, and if we won.
	(format stream "~a ~a ~a ~%"  got want
                (if success "   " "<--"))
        ;;We're keeping track of what we correctly identified.
        (if success (incf correctly-classified))))
    (format stream "Correctly Classified Percent: ~a~%" (/ correctly-classified total-classified))))

(defun hp-train (tbl min-array max-array seen-array)
  ;;We consider each instance of data in the training set.
  (let ((all-instances (table-all tbl))
        ;We also need to know what column contains the instance's class.
        (classi (table-class tbl)))
    ;For each instance in all of the instances of the training set...
     (dolist (per-instance all-instances)
       ;We collect the features in the instance and discover the class of the instance.
       (let* ((all-features (eg-features per-instance))
              (per-instance-class (nth classi all-features)))
         ;For each feature...
         (doitems (per-feature i all-features)
           ;Get the column title of the feature we're considering.
           (let ((col-title (header-name (nth i (table-columns tbl)))))
             ;We don't want to indicate we've seen the class.
             (unless (= classi i)
               ;We also don't want to deal with unknown types.
               (unless (unknownp per-feature)
                 (cond ((numericp col-title)
                        ;; If the column is numeric, add the min and max's to the array.
                       (if (> per-feature (grabMinMaxValue tbl max-array per-instance-class i))
                           (setMinMaxValue tbl max-array per-instance-class i per-feature))
                       (if (< per-feature (grabMinMaxValue tbl min-array per-instance-class i))
                           (setMinMaxValue tbl min-array per-instance-class i per-feature)))
                       ;;  Mark that we've seen the discrete feature in the seen-array.
                       (t (setSeenArr tbl seen-array per-instance-class i per-feature)))))))))))

;; Check to see if the class contains a feature.
(defun hp-contains (tbl min-array max-array seen-array klass i value)
  ;; If we're looking for a numeric value, look it up in the min-array and max-array.
  (if (numericp (header-name (nth i (table-columns tbl))))
        (if (and
             (>= (grabMinMaxValue tbl max-array klass i) value)
             (<= (grabMinMaxValue tbl min-array klass i) value)
             )1 0)
        ;; Looking for discrete features in the seen array.  Return 1 if we found it; 2 if we didn't.
        (if (= (grabSeenValue tbl seen-array klass i value) 1)
            1
            0)))

;;Check to see in which class the instance is most contained given the min,max,and seen arrays.
(defun hp-mostContained (tbl instance min-array max-array seen-array)
  ;We want best and what to be reset immediately.
  (let ((best most-negative-fixnum)
        (what "")
        (count 0)
        (classi (table-class tbl))
        ;Get the attributes of the instance.
        (all-attributes (eg-features instance))
        ;Get all of the k(c)lasses in the table. Why is classes spelled with a k?  Honestly...
        (all-klasses (klasses tbl)))
    ;For each k(c)lass - We return what when we're finished.
    (dolist (per-klass all-klasses what)
      ;Restart our count.
      (setf count 0)
      ;For each attribute in the set.
      (doitems (per-attribute i all-attributes)
        ;We don't want the class of the instance.
              (unless (= classi i)
                ;We don't want to deal with an unknown type
                (unless (unknownp per-attribute)
                  ;See if the instance's attribute is contained in the class. Increment count if so.
                  (setf count (+ count (hp-contains tbl min-array max-array seen-array per-klass i per-attribute))))))
      ;Divide by the number of attributes to get a percentage!
      (setf count (/ count (- (table-width tbl) 1)))
      ;If this class was the best contained, let's remember it!
      (cond ((>= count best)
             (setf best count)
             (setf what per-klass))))))
      

;;Array helper functions follow! Quick access and easy to work with!!!
;;*MinMaxValue functions work with numeric arrays to determine if the numeric value falls within a certain range.
;;*Seen* functions work with the discrete functions.

;Numeric arrays are 2-dimensional arrays.  One for min-one for max.
;Seen arrays are 3-dimensional arrays.

;Set an array location at the intersection of class and the ith feature to a value.
(defun setMinMaxValue (tbl arr class i value)
  (setf (aref arr (position class (klasses tbl))
              i)
        value))

;Grab the value at the intersection of klass and i.
(defun grabMinMaxValue (tbl arr class i)
  (aref arr (position class (klasses tbl))
        i))

;Set an array location at the intersection of the class, ith feature, and the nth unique discrete value.
(defun setSeenArr (tbl arr class i value)
  (setf (aref arr (position class (klasses tbl))
              i
              (position value
                        (discrete-uniques
                         (nth i (table-columns tbl)))))
        1))

;Grab the array value at the intersection of the class, ith feature, and nth unique discrete value.
(defun grabSeenValue (tbl arr class i value)
  (aref arr (position class (klasses tbl)) i
        (position value
                  (discrete-uniques
                         (nth i (table-columns tbl))))))

;Create a 2 dimensional array.  num classes x number of attributes
(defun buildMinMaxArr (tbl)
  (make-array (list (length (klasses tbl)) (1- (table-width tbl))) :initial-element 0))

;Create a 3 dimensional array.  (num classes x number of attributes -1 (class won't enter seen table) x largest number of discrete values for a feature)
(defun buildSeenArr (tbl)
  (let ((maxValue 0))
    (dolist (per-column (table-columns tbl))
      ;If we're looking at column of discrete values, we want to make sure that we have plenty of room for the attribute with the most discrete values.
      (if (typep per-column 'discrete)
          (setf maxValue (max maxValue (length(discrete-uniques per-column))))))
    (make-array (list (length (klasses tbl)) (1- (table-width tbl)) maxValue) :initial-element 0)))
