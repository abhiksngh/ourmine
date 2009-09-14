;;; 10.1 Evaluate

(deftest evaluation ()
  (check (equalp
    9
    (eval `(+ 3 3 3)))))

;;; 10.2 Macros [Required]

(defmacro truthify (x)
  (list 'setf x T))

(deftest macro ()
  (let ((n nil))
    (truthify n)
    (check n)))

;;; 10.3 Backquote

(deftest backquote () 
  (check (equalp
    '(B 2 M)
    `(B ,(+ 1 1) M))))

;;; 10.4 Quicksort
;; Liberally lifted from page 165, Common ANSI Lisp
(defun quicksort (vec 1 r)
  (let ((i l)
	(j r)
	(p svref vec (round (+ 1 r) 2)))
    (while (<= i j)
      (while (< (svref vec i) p) (incf i))
      (while (> (svref vec j) p) (decf j))
      (when (<= i j)
	(rotatef (svref vec i) (svref vec j))
	(incf i)
	(decf j)))
    (if (> (- j 1) 1) (quicksort vec 1 j))
    (if (> (- r i) 1) (quicksort vec i r)))
  vec)





;;; 10.5 Macro Design

;;; 10.6 Generalized Reference

;;; 10.7 Macro Utilities

