(defun bore (file &optional (str t))
  (let* ((dat     (file->data file))
	 (classes (hash->keys (data-classes dat))))
    (dolist (class classes)
      (format str "~%~%------~%~a~%" class) 
      (print (bore1 class dat) str))))

(defun bore1 (goal dat)
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
	     (score (/ (* b b) (+ b r))))
	(setf most  (max score most)
	      least (min score least))
	(push (cons score k) ranks)))
    (setf ranks (sort ranks #'> :key #'first))
    (mapcar #'(lambda (x) 
		(bore3 (first x) (second x) (third x) 
		        (data-labels dat) most least)) 
	    ranks)))

(defun bore2 (col value v hash)
  (more `(,col ,value) hash :inc v))

(defun bore3 (score col value labels most least)
    (cons (round (* 100 (/ (- score least) (- most least))))
	  (list (nth col labels) value)))

(defun file->data (file &optional (label #'identity))
  (let ((dat (make-data 
	      :rows (file->lists file #'reverse))))
    (lists->data dat label)))

(defun lists->data (dat label)
  (let ((header (rest  (first (data-rows dat))))
	(rows   (rest  (data-rows dat))))
    (setf (data-labels dat) header)
    (dolist (list rows dat)
      (when list
	(if (= (1+ (length header))
	       (length list))
	    (list->data list dat label)
	    (error "~a not ~a long" 
		   list (length header))))))) 

(defun list->data (list dat label)
  (let ((class (funcall label (first list))))
    (more class (data-classes dat))
    (doitems (one n (rest list))
      (unless (eql one (data-missing dat))
	(more `(,class ,n ,one) 
	      (data-counts dat))))))

(deftest !file->data ()
  (let ((dat (file->data 
	      "../data/weather-nominal.dat")))
    (test
       (with-output-to-string (str)
         (showh (data-counts dat) :str str))
       "H: ((NO 0 FALSE) . 2) 
        H: ((NO 0 TRUE) . 3) 
        H: ((NO 1 HIGH) . 4) 
        H: ((NO 1 NORMAL) . 1) 
        H: ((NO 2 COOL) . 1) 
        H: ((NO 2 HOT) . 2) 
        H: ((NO 2 MILD) . 2) 
        H: ((NO 3 RAINY) . 2) 
        H: ((NO 3 SUNNY) . 3) 
        H: ((YES 0 FALSE) . 6) 
        H: ((YES 0 TRUE) . 3) 
        H: ((YES 1 HIGH) . 3) 
        H: ((YES 1 NORMAL) . 6) 
        H: ((YES 2 COOL) . 3) 
        H: ((YES 2 HOT) . 2) 
        H: ((YES 2 MILD) . 4) 
        H: ((YES 3 OVERCAST) . 4) 
        H: ((YES 3 RAINY) . 3) 
        H: ((YES 3 SUNNY) . 2) " )))

(deftest !bore1 ()
  (test
   (with-output-to-string (s)
     (bore "../data/weather-nominal.dat"  s))
   "------
    YES
    ((100 HUMIDITY NORMAL) (85 WINDY FALSE) (74 OUTLOOK OVERCAST) (43 TEMP MILD)
     (33 TEMP COOL) (23 OUTLOOK RAINY) (16 WINDY TRUE) (11 HUMIDITY HIGH)
     (5 TEMP HOT) (0 OUTLOOK SUNNY)) 
    ------
    NO
    ((100 HUMIDITY HIGH) (77 OUTLOOK SUNNY) (63 WINDY TRUE) (40 TEMP HOT)
     (31 OUTLOOK RAINY) (24 TEMP MILD) (17 WINDY FALSE) (5 TEMP COOL)
     (0 HUMIDITY NORMAL)) "))
