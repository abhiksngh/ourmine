;; 10.5 tests

(defparameter *macval* 3)

;; ntimes tests
(deftest ntimes-test ()
  (let ((val 3))
    (ntimes 3
            (incf *macval*))
    (check
      (equalp (+ val 3) *macval*))))

;;macros 
(defmacro ntimes (n &rest body)
  (let ((g (gensym))
        (h (gensym)))
    `(let ((,h ,n))
       (do ((,g 0 (+ ,g 1)))
           ((>= ,g ,h))
         ,@body))))
