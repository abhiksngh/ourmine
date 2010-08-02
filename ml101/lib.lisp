(defun appendl (a b) (append a (list b)))

(defmethod print-object ((h hash-table) str)
  (format str "{hash of ~a items}" (hash-table-count h)))

(defun maxof (l &key (key #'identity) (result #'identity))
  (let ((tmp  most-negative-fixnum)
	out)
    (dolist (item l out)
      (let ((value (funcall key item)))
	(when (> value tmp)
	  (setf tmp   value
		out   (funcall result item)))))))
