; MP
; Fig. 14.2
(defun most (fn lst)
  (if (null lst)
      (values nil nil)
      (loop with wins = (car lst)
	   with max = (funcall fn wins)
	   for obj in (cdr lst)
	   for score = (funcall fn obj)
	   when (> score max)
	   do (setf wins obj
		    max score)
	   finally (return (values wins max)))))

(defun num-year (n)
  (if (< n 0)
      (loop for y downfrom (- yzero 1)
	   until (<= d n)
	   sum (- (year-days y)) into d
	   finally (return (values (+ y 1) (- n d))))
      (loop with prev = 0
	   for y from yzero
	   until (> d n)
	   do (setf prev d)
	   sum (year-days y) into d
	   finally (return (values (- y 1)
				   (- n prev))))))

