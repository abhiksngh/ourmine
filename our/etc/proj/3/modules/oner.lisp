(defstruct bestrule
  column   ; The column name.
  attval   ; Attribute value.
  classval ; Class value.
  count    ; Number of correct predictions.
  )

(defun add-rule (ht attribute class)
  "Add a rule into the hash structure."
  (let ((outer (gethash attribute ht))
	inner)
    (when (null outer)
      (setf outer (setf (gethash attribute ht) (make-hash-table))))
    (setf inner (gethash class outer))
    (when (null inner)
      (setf inner (setf (gethash class outer) 0)))
    (setf inner (incf (gethash class outer)))))

(defun rule-print (hash &optional (prefix ""))
  "A debug print function."
  (maphash #' (lambda (key val)
		(format t "~A~A = ~A~%" prefix key val)
		(when (typep val 'HASH-TABLE)
		  (rule-print val "->"))) hash))

(defun best-rule (hash best col)
  "Determine the best rule for a column."
  (maphash #' (lambda (attval classht)
		(maphash #' (lambda (classval count)
			      (when (< (bestrule-count best) count)
				(setf best (make-bestrule :column col :attval attval :classval classval :count count))))
			    classht))
	      hash)
  best)

(defun oner (table &optional features)
  (let ((ht (make-hash-table :size (/ (length (table-all table)) 3)))
	colindex
	(best (make-bestrule :column nil :attval nil :classval nil :count 0)))
    ; This could be more efficient if indexof is replaced (I think - check later).
    (dolist (column (if (null features) (table-columns table) features))
      (when (null (header-classp column))
	(setf colindex (indexof column (table-columns table)))
        ; MP: I think this might be a good size, but I'm open to suggests (or leaving it default).
	(dolist (record (table-all table))
	  (add-rule ht (nth colindex (eg-features record)) (eg-class record)))
	(setf best (best-rule ht best column))
	(format t "BEST: ~A~%" best)
	(clrhash ht)))))
