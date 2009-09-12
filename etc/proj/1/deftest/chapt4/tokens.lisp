(defun tokens (str test start)
  (let ((p1 (position-if test str :start start)))
    (if p1
        (let ((p2 (position-if #'(lambda (c)
                                   (not (funcall test c)))
                               str :start p1)))
          (cons (subseq str p1 p2)
                (if p2
                    (tokens str test p2)
                    nil)))
        nil)))

(defun constituent (c)
  (and (graphic-char-p c)
       (not (char= c #\ ))))

(deftest test-tokens ()
  (check (compare-lists (tokens "ab12 3cde.f" #'alpha-char-p 0) '("ab" "cde" "f"))))

(deftest test-constituent ()
  (check (compare-lists (tokens "ab12 3cde.f gh" #'constituent 0) '("ab12" "3cde.f" "gh"))))

(defun compare-lists (a b)
  (if (and (null a) (null b))
      T
      (if (equal (car a) (car b))
          (compare-lists (cdr a) (cdr b))
          nil)))
      
