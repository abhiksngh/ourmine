(defmacro for (var start stop &body body)
  (let ((gstop (gensym)))
    `(do ((,var ,start (1+ ,var))
	  (,gstop, stop))
	 ((> ,var ,gstop))
       ,@body)) t) ; hacked to return true, else always returns false

(deftest test-for ()
  (check
    (for x 1 5
      (princ x))))

(defmacro in (obj &rest choices)
  (let ((insym (gensym)))
    `(let ((,insym ,obj))
       (or ,@(mapcar #'(lambda (c) `(eql ,insym ,c))
		     choices)))))

(deftest test-in()
  (check
    (in 'a 'b 'c 'a 'd)))

;; randomly chooses an argument to evaluate
(defmacro random-choice (&rest exprs)
  `(case (random ,(length exprs))
     ,@(let ((key -1))
     (mapcar #'(lambda (expr)
		 `(,(incf key) ,expr))
	     exprs))))

(deftest test-random-choice()
  (check
    (random-choice "yes" "no")))


(defmacro avg (&rest args)
  `(/ (+ ,@args) ,(length args)))

(deftest test-avg()
  (check
    (avg 1 2 3 4 5)))

; with this macro, instead of (let ((x (gensym)) (y (gensym)) (z (gensym)))
; ...)
; we can write
; (with-gensyms (x y z) ...)
(defmacro with-gensyms (syms &body body)
  `(let ,(mapcar #'(lambda (s)
		     `(,s (gensym)))
		 syms)
     ,@body))

(deftest test-with-gensyms()
  (check
    (with-gensyms (x y z)
      (list x y z))))

;; this macro allows us to use the variable it to refer to the
; value returned by the test argument in a conditional
(defmacro aif (test then &optional else)
  `(let ((it ,test))
     (if it ,then ,else)))

(deftest test-aif()
  (check
    (aif (/ 10 5)
	 (1+ it)
	 0)))
