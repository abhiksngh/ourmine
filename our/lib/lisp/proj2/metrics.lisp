(defun metrics (A B C D args &optional header)
  "args is a list of the functions that were passed to the learner"
  (let* ((prec (/ D (+ C D)))
         (acc (/ (+ A D) (+ A B C D)))
         (pd (/ D (+ B D)))
         (pf (/ C (+ A C)))
         (f (/ (* 2 prec 1) (+ prec 1))) ; 1 = recall, whatever recall is
         (g (/ (* 2 pf pd) (+ pf pd)))
         (params (list A B C D acc prec pd pf f g)))
    (setf args (check-for-nulls args))
    (setf table (list (append args params)))
    (if (null header)
        (setf table (cons (get-header) table)))
    (format t "~:{~&~8@A, ~8@A, ~8@A,  ~8@A,   ~8@A, ~8@A, ~8@A, ~8@A, ~8@A, ~8@A, ~8@A, ~8@A, ~8@A, ~8@A, ~8@A, ~8@A ~}" table)) t)

(defun display-header ()
  (format nil "~:{~D,~8@A, ~8@A, ~8@A, ~8@A, ~8@A, ~8@A, ~8@A, ~8@A, ~8@A, ~8@A, ~8@A, ~8@A, ~8@A, ~8@A, ~8@A ~}"
          '((prep discretizer cluster fss classify class a b c d acc prec pd pf f g))))

(defun check-for-nulls (args)
  "checks for null arguments in 'args' and replaces them with 'doNothing"
  (dolist (item args args)
    (if (null item)
        (setf (nth (position item args) args) 'doNothing))))
              
(defun get-header()
  (setf header '(prep discretizer cluster fss classify class a b c d acc prec pd pf f g))
  header)
