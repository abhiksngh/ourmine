;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; This file is part of ICCLE2.
;
; ICCLE2 is free software: you can redistribute it and/or modify
; it under the terms of the GNU General Public License as published by
; the Free Software Foundation, either version 3 of the License, or
; (at your option) any later version.
;
; ICCLE2 is distributed in the hope that it will be useful,
; but WITHOUT ANY WARRANTY; without even the implied warranty of
; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
; GNU General Public License for more details.
;
; You should have received a copy of the GNU General Public License
; along with ICCLE2.  If not, see <http://www.gnu.org/licenses/>.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;tests for chapter 2
(deftest testequal ()
	(check 
	       (equal 4 4)
	       (not (equal 4 3))
        )
)
(deftest testplus()
        (check
	       (= (+ 2 5) 7)
	       (not (= (+ 2 5) 8))
	       (not (= (+ 2 5) 6))
	)
)

(deftest testlist()
  (check
    (equal (list 'my (+ 2 1) "Sons") '(my 3 "Sons"))
    )
)



(deftest testcons()
  (check
    (equal (cons 'a '(b c d)) '(a b c d))
    )
)

(deftest testcarcdr()
  (check
    (equal (first '(A B C D)) 'A)
    (equal (rest '(A B C D)) '(B C D))
    (equal (first (rest (rest '(A B C D)))) 'C)
    )
)

(deftest testif()
  (check
    (equal (if (listp '(a b c))(+ 2 3)(+ 3 4)) 5)
    (equal (if (listp 'a)(+ 2 3)(+ 3 4)) 7)
    )
)


(defun our-member (obj lst)
  (if (null lst)
      nil
      (if (eql (car lst) obj)
	  lst
	  (our-member obj (cdr lst))))
)

(deftest testour-member ()
  (check
    (equal (our-member 'b '(a b c)) '(B C))
    (equal (our-member 'b '(a d c)) nil)

    )
)

(deftest testlet()
  (check
    (equal (let ((x 5) (y 9)) (+ x y)) 14)
    )
)


(deftest testsetf()
  (setf z '(1 2 3 4))
  (check
    (equal z '(1 2 3 4))
    )
)


(deftest testfunctionalprog()
  (setf q '(a b c d e))
  (remove 'a q)
  (check 
    (not (equal q '(b c d e)))
    (equal q '(a b c d e))
  )
  (setf q (remove 'a q))
  (check
    (equal q '(b c d e))
    (not (equal q '(a b c d e)))
  )
)
;start chapter 3


(deftest testequalitycopy()
  (setf x '(a b c d))
  (setf y (copy-list x))
  (check
    (not (eql x y))
    (equal x y)
    )
)

(deftest testequalitysame()
  (setf x '(a b c d))
  (setf y x)
  (check
    (eql x y)
    (equal x y)
    )
)

(deftest testappend()
  (check
    (equal (append '(a c) '(b d)) '(a c b d))
    )
)

(deftest testnthcdr()
  (setf x '(a b c d e))
  (check
    (equal (nthcdr 3 x) '(d e))
    (equal (nthcdr 2 x) '(c d e))
    (equal (nthcdr 4 x) '(e))
    (equal (nthcdr 5 x) nil)
  )
)

(deftest testmapcar()
  (check
    (equal (mapcar #'(lambda (x) (/ x 10)) '(100 20 40)) '(10 2 4))
    )
)

(deftest testsubstitute()
  (check
    (equal (subst 'b 'a '(A good time)) '(b good time))
    )
)

(deftest testadjoin()
  (check
    (equal (adjoin 'q '(a b c)) '(q a b c))
    (equal (adjoin 'a '(a b c)) '(a b c))
    )
)

(defun compress (x)
  (if (consp x)
      (compr (car x) 1 (cdr x)) x))

(defun compr(elt n lst)
  (if (null lst)
      (list (n-elts elt n))
      (let ((next (car lst)))
        (if (eql next elt)
            (compr elt (+ n 1) (cdr lst))
            (cons (n-elts elt n)
                  (compr next 1 (cdr lst)))))))


(defun n-elts(elt n)
  (if (> n 1)
      (list n elt)
      elt))

(deftest testcompress()
  (check
    (equal (compress '(2 2 3 4 4 5 3 2 2)) '((2 2) 3 (2 4) 5 3 (2 2)))
    )
  )

(defun uncompress(lst)
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

(deftest testuncompress()
  (check
    (equal (uncompress '((2 2) 3 (2 4) 5 3 (2 2))) '(2 2 3 4 4 5 3 2 2))
  )
 )

(defun shortest-path(start end net)
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

(defun new-paths(path node net)
  (mapcar #'(lambda (n)
              (cons n path))
          (cdr (assoc node net))))
   
(deftest testshortestpath()
  (setf network '((1 2) (2 3 5 6) (3 5 6) (5 6)))
  (check
    (equal (shortest-path '1 '6 network) '(1 2 6))
   )
 )

;start chapter 4
(deftest testarray()
  (setf arr (make-array '(2 3) :initial-element nil))
  (setf (aref arr 1 2) "This String")
  (check
   (equal (aref arr 1 2) "This String")
  )
)

(deftest teststringmanip()
  (check
    (equal (let ((str (copy-seq "AdvancedAI")))
             (setf (char str 0) #\a)
             str) "advancedAI")
  )
)

(deftest testconcatenate()
  (check
    (equal (concatenate 'list '(a b c) '(d e f)) '(a b c d e f))
    (equal (concatenate 'list '(a b c) '(b e f)) '(a b c b e f))
   )
 )





;start required figure 4.2
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

(defun removeabcde(inputchar)
  (not (or (char= #\a inputchar)
      (char= #\b inputchar)
      (char= #\c inputchar)
      (char= #\d inputchar)
      (char= #\e inputchar)
      (char= #\  inputchar)
      ))
 )

(deftest testtokens()
  (check
    (equal (tokens "1 2 3 4 a b c d e f g h" #'removeabcde 0) '("1" "2" "3" "4" "f" "g" "h"))
   )
 )
;;end required 4.2

(deftest testremoveduplicates()
  (check
    (equal (remove-duplicates "AdvancedAI") "vancedAI")
    (equal (remove-duplicates "ADVANCEDAI") "VNCEDAI")
   )
 )

(deftest testposition()
  (check
    (equal (position #\q "quicken") 0)
    (equal (position #\q "AdvancedAI") nil)
    (equal (position #\A "ADVANCEDAI" :start 3 :end 8) 3)
   )
 )


(defstruct name
  firstname
  lastname
  middleinitial)

(deftest testdefstruct()
  (setf student (make-name :firstname "John" :lastname "Handcock" :middleinitial "P"))
  (check
    (equal (name-firstname student) "John")
    (equal (name-lastname student) "Handcock")
   )
 )

;;start required 4.5
(defstruct (node (:print-function
                  (lambda (n s d)
                    (format s "#<~A>" (node-elt n)))))
  elt (l nil) (r nil))

(defun bst-insert (obj bst <)
  (if (null bst)
      (make-node :elt obj)
      (let ((elt (node-elt bst)))
        (if (eql obj elt)
            bst
            (if (funcall < obj elt)
                (make-node
                 :elt elt
                 :l (bst-insert obj (node-l bst) <)
                 :r (node-r bst))
                (make-node
                 :elt elt
                 :r (bst-insert obj (node-r bst) <)
                 :l (node-l bst)))))))

(defun bst-find (obj bst <)
  (if (null bst)
      nil
      (let ((elt (node-elt bst)))
        (if (eql obj elt)
            bst
            (if (funcall < obj elt)
                (bst-find obj (node-l bst) <)
                (bst-find obj (node-r bst) <))))))

(defun bst-min(bst)
  (and bst
       (or (bst-min (node-l bst)) bst)))

(defun bst-max(bst)
  (and bst
       (or (bst-max (node-r bst)) bst)))


(deftest testbinarysearchtree()
  (setf ids nil)
  (dolist (x '(7010782 7002376 7002372 7004363 7012373 7002378))
    (setf ids (bst-insert x ids #'<)))

  (check
    (bst-find 7002372 ids #'<)
    (not (bst-find 7003746 ids #'<))
   )
 )
;;end figure 4.5

;;start figure 4.6
(defun bst-remove(obj bst <)
  (if (null bst)
      nil
      (let ((elt (node-elt bst)))
        (if (eql obj elt)
            (percolate bst)
            (if (funcall < obj elt)
                (make-node
                 :elt elt
                 :l (bst-remove obj (node-l bst) <)
                 :r (node-r bst))
                (make-node
                 :elt elt
                 :r (bst-remove obj (node-r bst) <)
                 :l (node-l bst)))))))

(defun percolate (bst)
  (cond ((null (node-l bst))
         (if (null (node-r bst))
             nil
             (rperc bst)))
        ((null (node-r bst)) (lperc bst))
        (t (if (zerop (random 2))
               (lperc bst)
               (rperc bst)))))

(defun rperc (bst)
  (make-node :elt (node-elt (node-r bst))
             :l (node-l bst)
             :r (percolate (node-r bst))))

(defun lperc (bst)
  (make-node :elt (node-elt (node-l bst))
             :l (percolate (node-l bst))
             :r (node-r bst)))


(deftest testbinarytreeremove()
  (setf ids nil)
  (dolist (x '(7010782 7002376 7002372 7004363 7012373 7002378))
    (setf ids (bst-insert x ids #'<)))

  (check
    (bst-find 7002372 ids #'<)
    (not (bst-find 7003746 ids #'<))
   )
  (setf ids (bst-remove 7002372 ids #'<))
  (check
    (not (bst-find 7002372 ids #'<))
    (not (bst-find 7003746 ids #'<))
   )
)
;;end figure 4.6
                                      

(deftest testhashtable()
  (setf hashtable (make-hash-table))
  (setf (gethash 701029543 hashtable) "John Handcock")
  (setf (gethash 701029544 hashtable) "Jane Doe")
  (check
    (equal (gethash 701029543 hashtable) "John Handcock")
    (equal (gethash 701029544 hashtable) "Jane Doe")
    (not (gethash 701029545 hashtable))
  )

)

;;chapter 5

;;for section 5.1

(deftest testblock ()
      (check
         (equal (block nil
                  (return 27))
                27)))
 

;;for section 5.2
(deftest testletandlet* ()
	(setf a 6)
        (check
           (not (equal (let ((a 2)
                        (b (+ a 1)))
                    (* a b))
                  6))
           (equal (let* ((a 2)
                        (b (+ a 1)))
                    (* a b))
                  6)))
                       

;;for section 5.5
(deftest testmultiplevaluebind()
   (check
      (equal (multiple-value-bind (a b c)(values 1 2 3)
                 (list a b c))
             '(1 2 3))))


;;for figures 5.2
(if (not (boundp 'month))
    (defconstant month 
      #(0 31 59 90 120 151 181 212 243 273 304 334 365))
    )

(defconstant yzero 2000)

(defun leap? (y)
    (and (zerop (mod y 4))
         (or (zerop (mod y 400))
             (not (zerop (mod y 100))))))

(defun data->num (d m y)
    (+ (- d 1) (month-num m y)(year-num y)))

(defun month-num (m y)
    (+ (svref month (- m 1))
       (if (and (> m 2)(leap? y)) 1 0)))

(defun year-num (y)
   (let ((d 0))
     (if (>= y yzero)
        (dotimes (i (- y yzero) d)
          (incf d (year-days (+ yzero i))))
        (dotimes (i (- yzero y) (- d))
          (incf d (year-days (+ y i)))))))

(defun year-days (y)(if (leap? y) 366 365))

(defun num->data (n)
   (multiple-value-bind (y left) (num-year n)
     (multiple-value-bind (m d) (num-month left y)
       (values d m y))))

(defun num-year (n)
   (if (< n 0)
      (do* ((y (- yzero 1)(- y 1))
            (d (- (year-days y)) (- d (year-days y))))
           ((<= d n) (values y (- n d))))
      (do* ((y yzero (+ y 1))
            (prev 0 d)
            (d (year-days y) (+ d (year-days y))))
           ((> d n) (values y (- n prev))))))

(defun num-month (n y)
   (if (leap? y)
       (cond ((= n 59) (values 2 29))
             ((> n 59) (nmon (- n 1)))
             (t        (nmon n)))
       (nmon n)))

(defun nmon (n)
    (let ((m (position n month :test #'<)))
       (values m (+ 1 (- n (svref month (- m 1)))))))

(defun date+ (d m y n)
    (num->data (+ (data->num d m y) n)))

(deftest testdateconverting()
   (check
     (equal (multiple-value-list (date+ 17 12 1997 60))
            '(15 2 1998))))


;test for 6.1
(defun add6(x)
  (+ x 6)
  )
(deftest testsymbolfunction()
  (check
    (equal (add6 3) 9)
  )
  (setf (symbol-function 'add6)
        #'(lambda(x) (+ x 4)))
  (check
    (equal (add6 3) 7)
  )
)
;test for 6.2
(deftest testlabelsfunction()
  (check
    (equal
     (labels ((divideby4 (x) (divideby2 (divideby2 x)))
              (divideby2 (x) (/ x 2)))
       (divideby4 20)) 5)
    )
 )

;test for 6.3
(deftest testparameters()
  (labels ((doadd (x y &key z) (if(null z)
                                     (+ x y)
                                     (+ x y z)
                                     )
                     )
              )
    (check
      (equal (doadd 3 4) 7)
      (equal (doadd 3 4 :z 5) 12)
      )
    )
  )

;start 6.4
(defun givematching (comparator a b)
  (if (equal (funcall comparator a b) t)
      a
      b
  )
)

(deftest testutilityfunctions()
  (check
   (equal (givematching #'< 3 4) 3)
   (equal (givematching #'> 3 4) 4)
  )
 )

;start 6.5
(defun returnfalsealways(x y)
  (null t)
 )
(defun approvedcomparison(checkfunction)
  (if (or
       (eq checkfunction #'<)
       (eq checkfunction #'>)
       )
      checkfunction
      #'returnfalsealways
      )
 )

(deftest testapprovedcomparison()
  (check
    (equal (apply (approvedcomparison #'<) '(3 4)) t)
    (equal (apply (approvedcomparison #'>) '(4 3)) t)
    (equal (apply (approvedcomparison #'=) '(4 4)) nil)
    (equal (= 4 4) t)
  )
)


;start 6.9
(defun sumrecursion(integerlist)
  (if (null integerlist)
      0
      (+ (car integerlist) (sumrecursion (cdr integerlist)))
     )
 )

(deftest testrecursion()
  (check
    (equal (sumrecursion '(1 3 5 7)) 16)
    (equal (sumrecursion '(5 5 7 6)) 23)
    (equal (sumrecursion '(2 2 2)) 6)
  )
)

;;chapter 7
;;for section7.3
(deftest testnilformat()
   (check
     (equal (format nil "~,2F" 12.234555)
            "12.23")))


;;figure 7.1
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
  (make-buf  :vec (make-array len)))

(defun buf-insert (x b)
   (setf (bref b (incf (buf-end b))) x))

(defun buf-pop (b)
   (prog1
      (bref b (incf(buf-start b)))
      (setf (buf-used b) (buf-start b)
            (buf-new  b) (buf-end   b))))

(defun buf-next (b)
   (when (< (buf-used b) (buf-new b))
       (bref b (incf (buf-used b)))))

(defun buf-reset (b)
   (setf (buf-used b) (buf-start b)
         (buf-new  b) (buf-end   b)))

(defun buf-clear (b)
   (setf (buf-start b) -1 (buf-used b) -1
         (buf-new   b) -1 (buf-end  b) -1))

(defun buf-flush (b str)
   (do ((i (1+ (buf-used b)) (1+ i)))
       ((> i (buf-end b)))
     (princ (bref b i) str)))

(defun file-subst (old new file1 file2)
   (with-open-file (in file1 :direction :input)
      (with-open-file (out file2 :direction :output
                                 :if-exists :supersede)
         (stream-subst old new in out))))

(defun stream-subst (old new in out)
   (let* ((pos 0)
          (len (length old))
          (buf (new-buf len))
          (from-buf nil))
     (do  ((c (read-char in nil :eof)
              (or (setf from-buf (buf-next buf))
                  (read-char in nil :eof))))
          ((eql c :eof))
         (cond ((char= c (char old pos))
                (incf pos)
                (cond ((= pos len)        ; 3
                       (princ new out)
                       (setf pos 0)
                       (buf-clear buf))
                      ((not from-buf)     ;2
                       (buf-insert c buf))))
               ((zerop pos)
                (princ c out)
                (when from-buf
                  (buf-pop buf)
                  (buf-reset buf)))
               (t
                 (unless from-buf
                   (buf-insert c buf))
                 (princ (buf-pop buf) out)
                 (buf-reset buf)
                 (setf pos 0))))
   (buf-flush buf out)))

(defun readfile (file)
   (with-open-file (str file :direction :input)
     (do ((line (read-line str nil 'eof)
                (read-line str nil 'eof)))
          ((eql line 'eof))
        (return (values line)))))

;;a.txt here is a file contains 10 a's.
(deftest testfileread()
    (file-subst "a" "b" "proj1/deftests/a.txt" "proj1/deftests/b.txt")
    (check
       (equal (readfile "proj1/deftests/b.txt") "b b b b b b b b b b")))


; chp 10 

; 10.1
(deftest testEval ()
  (check
   (equal (eval '(+ 1 2 3)) 6)
   (equal (coerce "a" 'character) #\a)
   )
)

; 10.2
(defmacro mysetzero (x)
  (list 'setf x 0))


(deftest testMacro ()
  (mysetzero x)
  (check
    (equal x 0)
    (equal (macroexpand-1 '(mysetzero x)) '(setf x 0))
    )
)

; 10.3


(deftest testBackquote ()
  (setf lst '(a b c))
  (check
   (equal `(lst is ,lst) '(lst is (a b c)))
   (equal `(lst is ,@lst) '(lst is a b c))
   )
)

; 10.4

(defmacro while (test &rest body)
  `(do ()
       ((not ,test))
     ,@body))


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
    (if (> (- j l) 1) (quicksort vec l j))
    (if (> (- r i) 1) (quicksort vec i r)))
  vec)

(setf vec (vector 2 3 1 4 0 5))
(setf sortedVec (quicksort vec 0 5))

(deftest testQuickSort ()
  (check
    (equal (svref sortedVec 0) 0)
    (equal (svref sortedVec 1) 1)
    (equal (svref sortedVec 2) 2)
    (equal (svref sortedVec 3) 3)
    (equal (svref sortedVec 4) 4)
    (equal (svref sortedVec 5) 5)
    )
)


; 10.5
(defmacro ntimes (n &rest body)
  (let ((g (gensym))
	(h (gensym)))
    `(let ((,h ,n))
       (do ((,g 0 (+ ,g 1)))
	   ((>= ,g ,h))
	 ,@body))))

(deftest macroDesign ()
  (check
    (equal (let ((x 10)) (ntimes 5 (setf x (+ x 1))) x) 15)
    )
)


;start 10.6

(define-modify-macro our-decf(&optional (y 1)) -)

(deftest testdecrement()
  (setf initialvalue 22)
  (check
   (equal (our-decf initialvalue) 21)
   (equal (our-decf initialvalue 4) 17)
  )
)

;start 10.7

(defmacro aif (test then &optional else)
  `(let ((it ,test))
     (if it ,then ,else)))

(deftest testaif()
  (setf incrementor 0)
  (check
    (equal (aif (= (+ incrementor 1) 3) nil (incf incrementor)) 1)
    (equal (aif (= (+ incrementor 1) 3) nil (incf incrementor)) 2)
    (equal (aif (= (+ incrementor 1) 3) nil (incf incrementor)) nil)
  )
)

; figure 14.2
(defun most (fn lst)
  (if (null lst)
      (values nil nil)
      (loop with wins = (car lst)
	   with max = (funcall fn wins)
	   for obj in (cdr lst)
	   for score = (funcall fn obj)
	   when (> score max)
	   do (setf wins obj
		    max score)
	   finally (return (values wins max)))))

(deftest testLoopIter ()
  (check
    (equal (most #'length '((a b c) (a b) (a b c d))) '(a b c d))
    )
)
