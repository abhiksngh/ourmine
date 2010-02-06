(defmacro doitems ((one n list &optional out) &body body )
  `(let ((,n -1))
     (dolist (,one ,list ,out)  (incf ,n) ,@body)))

(defmacro dohash ((key value hash &optional end) &body body)
  `(progn (maphash #'(lambda (,key ,value) ,@body) ,hash)
          ,end))

(defun showh (h &optional (str t))
  (let (all)
    (dohash (key value h h)
      (push (cons key value) all))
    (dolist (one (sort all #'lt :key #'first) t)
      (print one str))))

(defmacro more (key hash &optional (default 0))
  `(incf (gethash ,key ,hash ,default)))
