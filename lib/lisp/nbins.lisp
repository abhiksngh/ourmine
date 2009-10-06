(defun n_bins (n table0)
	(let ((name (table-name table0))	
	(maopcar #'header-name
		(table-columns table0)))
		(rows (magic table0)))
	
(defun magic (eqs columns)
	(let (out)
		(dolist (eq eqs out)
			(push (mapcar #'magic1 columns)))
			out)))
			
(defstruct numeric
	(max -1000000)
	(min 1000000))
	
(defmethod magic1 (datum (column discrete))
	datum)
	
(defmethod magic1 (datum (column numeric))
	(floor((datum - min / max - min) / numBins))