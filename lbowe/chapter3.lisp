;3.2 Equality
(deftest test-equality ()
  (let (x)
    (setf x (cons 'a nil))
  (check (samep
          (equal x (cons 'a nil)) 'T))))

;3.4 Building Lists
(deftest test-copylist ()
  (let ((z)(a))
  (setf z '(a b c)
        a '(copy-list z))
  (check (samep
  z '(A B C)))))

;3.4 Append
(deftest test-append ()
  (check (samep
          (append '(a b) '(c d) '(e)) '(A B C D E))))

;3.6 Access
(deftest test-nth ()
  (check (samep
          (nth 1 '(a b c)) '(B))))

;3.7 Do mapcar and maplist
(deftest test-maplist ()
  (check (samep
          (maplist #'(lambda (x) x)
                   '(a b c)) '((A B C) (B C) (C)))))

;3.11 Sets
(deftest test-union ()
  (check (samep
          (union '(a b c) '(c b s)) '(A C B S))))

;3.12 Stacks
(deftest test-stacks ()
  (let (x)
    (setf x '(b))
  (check (samep
          (push 'a x) '(A B)))))


;Figure 3.6 support code
(defun n-elts (elt n)
  (if (> n 1)
      (list n elt)
      elt))

(defun compr (elt n lst)
  (if (null lst)
      (list (n-elts elt n))
      (let ((next (car lst)))
        (if (eql next elt)
            (compr elt (+ n 1) (cdr lst))
            (cons (n-elts elt n)
                  (compr next 1 (cdr lst)))))))
(defun compress (x)
  (if (consp x)
      (compr (car x) 1 (cdr x))
      x))

;Deftest for Compress
(deftest test-compress()
  (check (samep
    (compress '(1 1 1 0 1 0 0 0 0 1)) '((3 1) 0 1 (4 0) 1))))

;Figure 3.7 support code
(defun list-of (n elt)
  (if (zerop n)
      nil
      (cons elt (list-of (- n 1) elt))))

(defun uncompress (lst)
  (if (null lst)
      nil
      (let ((elt (car lst))
            (rest (uncompress (cdr lst))))
        (if (consp elt)
            (append (apply #'list-of elt)
                    rest)
            (cons elt rest)))))

;Deftest for Uncompress
(deftest test-uncompress()
  (check (samep
          (uncompress '((3 1) 0 1 (4 0) 1)) '(1 1 1 0 1 0 0 0 0 1))))

;Figure 3.12 support code
(defun new-paths (path node net)
  (mapcar #'(lambda (n)
              (cons n path))
          (cdr (assoc node net))))

(defun bfs (end queue net)
  (if (null queue)
      nil
      (let ((path (car queue)))
        (let ((node (car path)))
          (if (eql node end)
              (reverse path)
              (bfs end
                   (append (cdr queue)
                           (new-paths path node net))
                   net))))))

(defun shortest-path (start end net)
  (bfs end (list (list start)) net))

;Deftest for Shortest Path
(deftest test-shortest-path()
  (let (min)
  (setf min '((a b c) (b c) (c d)))
  (check (samep
          (shortest-path 'a 'd min) '(A C D)))))
