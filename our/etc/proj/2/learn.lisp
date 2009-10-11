(defun learn (&key (dataFile #'ar3)
                   (prep (list #'numval1 #'normalizedata))
                   (dataSplitFunc #'bins)
                   ;(k            8)
                   (rowReducer   #'burak)
                   (discretizer  #'equal-width)
                   ;(cluster      #'(lambda (data) (kmeans k data))) 
                   ;(fss          #'b-squared)
                   (classify     #'hp))
    (let* ((dataSet (funcall dataFile)))
        (print prep)
        (dolist (per-prep prep)
            (setf dataSet (funcall per-prep dataSet))
        )
        (setf dataSet (funcall discretizer dataSet))
        (multiple-value-bind (train test) (funcall dataSplitFunc dataSet)
            (multiple-value-bind (trueClass falseClass) (funcall classify train test)
           (format nil "~a, ~a, ~a, ~a, ~a, ~a, ~a, ~a, ~a, ~a, ~a, ~a, ~a, ~a, ~a" prep rowReducer discretizer classify 'TRUE (first trueClass) (second trueClass) (third trueClass) (fourth trueClass)
                   (acc (first trueClass)
                        (second trueClass)
                        (third trueClass)
                        (fourth trueClass))
                   (prec (first trueClass)
                         (second trueClass)
                         (third trueClass)
                         (fourth trueClass))
                   (pd (first trueClass)
                       (second trueClass)
                       (third trueClass)
                       (fourth trueClass))
                   (pf (first trueClass)
                       (second trueClass)
                       (third trueClass)
                       (fourth trueClass))
                   (f-calc (first trueClass)
                      (second trueClass)
                      (third trueClass)
                      (fourth trueClass))
                   (g (first trueClass)
                      (second trueClass)
                      (third trueClass)
                      (fourth trueClass)))
           (format nil "~a, ~a, ~a, ~a, ~a, ~a, ~a, ~a, ~a, ~a, ~a, ~a, ~a, ~a, ~a" prep rowReducer discretizer classify 'FALSE (first falseClass) (second falseClass) (third falseClass) (fourth falseClass)
                   (acc (first falseClass)
                        (second falseClass)
                        (third falseClass)
                        (fourth falseClass))
                   (prec (first falseClass)
                         (second falseClass)
                         (third falseClass)
                         (fourth falseClass))
                   (pd (first falseClass)
                       (second falseClass)
                       (third falseClass)
                       (fourth falseClass))
                   (pf (first falseClass)
                       (second falseClass)
                       (third falseClass)
                       (fourth falseClass))
                   (f-calc (first falseClass)
                      (second falseClass)
                      (third falseClass)
                      (fourth falseClass))
                   (g (first falseClass)
                      (second falseClass)
                      (third falseClass)
                      (fourth falseClass)))))))
                   

     ; first prep train and test
     ; then run the discretizer
     ; then cluster the training set into k clusters
     ; the do FSS on each cluster 
     ; then on the remaining attributes, train a classifier for each cluster
     ; then for all example in the test set
     ;     ... find the cluster with the nearest centroid...
     ;     ... classify that example  using that cluster's classifier

(defun prec(a b c d)
  (/
   d
   (if (and
        (eql c 0)
        (eql d 0))
       (log 0.001)
       (+ c d))))

(defun acc(a b c d)
  (/
   (+ a d)
   (if (and
        (eql a 0)
        (eql b 0)
        (eql c 0)
        (eql d 0))
       (log 0.001)
       (+ a b c d))))

(defun pd(a b c d)
  (/
   d
   (if
    (and
     (eql b 0)
     (eql d 0))
    (log 0.0001)
    (+ b d))))

(defun pf (a b c d)
  (/
   c
   (if (and
        (eql a 0)
        (eql c 0))
       (log 0.001)
       (+ a c))))

(defun f-calc (a b c d)
  (/ (* 2 (prec a b c d) (acc a b c d)) (+ (prec a b c d) (acc a b c d))))

(defun g (a b c d)
  (/ (* 2 (pf a b c d) (pd a b c d)) (+ (pf a b c d) (pd a b c d))))
