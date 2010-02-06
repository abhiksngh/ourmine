(defmacro doitems ((one n list &optional out) &body body )
  `(let ((,n -1))
     (dolist (,one ,list ,out)  (incf ,n) ,@body)))

(defmacro dohash ((key value hash &optional end) &body body)
  `(progn (maphash #'(lambda (,key ,value) ,@body) ,hash)
          ,end))

(defun showh (h)
  (dohash (key value h h)
    (format t "~a = ~a~%" key value)))

(defmacro more (key hash &optional (n 1))
  `(incf (gethash ,key ,hash ,n)))
