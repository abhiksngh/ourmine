;;;;This code is taken from figure 3-7 in Paul Graham's book.  the deftest has been implemented in an elementary level to show
;;;;the basic principle behind the code (i.e. taking a compressed list and expanding it)


;;;recursive function to traverse through the compressed list, call to list-of for expansion and then consing into a new list
;;;which is the expanded result

(defun uncompress (lst)
  (if (null lst)
      nil
      (let ((elt (car lst))
	      (rest (uncompress (cdr lst))))
	(if (consp elt)
	    (append (apply #'list-of elt)
		    rest)
	    (cons elt rest)))))

(defun list-of (n elt)
  (if (zerop n)
      nil
      (cons elt (list-of (- n 1) elt))))

(deftest isUncomp()
  (check
    (if '(1 1 1 0 1 0 0 0 0 1) (uncompress '((3 1) 0 1 (4 0 ) 1)))))
