(load "deftest.lisp")
(load "macros.lisp")
(load "random.lisp")
(load "lib.lisp")
(load "line.lisp")

(defun gen-rank-ht (l &optional (ranks (make-hash-table)) (n 0))
  (if (null l)
      ranks
      (let (repeats sum now)
        (labels ((walk () (incf n) (pop l))
                 (new  () (setf repeats 1) (setf sum n))
                 (same () (incf sum n) (incf repeats))
                 (spin () (when (eql now (car l))
                            (walk) (same) (spin))))
          (setf now (walk))
          (new)
          (spin)
          (setf (gethash now ranks) (/ sum repeats))
          (gen-rank-ht l ranks n)))))

#| (maphash #'(lambda (k v) (print `(,k ,v))) 
	 (gen-rank-ht '(87 78 8 8 7 6 6 6 6 6 6 4 4 4 4 3 3 3 3 3 3 2 1)))
(rank '(87 78 8 8 7 6 6 6 6 6 6 4 4 4 4 3 3 3 3 3 3 2 1)) |#
(defun rank (list-of-numbers &optional (sort-fn #'>))
  "Returns a list of the elements of l ranked.  Ties get the average rank"
  (let ((rank-ht (gen-rank-ht (sort (copy-list list-of-numbers) sort-fn))))
    (mapcar #'(lambda (x) (float (gethash x rank-ht))) list-of-numbers)))

(defun mann-whitney-demo ()
  "Performs a Mann-Whitney test."
  (mann-whitney '(4.6 4.7 4.9 5.1 5.2 5.5 5.8 6.1 6.5 6.5 7.2)
		'(5.2 5.3 5.4 5.6 6.2 6.3 6.8 7.7 8.0 8.1)))


(defun mann-whitney (a b &optional (conf 95) (up t))
  "Performs a Mann-Whitney test as described in method 1 of
   http://faculty.vassar.edu/lowry/ch11a.html."
  (labels ((as-ranks (l r) (mapcar #'(lambda (x) (gethash x r)) l))
	   (sum      (l)   (let ((s 0)) (dolist (x l s) (incf s x)))))
    (let* ((all    (sort (copy-list (append a b)) #'<))
	   (ranks  (gen-rank-ht all))
	   (ranksa (as-ranks a ranks))
	   ;(ranksb (as-ranks b ranks))
	   (na     (length a))
	   (nb     (length b))
	   (n      (+ na nb))
	   (tcrit  (tcritical n conf))
	   (suma   (* 1.0 (sum ranksa)))
	   (ta     (/ (* na (+ n 1)) 2.0))
	   (sigma  (sqrt (/  (* na nb (+ n 1)) 12.0)))
	   (za     (/ (+ (- suma ta) 0.5) sigma)))
      (if (< (abs za) tcrit)
	  nil
	  (let ((less-than (< (median a)
			      (median b))))
	    (if up
		(if less-than -1  1)
		(if less-than  1 -1)))))))  





(defun wilcoxon (pop1 pop2 &optional (conf 95) (up t))
  (let ((n 0) diffs abs-diffs) ;no defined for n less than 10
    (mapcar #'(lambda (p1 p2)
		(let ((delta (- p1 p2)))
		  (when  (not (zerop delta))
		      (incf n)
		      (push delta diffs)
		      (push (abs delta) abs-diffs)
		      )))
	    pop1 pop2)
    (if (< n 10)
	0
	(let ((ranks (gen-rank-ht abs-diffs))
	      (tcrit (tcritical n conf))
	      sigma z
	      (w 0))
	  (doitems (abs-diff pos abs-diffs)
	    (let ((w0 (gethash abs-diff ranks)))
	      (if   (< 0 (nth pos diffs))
		    (incf w (* -1 w0))
		    (incf w w0))))
	  (setf sigma (sqrt (/
			     (* n (+ n 1) (+ 1 (* 2 n)))
			     6)))
	  (setf z (/ (- w 0.5) sigma))
	  (if (and (> z  0)
		   (<= z tcrit))
	      nil
	      (let ((less-than (< (median pop1)
				  (median pop2))))
		(if up
		    (if less-than -1  1)
		    (if less-than  1 -1))))))))

;;;http://faculty.vassar.edu/lowry/ch12a.html
(Defun mann-whitney-demo-big (&optional (fudge 1))
  "Generates two lists of 10,000 random ints.  Multiplies the second list by
   fudge.  Performs a Mann-Whitney test on the two lists."
  (reset-seed)
  (labels ((big (n s) (let (out) (dotimes (i n out)
			  			(push (expt (randf 1.0) s) out)))))
    (mann-whitney (big 100 fudge)
		  (big 100 1)
		  95)))

(defun wilcoxon-demo-big (&optional (fudge 1))
  "Generates two lists of 10,000 random ints.  Multiplies the second list by
   fudge.  Performs a Wilcoxon test on the two lists."
  (reset-seed)
  (labels ((big (n s) (let (out)
			(dotimes (i n out)
			  (push (expt (randf 1.0) s) out)))))
    (wilcoxon (big 100 fudge)
	      (big 100 1)
	      95)))

(deftest !mann-whitney1 () (test (mann-whitney-demo-big   1)  nil))
(deftest !mann-whitney2 () (test (mann-whitney-demo-big 0.5)    1))
(deftest !mann-whitney3 () (test (mann-whitney-demo-big   2)   -1))
(deftest !wilcoxon1     () (test (wilcoxon-demo-big   1)  nil))
(deftest !wilcoxon2     () (test (wilcoxon-demo-big 0.5)    1))
(deftest !wilcoxon3     () (test (wilcoxon-demo-big   2)   -1))
