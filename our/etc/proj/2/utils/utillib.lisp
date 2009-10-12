; utillib.lisp
;
; Utility functions.

; COMPRESSION
; From P. Graham (P. #37)
(defun compress (x)
  (if (consp x)
      (compr (car x) 1 (cdr x))
      x))
; From P. Graham (P. #37)
(defun compr (elt n lst)
  (if (null lst)
      (list (n-elts elt n))
      (let ((next (car lst)))
	(if (equal next elt) ; Note slight modification from Graham's version.
	    (compr elt (+ n 1) (cdr lst))
	    (cons (n-elts elt n)
		  (compr next 1 (cdr lst)))))))
; From P. Graham (P. #37)
(defun n-elts (elt n)
  (if (> n 1)
      (list n elt)
      elt))

; INDEXING
; Returns the numeric index of an element in a list or nil if it cannot be found.
; NOTE: Returns first match only.
; TODO: Since lisp allows returning multiple values, make a variant that returns all occurrences.
(defun indexof (element lst)
  (if (consp lst)
      (let ((index 0))
	(dolist (item lst)
	  (if (equal element item)
	      (return index))
	  (incf index)))))

;Displays a simple tabbed table
(defun display-table-simple (tbl)
  (dolist (column (table-columns tbl))
    (format t "~a  ~a" (header-name column) #\Tab))
  (format t "~%")
  (dolist (record (table-all tbl))
    (dolist (item (eg-features record))
      (format t "~a~a~a" item #\Tab #\Tab))
  (format t "~%")))

;Returns the top N percent of a table 
(defun best-of (tbl &optional(n .20))
  (let ((best)
        (returntable))
    (setf returntable (make-table :name (table-name tbl) :columns (table-columns tbl) :class (table-class tbl)))
    (setf best (floor(* n (negs tbl))))
    (dotimes (k best)
      (if (eql (table-all returntable) nil)
          (setf (table-all returntable) (list (car (table-all tbl))))
          (setf (table-all returntable) (append (table-all returntable) `(,(nth k (table-all tbl)))))
      ))
    returntable))

;Sorts a given table on the column N
(defun sort-on(tbl n)
  (let ((rtntable (copy-table tbl)))
    (setf (table-all rtntable) (sort (table-all rtntable) #'>= :key #'(lambda (x) (nth n (eg-features x)))))
  rtntable))
