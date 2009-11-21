(defstruct rules
  column
  rules
  count
)
(defstruct bestrule
  column
  attval
  classval
  count
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
		  (rule-print val "-->"))) hash))

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
		    ;; This line isn't really important because we don't use the count anymore (outside of best-rules).
		    ;(setf (gethash (second best) (gethash attval ht)) (first best))
		    (incf rulesetcount (first best))))
      hash)
	(values rulesetcount ht)))
		    
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

(defun oner-classify (item rule)
  "item & rules hash-table: [AttVal] -> [[ClassVal] -> [Count]]"
  (when (null rule)
    nil)
  item)


(defun oner (train test &key (stream t))
  "I'm stealing from Menzies...sorta."
  (let* ((acc 0)
	 (max (length (table-all test)))
	 (rules (oner-rules train))
	 (colindex (indexof (rules-column rules) (table-columns test))))
    (dolist (record (table-all test))
      (let* ((got     (oner-classify (nth colindex record) (rules-rules rules)))
	     (want    (eg-class record))
	     (success (eql got want)))
	(incf acc (if success 1.0 0.0))
	(format stream "~a ~a ~a ~a~%" got want
		(round (* 100 (/ acc max)))
		(if success "   " "<--"))))))

