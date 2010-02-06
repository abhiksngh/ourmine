(defun file->data (file &optional (label #'identity))
  (lists->count
   (make-data :rows (file->lists file)) 
   label))

(defun lists->data (dat label)
  (dolist (list (data-rows dat) dat)
    (when list
      (list->data list dat label))))

(defun list->data (list dat label)
  (let ((class (funcall label (first list))))
    (more class (data-classes dat))
    (doitems (one n (rest list))
      (more `(,class ,n ,one) (data-h dat)))))

;; tests
(defun test0 ()
  (file->data  
   "data/weather-nominal.dat"))

(defun test1 ()
  (file->data  
   "data/anneal.dat"
   #'(lambda (x)
       (if (vowelp x) 1 0))))

(defun vowelp (x) (member x '(a e i o u)))

