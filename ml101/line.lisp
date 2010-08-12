(defstruct line
  "A line runs from (x1, y1) to (x2, y2) with slope m and y-intercept b.  Some
   lines are verticalp (i.e., vertical lines with no defined slope)."
  x1 y1 x2 y2 m b verticalp)

(defun point-to-line (x1 y1 x2 y2)
  "Creates a line from two points."
  (if (> x1 x2)
      (point-to-line x2 y2 x1 y1)
      (let* ((rise      (- y2 y1))
	     (run       (- x2 x1))
	     (verticalp (zerop run))
	     m
	     b)
	(unless verticalp
	  (setf m (/ rise run)
		b (- y2 (* m x2))))
	(make-line :x1 x1 :y1 y1 :x2 x2 :y2 y2
		   :m m :b b :verticalp verticalp))))

(defun line-y (x line)
  "Returns the y value for the given x value on the line."
  (if (line-verticalp line)
      (error "unable to calculate y from x because line is vertical")
      (+ (* (line-m line) x)
	 (line-b line))))

(defun interpolate (x x1 y1 x2 y2 &optional too-big)
  "Calculates the y value for the given x value using linear interpolation
   between the given points.  Returns too-big if x > x2, y1 if x < x1."
  (cond ((<   x x1) y1)
	((eql x x1) y1)
	((eql x x2) y2)
	((>   x x2) too-big)
	(t          (line-y x (point-to-line x1 y1 x2 y2)))))

(defun interpolates (x points)
  "Calculates the y value for the given x value using linear interpolation
   between the (x . y) pairs in points."
  (let ((one (pop points))
	(two (car points)))
    (or (if (null points) (cdr one))
	(interpolate x (car one) (cdr one) (car two) (cdr two))
	(interpolates x points))))

(let ((ttable '((90 . ((  1 .  6.314  )
		       (  3 .  2.353 )
		       (  5 .  2.015 )
		       ( 10 .  1.812 )
		       ( 20 .  1.725 )
		       ( 80 .  1.67  )
		       (320 .  1.65  )))
                (95 . ((  1 . 12.70  )
		       (  3 .  3.1820)
		       (  5 .  2.5710)
		       ( 10 .  2.2280)
		       ( 20 .  2.0860)
		       ( 80 .  1.99  )
		       (320 .  1.97  )))
		(99 . ((  1 . 63.6570)
		       (  3 .  5.8410)
		       (  5 .  4.0320)
		       ( 10 .  3.1690)
		       ( 20 .  2.8450)
		       ( 80 .  2.64  )
		       (320 .  2.58  ))))))
  (defun tcritical (n conf)
    "Returns the ttest critical values.  Keeps those values as a set of lines,
     and intermediary values are interpolated between the points."
    (multiple-value-bind (points)
	(cdr (assoc conf ttable))
      (if points
          (interpolates n points)
          (error "unsupported confidence ~a.  Valid choices: ~a"
		 conf (mapcar #'car ttable))))))

(deftest !tcritical1 () (test (tcritical    10 99) 3.169))
(deftest !tcritical2 () (test (tcritical     4 99) 4.936500))
(deftest !tcritical3 ()  (test (tcritical 1000 99) 2.58))
   
