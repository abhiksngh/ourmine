;;Naive Bayes classifier that handles both discrete and numeric values.
;;Numeric values are predicted using gaussian pdf.
(defun bayes-classify (instance train &optional (m 2) (k 1))
  (let ((max-p most-negative-fixnum)
        (max-p-class nil))
    (dolist (class (get-table-classes train))
      (let* ((prior (/ (+ (get-table-class-frequency train class) k)
                       (+ (get-table-size train) 
                          (* k (1+ (length (get-table-classes train)))))))
             (p (log prior)))
        (doitems (feature columni instance)
          (if (not (table-column-classp train columni))
            (if (table-column-numericp train columni)
              (let ((delta (pdf (get-table-class-distribution train class columni) feature)))
                (if (not (zerop delta))
                  (incf p (log delta))
                  (incf p (log (/ (* m prior)
                                  (+ (get-table-class-frequency train class) m))))))
              (let ((delta (/ (+ (get-table-instance-frequency train class columni feature)
                                 (* m prior))
                              (+ (get-table-class-frequency train class) m))))
                (incf p (log delta))))))
        (if (> p max-p)
          (setf max-p p
                max-p-class class))))
    max-p-class))

;; Uses equal priors
(defun bayes-classify-eqp (instance train &optional (m 2) (k 1))
  (let ((max-p most-negative-fixnum)
        (max-p-class nil))
    (dolist (class (get-table-classes train))
      (let* ((prior 0.5)
             (p (log prior)))
        (doitems (feature columni instance)
          (if (not (table-column-classp train columni))
            (if (table-column-numericp train columni)
              (let ((delta (pdf (get-table-class-distribution train class columni) feature)))
                (if (not (zerop delta))
                  (incf p (log delta))
                  (incf p (log (/ (* m prior)
                                  (+ (get-table-class-frequency train class) m))))))
              (let ((delta (/ (+ (get-table-instance-frequency train class columni feature)
                                 (* m prior))
                              (+ (get-table-class-frequency train class) m))))
                (incf p (log delta))))))
        (if (> p max-p)
          (setf max-p p
                max-p-class class))))
    max-p-class))

;;Training function for naive bayes.  Takes a table structure of training data and 
;;returns the same table structure with metadata.
;;Well it used to anyway.  Now it does nothing, because all tables are created with
;;updated metadata, and all functions that alter table data are responsible for 
;;calling table-update, so metadata never gets out of sync with the data.
(defun nb-train (train)
	train)

;;Takes an instance and a table structure containing training data and returns
;;a symbol representing the predicted class of the instance.
(defun nb-classify (instance train)
	(bayes-classify instance train))

;;Same as above but uses equal priors for the classes
(defun nb-classify-eqp (instance train)
	(bayes-classify-eqp instance train))

