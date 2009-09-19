
;;count the frequency of a word i in doc j dij
(defun freq (one value)
  (let* ((f (count value one)))
     (log (+ f 1))))

;;counts the inverse frequency
(defun freqIDF (train one value &optional (class 0))
  (let* ((all (table-all  train))
         (acc 0)
         (f (freq one value)))
    (dolist (doc all)
      (if (= (eg-class (eg-features doc)) class)
      (incf acc (if (> (freq (eg-features doc) value) 0) 1 0))))
    (* f (log (/ (length all) acc)))))

;; normalize length
(defun freqNLength (train one value)
  (let* ((accfreq 0))
    (dolist (v one)
      (incf accFreq (expt (freqIDF train one v) 2)))
    (/ (freqIDF train one value) accfreq))) 

;; calculate theta
(defun theta (train one value)
  (let* ((classes (klasses train))
         (accKlass 0)
         (accOtherWords 0)
         (leftWords (remove value one)))
    (dolist (c1 (car classes))
      (incf accKlass (freqIDF train one value c1)))
    (dolist (c2 (car classes))
      (dolist (c3 leftWords)
        (incf accOtherWords (freqIDF train one c3 c2))))
    (/ accKlass accOtherWords)))

;;calculate the weight of an attribute
(defun weight (train one value)
  (log (theta train one value)))

;;normalize weight
(defun normWeight (train one value)
  (let* ((w (weight train one value))
         (accWeight 0))
    (dolist (i one)
      (incf accWeight (weight train one i)))
    (/ w accWeight)))

  
        






      
