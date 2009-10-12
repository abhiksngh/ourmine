; bore.lisp
;
; Implements the BORE pre-processor.
(defun bore (dataset columnnames)
  (let* ((normalvals (make-array (length columnnames) :initial-element (make-normal)))
	 (datatable (copy-table dataset))
         (returntable)
	 (index ())
	 (n 0)
	 (x 0)
	 (y 0)
	 (colname)
	 (fields ())
	 )
    (dolist (columns (table-columns datatable))
      (setf colname (header-name columns))
	(dolist (name columnnames)
	  (if (equal colname name)   
	      (progn
	       (dolist (record (table-all datatable))
		(setf index (eg-features record))
		(setf x (nth n index))
		(add (aref normalvals y) x))
	       (setf (table-columns datatable) (append (table-columns datatable)
				        `(,(make-numeric :name y :ignorep nil :classp nil))))
	       (dolist (record (table-all datatable))
		 (setf (eg-features record) (append (eg-features record) `(, (normalize (aref normalvals y)
					(nth n (eg-features record)))))))
	      (incf y))
	      ))
	(incf n))

    (setf (table-columns datatable) (append (table-columns datatable)
					    `(,(make-numeric :name "w" :ignorep nil :classp nil))))
    (dolist (record (table-all datatable))
      (dotimes (z y)
	(setf fields (append fields `(,(nth (+ z n) (eg-features record))))))
      (setf (eg-features record) (append (eg-features record) `(,(borew fields)))))

   (setf returntable (best-of (sort-on datatable (+ n y))))

   returntable))


;Evaluates the W cloumn
(defun borew (cols)
  (let ((w nil)
	(sumofsquares 0)
	)
    (dolist (num cols)
      (setf sumofsquares (+ sumofsquares (square num))))
    (setf w (- 1 (/ (sqrt sumofsquares) (sqrt (length cols)))))
    w))




