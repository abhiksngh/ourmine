(defun uncompress (lst)
  (if (null lst)
      nil
      (let ((elt (car lst))
            (rest (uncompress (cdr lst))))
        (if (consp elt)
            (append (apply #'list-of elt)
                    rest)
            (cons elt rest)))))

(defun list-of (n elt)
  (if (zerop n)
      nil
      (cons elt (list-of (- n 1) elt))))

(deftest test-uncompress ()
  (check
    (equal '(1 1 1 0 1 0 0 0 0 1) (uncompress '((3 1) 0 1 (4 0) 1)))
  )
)
