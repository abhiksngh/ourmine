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

;Figure 10.2

(defmacro for (var start stop &body body)
  (let ((gstop (gensym)))
    `(do ((,var ,start (1+ ,var))
          (,gstop ,stop))
          ((> ,var ,gstop))
          ,@body)))

(let ((sum 0))
  (for x 1 30 (setf sum (+ x sum)))
  (deftest test-fig-10_2 ()
    (check
      (eql sum 465))))

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