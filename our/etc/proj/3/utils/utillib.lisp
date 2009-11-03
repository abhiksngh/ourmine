(defun any (seq &optional (n 1))
  (let ((randomlist (sort (copy-seq seq)
                          (lambda (x y) (= 0 (my-random-int 2))))))
    (if (> n 1)
      (subseq randomlist 0 n)
      (elt randomlist 1))))

(defun distance (p q)
  (sqrt (reduce #'+ (mapcar (lambda (x y) (* (- x y) (- x y))) p q))))

(defun sample-population (tbl m &optional (factor .01))
  (any (subseq (table-all tbl) 0 (max m (floor (* (length (table-all tbl)) factor))) m)))

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
	(if (equal next elt)
	    (compr elt (+ n 1) (cdr lst))
	    (cons (n-elts elt n)
		  (compr next 1 (cdr lst)))))))
; From P. Graham (P. #37)
(defun n-elts (elt n)
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
  (let ((best-break (floor (* n (negs tbl)))))
	(values (make-table :name (table-name tbl)
						:columns (table-columns tbl)
						:class (table-class tbl)
						:all (subseq (table-all tbl) 0 best-break))
			(make-table :name (format nil "~a-REST" (table-name tbl))
						:columns (table-columns tbl)
						:class (table-class tbl)
						:all (subseq (table-all tbl) (1+ best-break))))))

;Sorts a given table on the column N
;used in Bore
(defun sort-on(tbl n)
    (setf (table-all tbl) (sort (copy-list (table-all tbl)) #'>=
				:key (lambda (x) (nth n (eg-features x)))))
    tbl)

; Sort-on but with whatever sorting algorithm you want.
(defun sort-on-gen (tbl n &key (comp #'>))
  (setf (table-all tbl)
	(sort (copy-list (table-all tbl)) comp :key #'(lambda (x) (nth n (eg-features x)))))
  tbl)

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

(defun normalize-table (tbl)
  (let ((normval)
        (n 0))
    (dolist (column (table-columns tbl) tbl)
      (when (typep column 'numeric)
        (setf normval (fill-normal tbl n))
        (dolist (record (table-all tbl))
          (setf (eg-features record) (normalize normval (nth n (eg-features record))))))
      (incf n))))
