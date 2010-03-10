(defun bore (file &optional (str t) (scorer #'b^2/b+r) (normalize t))
  (let* ((dat     (file->data file))
	 (classes (hash->keys (data-classes dat))))
    (dolist (class classes)
      (format str ";;; ~a~%~a~%" 
	      class
	      (bore-ranks class dat scorer normalize)))))

(defun b^2/b+r (b r)
  (/ (* b b) (+ b r)))

(defun nomograms (b r)
  (if (zerop b)
      (* -1 most-positive-fixnum)
      (log (/ b (+ r 0.000001)) 2)))

(defun bore-ranks (goal dat scorer normalize)
  (let (ranks
	(least most-positive-fixnum)
	(most  (* -1 most-positive-fixnum))
	(best  (make-hash-table :test #'equal))
	(rest  (make-hash-table :test #'equal)))
    (dohash (k v (data-counts dat))
      (let ((class (first k)))
	(bore2 (second k) (third k) v
	       (if (eql goal class) best rest))))
    (dohash (k b best)
      (let* ((r     (gethash k rest 0))
	     (score (funcall scorer b r)))
	(setf most  (max score most)
	      least (min score least))
	(if (> b r)
	    (push (cons score k) ranks))))
    (mapcar #'(lambda (x) 
		(bore3 (first x) (second x) (third x) 
		       (data-labels dat) most least normalize))
	    (sort ranks #'> :key #'first))))

(defun bore2 (col value v hash)
  (more `(,col ,value) hash :inc v))

(defun bore3 (score col value labels most least normalize)
    (cons (if normalize
	      (round (* 100 (/ (- score least) (- most least))))
	      (float score)) 
	  (list (nth col labels) value)))

(deftest !bore1 ()
  (test
   (with-output-to-string (s)
     (bore "../data/weather-nominal.dat"  s))
     ";;; YES
        ((100 HUMIDITY NORMAL) (85 WINDY FALSE) (74 OUTLOOK OVERCAST) (43 TEMP MILD)
         (33 TEMP COOL) (23 OUTLOOK RAINY))
     ;;; NO
       ((100 HUMIDITY HIGH) (77 OUTLOOK SUNNY))"))
