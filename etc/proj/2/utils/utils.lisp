(defun do-over-features (tbl func)
	(dolist (item (table-all tbl)) 
		(setf (eg-features item) (mapcar func (eg-features item)))))

(defun do-over-specific-feature (tbl func column)
        (dolist (item (table-all tbl))
                (setf (nth column (eg-features item))  (funcall func (nth column (eg-features item))))))

(defun gimme-classes (tbl)
	(mapcar #'eg-class (table-all tbl)))

(defun count-classes (table)
  (let ((class-count (make-hash-table)) (seen nil) (ranks nil))
    (dolist (x (table-all table)) 
      (if (null (gethash (eg-class x) class-count))
        (setf (gethash (eg-class x) class-count) 1 seen (append seen (list (eg-class x))))
        (setf (gethash (eg-class x) class-count) (+ 1 (gethash (eg-class x) class-count)))
      )
    )
    (dolist (x seen)
      (setf ranks (append ranks (list (list x (gethash x class-count)))))
    )
    ranks
  )
)

(defun count-uniques (table opener)
  (let ((item-count (make-hash-table)) (seen nil) (ranks nil))
    (dolist (x (table-all table))
      (if (null (gethash (funcall opener x) item-count))
        (setf (gethash (funcall opener x) item-count) 1 seen (append seen (list (funcall opener x))))
        (setf (gethash (funcall opener x) item-count) (+ 1 (gethash (funcall opener x) item-count)))
      )
    )
    (dolist (x seen)
      (setf ranks (append ranks (list (list x (gethash x item-count)))))
    )
    ranks
  )
)

(defun list-unique-features (table)
  (let ((uniques nil))
    (dotimes (doer (length (table-columns table)) (reverse uniques))
      (push (count-uniques table #'(lambda (x) (nth doer (eg-features x)))) uniques ))))

(defun count-unique-features (table)
  (mapcar #'length (list-unique-features table)))

(defun find-testiest (l test)
  (let ((testiest (car l)))
    (dolist (item l testiest)
      (setf testiest (funcall test testiest item)))))

(defun find-testiest-numerics (table test)
  (let ((testiest-numerics nil))
    (let ((uniques (list-unique-features table)))
      (dotimes (doer (length (table-columns table)) (reverse testiest-numerics))
        (if (numeric-p (nth doer (table-columns table)))
	  (push (find-testiest (mapcar #'car (nth doer uniques)) test) testiest-numerics)
          (push nil testiest-numerics))))))
      
      
