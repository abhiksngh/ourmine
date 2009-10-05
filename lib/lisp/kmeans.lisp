(defun test-data()
  (data
   :name 'test
   :columns '($number1 symbol $number2 stuff)
   :egs '((2 hey 2 true)
          (2 hey 2 true)
          (3 hey 2 true)
          (4 hey 2 false)
          (4 bye 2 false)
          )))

(defun kmeans (k)
  (let* ((tbl (xindex (test-data)))
         (centroid0 '()))
    (dolist (n (kmeans-find-centroid k (f tbl)))
      (push (nth n (table-all tbl)) centroid0))
    ))


(defun kmeans-find-centroid (k length)
  (let ((centroid-list '()))
    (if (<= k length)
        (progn
          (dotimes (n k)
            (let ((number (random length)))
              (if (member number centroid-list)
                  (setf n (- n 1))
                  (push number centroid-list))))
          (sort centroid-list #'<)))))

(defun kmeans-move-centroid ())

(defun kmeans-distance ())
