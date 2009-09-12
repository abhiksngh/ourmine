;; 10.6 deftests

(defparameter *macval2* 1)

;;macro tested
(defmacro my-incf (x &optional (y 1))
  `(setf ,x (+ ,x ,y)))

;;test new cah macro
(deftest test-my-incf ()
  (check
    (equalp (my-incf *macval2* 5) 6)))
