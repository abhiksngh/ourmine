(defun single? (lst)
  (and (consp lst) (null (cdr lst))))



(deftest isSingle()
  (check
   (single? '(a))))
