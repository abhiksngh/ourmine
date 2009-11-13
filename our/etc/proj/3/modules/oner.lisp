(defun oner (table &optional features)
  (dolist (column (if (null features) (table-columns table) features))
	(null column)))
