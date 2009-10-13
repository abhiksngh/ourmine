; bore.lisp
;
; Implements the BORE pre-processor.
(defun bore (dataset &optional (columnnames (mapcar #'header-name (table-columns dataset))))
  (let* ((normalvals (make-array (length columnnames) :initial-element (make-normal)))
	 (datatable (copy-table dataset))
         (returntable)
	 (index)
	 (n 0)
	 (x 0)
	 (y 0)
	 (fields)
	 )
    (dolist (columns (table-columns datatable))
	(dolist (name columnnames)
	  (if (and (typep columns 'numeric) (equal name (header-name columns)))
	      (progn
                (setf (aref normalvals y) (fill-normal datatable n))

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




