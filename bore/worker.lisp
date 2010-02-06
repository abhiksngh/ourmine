(defun file->data (file &optional (label #'identity))
  (let ((dat (make-data :rows (file->lists file #'reverse))))
    (lists->data dat label)))

(defun lists->data (dat label)
  (let ((header (first (data-rows dat)))
	(rows   (rest (data-rows dat))))
  (setf (data-labels dat) header)
  (dolist (list rows dat)
    (when list
      (if (= (length header) (length list))
	  (list->data list dat label)
	  (error "~a not ~a long" 
		 list (length header))))))) 

(defun list->data (list dat label)
  (let ((class (funcall label (first list))))
    (more class (data-classes dat))
    (doitems (one n (rest list))
      (unless (missingp one dat)
	(more `(,class ,n ,one) 
	      (data-h dat))))))

(defun missingp (x dat)
  (eql x (data-missing dat)))

(defun xxx()
  (print (macroexpand
	  '(deftest !file->data ()
	    (let ((dat (file->data 
			"../data/weather-nominal.dat")))
	      (test
	       (samep
		(with-output-to-string (str)
		  (showh (data-h dat) str))
      " ((NO 0 FALSE) . 2) 
        ((NO 0 TRUE) . 3) 
        ((NO 1 HIGH) . 4) 
        ((NO 1 NORMAL) . 1) 
        ((NO 2 COOL) . 1) 
        ((NO 2 HOT) . 2) 
        ((NO 2 MILD) . 2) 
        ((NO 3 RAINY) . 2) 
        ((NO 3 SUNNY) . 3) 
        ((YES 0 FALSE) . 6) 
        ((YES 0 TRUE) . 3)    
        ((YES 1 HIGH) . 3) 
        ((YES 1 NORMAL) . 6) 
        ((YES 2 COOL) . 3) 
        ((YES 2 HOT) . 2) 
        ((YES 2 MILD) . 4) 
        ((YES 3 OVERCAST) . 4) 
        ((YES 3 RAINY) . 3) 
        ((YES 3 SUNNY) . 2)" )))))))
