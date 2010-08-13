(defstruct percentile label  breaks  positions key median)

(defparameter *X* nil)
(defun quintile (l &key (shrink 3))
  (setf *X* l)
  (let* ((width    100)
	 (l1       (mapcar #'(lambda (x) (* x 100)) (sort (copy-list l) #'<)))
	 (chops    (percentiles l1 '(0 10 30 50 70 90 100)))
	 string
	)
    (labels ((squeeze0 (x) (round (/ x shrink)))
	     (squeeze  (x) (min (- (squeeze0 width) 2) (squeeze0 x)))
	     (string0 ()  (nchars (squeeze0 width)))
             (p       (n) (squeeze (cdr (assoc n chops))))
	     (dot     (n char) (setf (char string n)  char))
	     (paint   (n1 n2 char)
	                  (setf (subseq string (p n1) (p n2))
				(nchars (- (p n2) (p n1)) char))))
      (setf string (string0))
      (dot   (squeeze  0)   #\|)
      (dot   (squeeze 100)   #\|)
      (dot   (squeeze 50)   #\|)
      (paint 10 30 #\-)
      (paint 70 90 #\-)
      (dot  (p 50)     #\*)
      string)))

(defun !quintile0 (pow)
  (reset-seed)
  (let (l1 (n 1000))
    (dotimes (i n)
      (push (expt  (/ (randi 100) 100) pow) l1))
    (quintile l1)))

 (deftest !quintile1 ()
   (test
    (!quintile0 0.5)
    "           --------     |   ---- "))

 (deftest !quintile2 ()
   (test
    (!quintile0 1)
    "   -------       |      ------   "))


(deftest !quintile3 ()
  (quintile '(1.0 1.0 0.969697 1.0 1.0 1.0 1.0
		  1.0 1.0 1.0 1.0 1.0 1.0 1.0
		  1.0 1.0 0.9714286 1.0 1.0 0.9714286 1.0)))