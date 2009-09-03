;;chapter 3 code here

;; testing building a list

(deftest test-build-list ()
  (let ((y (list 'a 'b 'c)))
    (check
      (equalp y '(a b c)))))

;; testing list equality

(deftest test-lists-equal ()
  (let* ((x '(a b c))
	(y x))
    (check 
      (eql x y))))

;; checking for conses by writing a function

(deftest test-check-conses ()
    (let ((x '(a b c)))
      (check
	(equalp t (my-listp x)))))

(defun my-listp (x)
  (or (null x) (consp x)))

;; testing append

(deftest test-append ()
  (let ((x '(a b))
	(y '(c d))
	(z '(e)))
    (setf result (append x y z))
    (check 
      (equalp result '(a b c d e)))))

;; testing stacks

(deftest test-stacks ()
  (let ((lst '(a)))
    (push 'q lst)
    (push 'm lst)
    (pop lst)
    (check
      (equalp lst '(q a)))))

;; testing compression & uncompression

(deftest test-compression ()
  (let ((clist (compress '(1 1 1 0 1 0 0 0 0 1))))
    (check
      (equalp clist '((3 1) 0 1 (4 0) 1)))))

(deftest test-uncompression ()
  (let ((ulist (uncompress '((3 1) 0 1 (4 0) 1))))
    (check
      (equalp ulist '(1 1 1 0 1 0 0 0 0 1)))))

;; testing accessing items in a list

(deftest test-access ()
  (let ((x '(a b c d e)))
    (check
      (equalp 'd (nth 3 x)))))

;; testing a mapping function

(deftest test-mapping ()
  (let* ((a '(2 4 6)))
    (setf results (mapping a))
    (check
      (equalp results '(80 160 240)))))

(defun mapping (x)
  (mapcar #'(lambda (x) (* x 40)) x))

;; testing BFS

(deftest test-bfs ()
  (let ((graph '((a b c) (b c) (c d))))
    (setf result (shortest-path 'a 'd graph))
    (check
      (equalp result '(a c d)))))


;; Graham's BFS code

(defun shortest-path (start end net)
  (bfs end (list (list start)) net))

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

(defun new-paths (path node net)
  (mapcar #'(lambda (n)
	            (cons n path))
	    (cdr (assoc node net))))

;; Graham's compression code
(defun compress (x) 
  (if (consp x) 
      (compr (car x) 1 (cdr x)) 
      x))
(defun compr (elt n 1st) 
  (if (null 1st) 
      (list (n-elts elt n)) 
      (let ((next (car 1st))) 
	(if (eql next elt) 
	    (compr elt (+ n 1) (cdr 1st)) 
	    (cons (n-elts elt n) 
		  (compr next 1 (cdr 1st))))))) 
(defun n-elts (elt n)  
  (if (> n 1) 
      (list n elt) 
      elt)) 

;; Graham's uncompression code

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

