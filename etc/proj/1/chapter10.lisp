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

;;; 10.5 Macro Design

;;; 10.6 Generalized Reference

;;; 10.7 Macro Utilities

