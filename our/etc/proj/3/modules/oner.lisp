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

(defun best-rules (hash)
  (let ((ht (make-hash-table))
	(rulesetcount 0))
    (maphash #' (lambda (attval classht)
		  (let ((best (list 0 nil nil)))
		    (maphash #' (lambda (classval count)
				  (when (> count (first best))
				    (setf best (list count classval)))
				  best)
				classht)
		    (add-rule ht attval (second best))
		    (setf (gethash (second best) (gethash attval ht)) (first best))
		    (incf rulesetcount (first best))))
      hash)
	(values rulesetcount ht)))
		    

(defstruct rules
  column
  rules
  count
)

(defun oner-rules (table &optional features)
  (let ((ruleset (make-rules :column nil :rules nil :count 0)))
    (dolist (column (if (null features) (table-columns table) features) ruleset)
      (when (null (header-classp column))
	(let ((counter 0)
	      (colindex (indexof column (table-columns table)))
	      (ht (make-hash-table :size (/ (length (table-all table)) 3))))
	  (dolist (record (table-all table))
	    (add-rule ht (nth colindex (eg-features record)) (eg-class record)))
	  (setf counter (best-rules ht))
	  (when (> counter (rules-count ruleset))
	    (setf ruleset (make-rules :column column :rules ht :count counter))))))
;    (rule-print (rules-rules ruleset))
    ruleset))
	  


(defun oner-guts (table &optional features)
  (let ((ht (make-hash-table :size (/ (length (table-all table)) 3)))
        ; MP: I think this might be a good size, but I'm open to suggests (or leaving it default).
	colindex
	colcount
	(best (make-bestrule :column nil :attval nil :classval nil :count 0))
);	(rules (make-rules :column nil :rules nil :count 0)))
    (dolist (column (if (null features) (table-columns table) features))
      (when (null (header-classp column))
	(setf colcount 0)
;	(setf (rules-column rules) column)
        ; This could be more efficient if indexof is replaced (I think - check later).
	(setf colindex (indexof column (table-columns table)))
	(dolist (record (table-all table))
	  (add-rule ht (nth colindex (eg-features record)) (eg-class record)))
	(setf best (best-rule ht best column))
	(rule-print ht)
;	(format t "BEST: ~A~%" best)
	(clrhash ht)))
    best))


(defun oner-classify (item rule)
  

(defun oner (train test &key (stream t))
  "I'm stealing from Menzies...sorta."
  (let* ((acc o)
	 (max (length (table-all test)))
	 (rules (oner-guts train))
	 (colindex (indexof (rules-column rules) (table-columns test))))
    (dolist (record (table-all test))
      (let* ((got     (oner-classify (nth colindex record) (rules-rules rules)))
	     (want    (eg-class record))
	     (success (eql got want)))
	(incf acc (if success 1.0 0.0))
	(format stream "~a ~a ~a~%" got want
		(round (* 100 (/ acc max)))
		(if success "   " "<--"))))))
