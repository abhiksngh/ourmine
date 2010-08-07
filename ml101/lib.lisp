(defun appendl (a b) (append a (list b)))

(defun lt (x y)
  (string< (format nil "~a" x) (format nil "~a" y)))

(defun flatten (lis)
  "Removes nestings from a list."
  (cond
    ((atom lis)        lis)
    ((listp (car lis)) (append (flatten (car lis))
			       (flatten (cdr lis))))
    (t                 (append (list (car lis))
			       (flatten (cdr lis))))))

(defun nchars (n &optional (char #\Space))
  (with-output-to-string (s)
    (dotimes (i n)
      (format s "~a" char))))

(defun visit (f l)
  (if (atom l)
      (funcall f l)
      (dolist (x l)
	(visit f x))))

(defun percentiles (l &optional (collect '(0 25 50 75 100)))
  "one pass through a list of nums to 'collect' some percentiles"
  (let* (out
	 last
	 (size (length l)))
    (doitems (one pos l out)
      (if (null collect)
	  (return out))
      (let ((want (first collect))
	    (progress (* 100.0 (/ (1+ pos) size))))
	(if (>= progress want)
	    (push (cons (pop collect)
			(if (= progress want)
			    one
			    (mean one (or last one))))
		  out)))
      (setf last one))))

(defun mean (&rest nums)
  (/ (apply #'+ nums)
     (length nums)))

(deftest !percentiles ()
  (test
   (percentiles '(1 2 3 4 5 6 7 8 9 10)
		'(0 25 50 75 100)
		)
   '((100 . 10)
     (75 . 15/2)
     (50 . 5)
     (25 . 5/2)
     (0 . 1))))