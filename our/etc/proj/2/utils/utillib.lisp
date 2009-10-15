(defun any (seq &optional (n 1))
  (let ((randomlist (sort (copy-seq seq)
                          (lambda (x y) (= 0 (my-random-int 2))))))
    (if (> n 1)
      (subseq randomlist 0 n)
      (elt randomlist 1))))

; COMPRESSION
; From P. Graham (P. #37)
; Take a list, call compr on the car 1 and cdr
(defun compress (x)
  (if (consp x)
      (compr (car x) 1 (cdr x))
      x))
; From P. Graham (P. #37)
; Take an element, the element count, and a list.
; IF the list is null, we are at the end...
; --> Return list from n-elts
; ELSE:
;  IF lst is a list compare the first element with the current element
;  --> compress (recurse)
;  ELSE: cons result of n-elts and compr (recurse)
(defun compr (elt n lst)
  (if (null lst)
      (list (n-elts elt n))
      (let ((next (car lst)))
	(if (equal next elt) ; Note slight modification from Graham's version.
	    (compr elt (+ n 1) (cdr lst))
	    (cons (n-elts elt n)
		  (compr next 1 (cdr lst)))))))
; From P. Graham (P. #37)
; Take a number and an element.
; IF the number is greater than 1 return a list with the number & element.
; THEN just return the element.
(defun n-elts (elt n)
;  (list n elt))
  (if (> n 1)
      (list n elt)
      (list n elt)))

; INDEXING
; Returns the numeric index of an element in a list or nil if it cannot be found.
; NOTE: Returns first match only.
(defun indexof (element lst)
  (if (consp lst)
      (let ((index 0))
	(dolist (item lst)
	  (if (equal element item)
	      (return index))
	  (incf index)))
      nil))
; Returns the numeric indeces of an element in a list or nil if not a list or value cannot be found.
(defun indexesof (element lst)
  (if (null lst)
      nil
      (let ((indexes nil)
	    (x 0))
	(dolist (item lst)
	  (when (equal element item)
	    (setf indexes (append indexes (list x))))
	  (incf x))
	indexes)))
; Return sthe numeric indeces of an element in a list or nil if not a list or value cannot be found.
; Takes a function to define where to look for the element.
(defun indexesofat (element lst &key (finder #'first))
  (if (null lst)
      nil
      (let ((indexes nil)
	    (x 0))
	(dolist (item lst)
	  (when (equal element (funcall finder item))
	    (setf indexes (append indexes (list x))))
	  (incf x))
	indexes)))
	

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
;used in Bore
(defun sort-on(tbl n)
  (let ((rtntable (copy-table tbl)))
    (setf (table-all rtntable) (sort (table-all rtntable) #'>= :key #'(lambda (x) (nth n (eg-features x)))))
  rtntable))

; Sort-on but with whatever sorting algorithm you want.
(defun sort-on-gen (tbl n &key (comp #'>))
  (let ((rtntable (copy-table tbl)))
    (setf (table-all rtntable) (sort (table-all rtntable) comp :key #'(lambda (x) (nth n (eg-features x)))))
  rtntable))

;Populates an istance of normal with N columns data
;Used in Bore & Normal Chops
(defun fill-normal (tbl n)
  (let ((rtnnorm (make-normal)))
    (dolist (record (table-all tbl))
      (add rtnnorm (nth n (eg-features record))))
    rtnnorm))

;Useful operator function
;used in Normal Chops
(defun directional-magic (i under at over)
  (cond ((< i 0) under)
        ((= i 0) at)
        ((> i 0) over)))

(defun directional-compare (i)
  (directional-magic i #'< #'= #'>))

(defun directional-integer (i)
  (directional-magic i (1+ i) i (1- i)))
