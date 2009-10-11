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
