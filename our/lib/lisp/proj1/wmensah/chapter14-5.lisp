;;;; CHAPTER 14.5 - THE LOOP FACILITY

(deftest test-loop()
  (check
    (loop for x in '(1 2 3 4)
	 collect (1+ x)))) ; this prints out the list (2 3 4 5)

(deftest test-loop-random()
  (check
    (loop for x from 1 to 5
	 collect (random 10)))) ; this will print out 5 random numbers

(defun most (fn lst)
  (if (null lst)
      (values nil nil)
      (let* ((wins (car lst))
	     (max (funcall fn wins)))
	(dolist (obj (cdr lst))
	  (let ((score (funcall fn obj)))
	    (when (> score max)
	      (setf wins obj
		    max score))))
	(values wins max))))

(deftest test-most()
  (check
    (most #'(lambda (x)
	      (if (> x 20)
		  x
		  (1+ x))) '(1 2 3 4 5 6))))

