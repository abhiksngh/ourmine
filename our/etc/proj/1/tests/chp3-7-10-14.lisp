;Chapter 3 tests
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

;Figure 7.1 Support Code
(defstruct buf
  vec (start -1) (used -1) (new -1) (end -1))

(defun bref (buf n)
  (svref (buf-vec buf)
         (mod n (length (buf-vec buf)))))

(defun (setf bref) (val buf n)
  (setf (svref (buf-vec buf)
               (mod n (length (buf-vec buf))))
        val))

(defun new-buf (len)
  (make-buf :vec (make-array len)))

(defun buf-insert (x b)
  (setf (bref b (incf (buf-end b))) x))

(defun buf-pop (b)
  (prog1
      (bref b (incf (buf-start b)))
    (setf (buf-used b) (buf-start b)
          (buf-new b) (buf-end    b))))

(defun buf-next (b)
  (when (< (buf-used b) (buf-new b))
    (bref b (incf (buf-used b)))))

(defun buf-reset (b)
  (setf (buf-used b) (buf-start b)
        (buf-new b) (buf-end b)))

(defun buf-clear (b)
  (setf (buf-start b) -1 (buf-used b) -1
        (buf-new   b) -1 (buf-end  b) -1))

(defun buf-flush (b str)
  (do ((i (1+ (buf-used b)) (1+ i)))
      ((> i (buf-end b)))
    (princ (bref b i) str)))

;Figure 7.2 to use with 7.1

(defun stream-subst (old new in out)
  (let* ((pos 0)
         (len (length old))
         (buf (new-buf len))
         (from-buf nil))
    (do ((c (read-char in nil :eof)
            (or (setf from-buf (buf-next buf))
                (read-char in nil :eof))))
        ((eql c :eof))
      (cond ((char= c (char old pos))
             (incf pos)
             (cond ((= pos len)            ; 3
                    (princ new out)
                    (setf pos 0)
                    (buf-clear buf))
                   ((not from-buf)         ; 2
                    (buf-insert c buf))))
            ((zerop pos)                   ; 1
             (princ c out)
             (when from-buf
               (buf-pop buf)
               (buf-reset buf)))
            (t                             ; 4
             (unless from-buf
               (buf-insert c buf))
             (princ (buf-pop buf) out)
             (buf-reset buf)
             (setf pos 0))))
    (buf-flush buf out)))

(defun file-subst (old new file1 file2)
  (with-open-file (in file1 :direction :input)
     (with-open-file (out file2 :direction :output
                                :if-exists :supersede)
       (stream-subst old new in out))))

;Deftest for Figures 7.1 and 7.2
(deftest test-ringandfiles ()
  (check (samep
          (file-subst "bl" "fl" "test1" "test2") 'NIL)))
  
  
;Section 10.4 Support Code
(defmacro while (test &rest body)
  `(do ()
    ((not ,test))
    ,@body))

;Quicksort takes a vector, and the bounds of the vector
                                        ;Example: (exvector 0 40)
(defun quicksort (vec l r)
  (let ((i l)
        (j r)
        (p (svref vec (round (+ l r) 2))))
    (while (<= i j)
      (while (< (svref vec i) p) (incf i))
      (while (> (svref vec j) p) (decf j))
      (when (<= i j)
        (rotatef (svref vec i) (svref vec j))
        (incf i)
        (decf j)))
    (if (>= (- j l) 1) (quicksort vec l j))
    (if (>= (- r l) 1) (quicksort vec i r)))
  vec)

;Deftest for Quicksort
(deftest test-quicksort ()
  (let (sortvec)
    (setf sortvec (vector 56 7 2000 9))
    (check (samep
            (quicksort sortvec 0 3) #(7 9 56 2000)))))


;Section 10.5
(defmacro ntimes (n &rest body)
  (let ((g (gensym))
        (h (gensym)))
    `(let ((,h ,n))
       (do ((,g 0 (+ ,g 1)))
           ((>= ,g ,h))
         ,@body))))

;Deftest for ntimes
(deftest test-ntimes ()
  (let (x)
    (setf x 0)
    (ntimes 100 (setf x (+ x 1)))
  (check (samep
          (print x) '100))))


;Figure 14.2 Support Code
;Scores based on the function
;(defun most (fn lst)
;  (if (null lst)
;      (values nil nil)
;      (loop with wins = (car lst)
;           with max = (funcall fn wins)
;           for obj in (cdr lst)
;           for score = (funcall fn obj)
;           when (> score max)
;           do (setf wins obj
;                    max score)
;           finally (return (values wins max)))))

;(deftest test-most ()
;  (check
;    (samep (most #'length '((a b) (a b c) (a))) '((A B C) 3))))


;(defconstant yzero 2000) 

;(defun leap? (y)
;  (and (zerop (mod y 4))
;       (or (zerop (mod y 400))
;           (not (zerop (mod y 100))))))

;(defun year-days (y) (if (leap? y) 366 365))

;(defun num-year (n)
;  (if (< n 0)
;      (loop for y downfrom (- yzero 1)
;           until (<= d n)
;           sum (- (year-days y)) into d
;           finally (return (values (+ y 1) (- n d))))
;      (loop with prev = 0
;           for y from yzero
;           until (> d n)
;           do (setf prev d)
;           sum (year-days y) into d
;           finally (return (values (- y 1)
;                                   (- n prev))))))


;Section 10.7
;Figure 10.2 Macro Utilities
(defmacro for (var start stop &body body)
  (let ((gstop (gensym)))
    `(do ((,var ,start (1+ ,var))
          (,gstop ,stop))
         ((> ,var ,gstop))
       ,@body)))

(defmacro in (obj &rest choices)
  (let ((insym (gensym)))
    `(let ((,insym ,obj))
       (or ,@(mapcar #'(lambda (c) `(eql ,insym ,c))
                     choices)))))

(defmacro random-choice (&rest exprs)
  `(case (random ,(length exprs))
     ,@(let ((key -1))
         (mapcar #'(lambda (expr)
                     `(,(incf key) ,expr))
                 exprs))))

(defmacro avg (&rest args)
  `(/ (+ ,@args) ,(length args)))

(defmacro with-gensyms (syms &body body)
  `(let ,(mapcar #'(lambda (s)
                     `(,s (gensym)))
                 syms)
     ,@body))

(defmacro aif (test then &optional else)
  `(let ((it ,test))
     (if it ,then ,else)))


;Deftests for Figure 10.2

(deftest test-for ()
  (let (y)
    (setf y 0)
    (for x 0 8 (setf y (+ y 1)))
    (check
      (samep y '9))))

(deftest test-in ()
  (check
    (samep (in '(a b c d e f) 'z 'y 'x 'f) 'T)))

(deftest test-random-choice ()
  (check
    (or (samep (random-choice '(cake) '(death)) '(cake)) (samep (random-choice '(cake) '(death)) '(death)))))

(deftest test-avg ()
  (check
    (samep (avg 2 4 8) '14/3)))

;For use of with-gensyms, please see ntimes,for or in macros.

(deftest test-aif ()
  (check
    (samep (aif (+ 1 1)(* 2 it)) '4)))

;------------------------
;Function to run all of the tests

(defun run-ltests ()
  (test-equality)
  (test-copylist)
  (test-append)
  (test-nth)
  (test-maplist)
  (test-union)
  (test-stacks)
  (test-compress)
  (test-uncompress)
  (test-shortest-path)
  (test-ringandfiles)
  (test-quicksort)
  (test-ntimes)
  (test-for)
  (test-in)
  (test-random-choice)
  (test-avg)
  (test-aif))
  
