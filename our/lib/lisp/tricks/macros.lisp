;;;; debugging tricks

(defmacro show (x)  
  "show one thing"
  `(progn (format t "[~a]=[~a] " 
		  (quote ,x) ; show its name 
		  ,x)        ; show its value
	  ,x))               ; return its value

(defmacro o (&rest l)
  "show a list of things"
  (let ((last (gensym)))
  `(let (,last)
     ,@(mapcar #'(lambda(x) `(setf ,last (show ,x))) l)
     (terpri)
     ,last)))

(deftest test-o ()
  (let* ((a 'tim)
	 (b 'tom)
	 (result  (with-output-to-string (s)
		    (let ((*standard-output* s))
		      (o a b)))))
    (check
      (samep result
	     "[A]=[TIM] [B]=[TOM]"))))

;;;; iteration tricks

(defmacro dohash ((key value hash &optional end) &body body)
  `(progn (maphash #'(lambda (,key ,value) ,@body) ,hash)
         ,end))


(defmacro doitems ((one n list &optional out) &body body )
  `(let ((,n -1))
     (dolist (,one ,list ,out)  (incf ,n) ,@body)))

(deftest test-doitems ()
  (check (samep
	  (with-output-to-string (s)
	    (doitems (item pos '(the quick brown fox))
	      (format s "~a is at position ~a~%" item pos)))
	  "THE is at position 0
           QUICK is at position 1
           BROWN is at position 2
           FOX is at position 3")))

;;;; hash tricks

(defmacro inch (key hash &optional (inc 1))
  `(setf (gethash    ,key ,hash)
	 (+ (gethash ,key ,hash 0) ,inc)))

;;;; profiling tricks
;(defmacro watch (code)
;  `(progn
;    (sb-profile:unprofile)
;    (sb-profile:reset)
;    (sb-profile:profile ,@(my-funs))
;    (eval ,code)
;   (sb-profile:report)
;    (sb-profile:unprofile)
;    t)
;)

(defun my-funs ()
  (let ((out '()))
    (do-symbols  (s)
      (if (and (fboundp s)
	              (find-symbol  (format nil "~a" s) *package*)
		             (not (member s *lisp-funs*)))
	    (push s out)))
    out))

(defmacro time-it (n &body body) 
  (let ((n1 (gensym)) 
        (i  (gensym))
        (t1 (gensym)))
    `(let ((,n1 ,n)
           (,t1 (get-internal-run-time)))
       (dotimes (,i ,n1) ,@body)
       (float (/ (- (get-internal-run-time) ,t1)
                 (* ,n1 internal-time-units-per-second))))))

(defun test-time-it (&key (repeats 100) (loops 100) (max 10))
  (let (out) 
    (dotimes (i loops) 
      (push (random max) out)) 
    (time-it repeats
      (list2stdev out))))
