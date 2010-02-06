(defun file->data (file &optional (label #'identity))
  (let ((dat (make-data :rows (file->lists file))))
    (lists->data dat label)))

(defun lists->data (dat label)
  (dolist (list (data-rows dat) dat)
    (when list
      (list->data list dat label))))

(defun list->data (list dat label)
  (print list)
  (let ((class (funcall label (first list))))
    (more class (data-classes dat))
    (doitems (one n (rest list))
      (more `(,class ,n ,one) (data-h dat)))))
