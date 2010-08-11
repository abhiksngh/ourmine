(defmacro oo (&rest l)
  `(progn (terpri) (o ,@l)))

(defmacro o (&rest l) 
  (let ((last (gensym))) 
    `(let (,last) 
       ,@(mapcar #'(lambda(x) `(setf ,last (oprim ,x))) l) 
       (terpri) 
       ,last))) 

(defmacro oprim (x)  
  `(progn (format t "~&[~a]=[~a] " (quote ,x) ,x) ,x)) 

(Defmacro doitems ((one n list &optional out) &body body )
  `(let ((,n -1))
     (dolist (,one ,list ,out)
       (incf ,n)
       ,@body)))


(defmacro do12 ((one two list &optional out) &body body)
  `(let ((,one (car ,list)))
     (dolist (,two (cdr ,list) ,out)
       ,@body
       (setf ,one ,two))))