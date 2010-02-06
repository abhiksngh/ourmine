(defun test0 ()
  (file->data  
   "data/weather-nominal.dat"))

(defun test1 ()
  (file->data  
   "data/anneal.dat"
   #'(lambda (x)
       (if (vowelp x) 1 0))))

(defun vowelp (x) (member x '(a e i o u)))

