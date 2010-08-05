(defmacro o (&rest l) 
  (let ((last (gensym))) 
    `(let (,last) 
       ,@(mapcar #'(lambda(x) `(setf ,last (oprim ,x))) l) 
       (terpri) 
       ,last))) 

(defmacro oprim (x)  
  `(progn (format t "~&[~a]=[~a] " (quote ,x) ,x) ,x)) 

(defmacro doitems ((one n list &optional out) &body body )
  `(let ((,n -1))
     (dolist (,one ,list ,out)
       (incf ,n)
       ,@body)))

