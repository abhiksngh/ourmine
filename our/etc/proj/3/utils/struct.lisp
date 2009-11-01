(defstruct bin
  name
  (max (* -1 most-positive-single-float))
  (min       most-positive-single-float)
  (n 0))

(defmethod add ((b bin) x)
  (incf (bin-b     n) 1)
  (setf (bin-max   b) (max (bin-max b) x))
  (setf (bin-min   b) (min (bin-min b) x)))
