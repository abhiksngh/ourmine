;;;;This is a deftest done on figure 3.6 in the text book.  The functions are taken from
;;;;Paul Graham and the inserted deftest tests his code for truth

;;;This function creates the compresses list after checking for like elements in order is completed by the 'compr' function

(defun compress (x)
  (if (consp x)
      (compr (car x) 1 (cdr x))
      x))

;;;This function checks for like elements next to one another recursively.  If there are like elements then the list is traversed
;;;and a counter is incremented

(defun compr (elt n lst)
  (if (null lst)
      (list (n-elts elt n))
      (let ((next (car lst)))
	(if (eql next elt)
	    (compr elt (+ n 1) (cdr lst))
	    (cons (n-elts elt n)
		  (compr next 1 (cdr lst)))))))

;;;properly formats the counter variable.  If it is greater than one a sub list with the counter is formatted

(defun n-elts (elt n)
  (if (> n 1)
      (list n elt)
      elt))

(deftest isCompress()
  (check
   (if '((3 1) 0 1 (4 0) 1) (compress '(1 1 1 0 1 0 0 0 0 1)))))
