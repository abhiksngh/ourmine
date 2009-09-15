(defun filter (fn lst)
  (let ((acc nil))
    (dolist (x lst)
      (let ((val (funcall fn x)))
        (if val (push val acc))))
    (nreverse acc)))

(deftest filters()
  (check
    (if (filter #'(lambda (x) (and (evenp x) (+ x 10)))
                '(1 2 3 4 5 6 7)) '(12 14 16))))
