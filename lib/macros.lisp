(defmacro doitems ((one n list &optional out) &body body )
  `(let ((,n -1))
     (dolist (,one ,list ,out)  (incf ,n) ,@body)))

(defmacro dohash ((key value hash &optional end) &body body)
  `(progn (maphash #'(lambda (,key ,value) ,@body) ,hash)
          ,end))

(defmacro more (key hash &key (default 0) (inc 1))
  `(incf (gethash ,key ,hash ,default) ,inc))
