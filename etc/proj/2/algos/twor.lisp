;;; Claimee: Tim
;; Classifiers make decisions. 

(print " - Loading TwoR") ;; Output for a pretty log

(defun mkstruct (tbl)
  "Makes a structure based off of the unique classes in a dataset"
; Use as: (make-class-str
  (let ((x (justclasses tbl)) (m '()))
    (dotimes (n (length x))
      (push `(,(pop x) 0) m))
    (push 'class-str m)
    (push 'defstruct m)
    (eval m)))

(defun make-stat-table (tbl)
  "Creates an assoc list of structs designed to hold frequency data structs"
  (let ((strlst '()) (col 0))
    (dolist (l (allvals tbl))
      (let ((values '()))
	(dotimes (n (length l))
	  (push (cons (nth n l) (make-class-str)) values))
	(push (cons col values) strlst))
      (incf col))
    (cdr strlst)))

(defun twor (tbl)
  (let* ((stat-struct (mkstruct tbl))
	 (stat-table (make-stat-table(tbl))))
    (dolist (l (allvals tbl))
      (print l)))
  tbl)

   



;;for each column a
;;;;;;for each value, v, in a
;;;;;;;;;;