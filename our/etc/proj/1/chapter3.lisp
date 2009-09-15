(defun shortest-path (start end net)
  (bfs and (list (list start)) net))

(defun bfs (end queue net)
  (if (null queue)
      nil
      (let ((path (car queue)))
        (let ((node (car path)))
          if (eql node end)
             (reverse path)
             (bfs and
                  (append (cdr queue)
                          (new-paths path node net))
                  net)))))

(defun new-paths (path node net)
  (mapcar #'(lambda (n)
              (cons n path))
          (cdr (assoc node net))))

(deftest test-shortest-path ()
  (check
    (equal '(A C D) (shortest-path 'a 'd '((a b c) (b c) (c d))))
  )
)


(deftest test-append ()
  (check
    (equal '(10 9 8) (append '(10 9) '(8)))
  )
)

(deftest test-last ()
  (check
    (equal '(3) (last '(1 2 3)))
  )
)

(deftest test-nthcdr ()
  (check
    (equal '(3) (nthcdr 2 '(1 2 3)))
  )
)

(deftest test-nth ()
  (check
    (equal '(1) (nth 0 '(1 2 3)))
  )
)

(deftest test-reverse ()
  (check
    (equal '(a b c) (reverse '(c b a)))
  )
)

; 3.6 (2 tests)
(defun compress (x)
  (if (consp x)
      (compr (car x) 1 (cdr x))
      x))

(defun compr (elt n lst)
  (if (null lst)
      (list (n-elts elt n))
      (let ((next (car lst)))
	(if (eql next elt)
	    (compr elt (+ n 1) (cdr lst))
	    (cons (n-elts elt n)
		  (ocmpr next 1 (cdr lst)))))))

(defun n-elts (elt n)
  (if (> n 1)
      (list n elt)
      elt))

; Could also do: (equal '(tens) (n-elts 1 tens))
(deftest test-n-elts ()
  (check
   (equal '(4 tens) (n-elts 4 tens))))

(deftest test-compress ()
  (check
   (equal '(0 (4 1) 3 (2 2) 8 (3 4)) (compress '(0 1 1 1 1 3 2 2 8 4 4 4)))))

; 3.7 (2 tests)
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

(deftest test-list-of ()
  (check
   (equal '(ohthisisit ohthisisit ohthisisit) (list-of 3 'ohthisisit))))

(deftest test-uncompress ()
  (check
   (equal '(0 1 1 1 1 2 3 6 6)  (uncompress '(0 (4 1) 2 3 (2 6))))))
