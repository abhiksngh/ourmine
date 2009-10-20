(defun test-data ()
  (data
   :name 'test
   :columns '($number1 symbol $number2 stuff)
   :egs '((0 true 0 true)
          (1 False 1 true)
          (1 true 1 true)
          (1 false 1 false)
          (0 true 0 true)
          (1 false 1 false)
          (1 true 1 false)
          (1 false 1 true))))

(defun ekrem-c ()
  (let* ((tbl (xindex (test-data)))
         (done nil)
         (rows (table-all tbl))
         (column-names '())
         (bst '()))
    (dotimes (n (f tbl))
      (setf (nth n rows) (eg-features (nth n rows))))
    (dolist (col (table-columns tbl))
      (push (header-name col) column-names))
    (setf column-names (reverse column-names))
    (loop while (not done) do
         (let ((art-medians '()))
         (if (= 1 (length rows))
             '(ROOT);Make it the root of the bst
             (if (= 0 (nth 1 (best-distance (car rows) (cdr rows) column-names)))
                 (progn
                   (push `(,(make-median (car rows) (nth (car (best-distance (car rows) (cdr rows) column-names)) (cdr rows)) column-names)
                            ,(car rows) ,(nth (car (best-distance (car rows) (cdr rows) column-names)) (cdr rows))) art-medians)
                   (delete (nth (car (best-distance (car rows) (cdr rows) column-names)) rows) rows)
                   (delete (car rows) rows)))
             (setf done t)
             )))))
                   


(defun best-distance (node1 rows columns)
  (let ((distance 10000000)
        (row-n 0)
        (n 0))
    (dolist (row rows)
      (when (< (euc-distance node1 row columns) distance)
        (setf distance (euc-distance node1 row columns))
        (setf row-n n))
      (incf n))
    `(,row-n ,distance)))
