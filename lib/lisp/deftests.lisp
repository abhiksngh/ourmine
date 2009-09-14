;2.2.1 Simple Evaluation

(deftest test-2_2-1 ()
  (check
    (eql (+ 40 40) '80)))

;2.2.2 Quote Function

(deftest test-2_2-2 ()
  (check
    (equalp (quote (+ 10 10)) '(+ 10 10))))

;2.3.1 List Function

(deftest test-2_3-1 ()
  (check
    (equalp (list (+ 1 1 1) 'times 'the 'fun)
         '(3 TIMES THE FUN))))

;2.4.1 cons Function

(deftest test-2_4-1 ()
  (check
    (equalp (cons 'white (cons 'russians nil)) '(white russians))))

;2.4.2 car Function

(deftest test-2_4-2 ()
  (check
    (equalp (car '(10 9 8 7 6)) '10)))

;2.4.3 cdr function

(deftest test-2_4-3 ()
  (check
    (equalp (cdr '(1 2 3)) '(2 3))))

;2.4.4 nth function

(deftest test-2_4-4 ()
  (check
    (equalp (fourth '(4 3 2 1)) '1)))

;2.5.1 listp function

(deftest test-2_5-1 ()
  (check
    (eql (listp '(this is a list)) 't)))

;2.6 defun

(defun quickfun (x)
  (* x x))

(deftest test-2_6 ()
  (check
    (eql (quickfun 6) 36)))

;2.10 Variables (let statement)

(defun 2_10 (x)
  (let ((thisvar 1000))
    (+ x thisvar)))

(deftest test-2_10 ()
  (check
    (eql (2_10 -999) 1)))

;simple car and cdr test
(deftest test-3-1-1() (check (eql 'c (car(cdr(cdr '(a b c d e f)))))))

;simple car test
(deftest test-3-1-2() (check (eql 'a (car '(a b c d e f)))))

;simple cdr test
(deftest test-3-1-3() (check (equalp '(b c d e f) (cdr '(a b c d e f)))))

;test for third function
(deftest test-3-1-4() (check (equalp 'c (third'(a b c d e f)))))

(defun myfunction (x) (+ x 10))
;test for simple user defined function
(deftest test-3-1-5() (check (eql 14 (myfunction 4))))

;cons test
(deftest test-3-1-6() (check (equalp '(4) (cons '4 nil))))

;setf test
(deftest test-3-4-1() (check (equalp (setf x 10) 10)))

;test for append function
(deftest test-3-4-2() (check (equalp '(a b c d e f) (append '(a b c d e) '(f)))))

;test for nth function
(deftest test-3-6-1() (check (equalp 'e (nth 4 '(a b c d e f)))))

;test for nthcdr function
(deftest test-3-6-2() (check (equalp '(e f) (nthcdr 4 '(a b c d e f)))))

;6.1 Global Functions

(setf (symbol-function 'times5) 
      #'(lambda (x)  (* x 5)))

(deftest test-6_1 ()
  (check
    (eql (times5 9) (* 5 9))))


;6.2 Local Functions

(deftest test-6_2 ()
  (check
    (labels ((times5 (x) (* x 5))
             (consa (x) (cons 'a x)))
      (consa (eql (times5 5) (* 5 5))))))

 ;6.3 Parameter Lists

(defun interestingfact (subject &optional fact)
  (list subject 'is fact))

(deftest test-6_3 ()
  (check
    (equalp (interestingfact 'emacs 'terrible) '(emacs is terrible))))

 ;6.4 Utility Functions
(defun combinelists (1st 2nd &optional 3rd)
  (append 1st 2nd 3rd))

(deftest test-6_4_1 ()
  (setf x '(THIS IS A LIST))
  (setf y '(IN LISP))
  (setf xy (combinelists x y))
  (check
    (equal xy '(THIS IS A LIST IN LISP))))

(defun multipleElements? (someList)
  (not (null (cdr someList))))

(deftest test-6_4_2 ()
  (setf x '(THIS IS))
  (check
    (equalp (multipleelements? x) T)))

;6.5 Closures ( A little confused on this section )

(defun addnumbers (x y)
  (+ x y))

;(deftest test-6_5 ()
;  (setf b (add ))
;  (check
;    (eql (funcall b 10) (+ (+ 55 55) 55))))

;6.9 Recursion

(defun recurseFactorial(n)
  (if (<= n 1)
      1
      (* n (recurseFactorial (- n 1)))))

(deftest test-6_9 ()
  (check
    (equal (recurseFactorial 3) 6)))

;;Group 21
;;Project 1
;;chapter10.lisp
;;Created 9/3/09
;;Last Modified 9/14/09

;10.1 Eval function
;Forces LISP to evaluate a list as code

(deftest test-10_1 ()
  (check
    (eql (eval '(* 8 8 8)) 512)))

;10.2 Macros
;

(defmacro set-to-happy (x)
  (list 'setf x 1))

(let ((y 0))
  (set-to-happy y)
   (deftest test-10_2 ()
     (check
       (eql y 1))))

;10.3 Backquote
(let ((var1 'cat) (var2 'hat))
  (deftest test-10_3 ()
    (check
      (equalp `(The ,var1 in the ,var2) '(the cat in the hat)))))
;10.4 Quicksort

(defmacro while(test &rest body)
  `(do ()
       ((not ,test))
     ,@body))

(defun quicksort(vec l r)
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
    (if (< (- r i) 1) (quicksort vec i r)))
  vec)
    
;10.5 Macro Design

(defmacro ntimes (n &rest body)
  (let ((g (gensym))
        (h (gensym)))
    `(let ((,h ,n))
       (do ((,g 0 (+ ,g 1)))
           ((>= ,g ,h))
         ,@body))))

(deftest test-10_5 ()
  (check
    (string-equal (ntimes 10 (princ ".")) nil)))

;10.6 Generalized References
(deftest test-10_6()
  (define-modify-macro append1f (val)
    (lambda (lst val) (append lst (list val))))
  (check
   (equalp (let ((lst '(w x y)))
    (append1f lst 'z)
    lst)
	   '(w x y z))))
     

;10.7 Example: Macro Utilities

(defmacro avg (&rest args)
    `(/ (+ ,@args) ,(length args)))

(deftest test-10_7 ()
  (check
    (equalp (avg 200 1000 6) 402)))


;14.5  Iteration with loop

(deftest test-14_5 ()
  (check
    (equalp (loop for x in '(11 12 13 14)
                 collect (1+ x)) '(12 13 14 15))))
