

(defun get-col (table n)
  (let ((lst))
    (dolist (item (table-all table))
      (setf lst (append lst (list (nth n (eg-features item))))))
    lst))


(defun get-data (table)
  (let ((table-data))
    (mapcar #'eg-features (table-all table))))


(defun transpose (x)
  (apply #'mapcar (cons #'list x)))