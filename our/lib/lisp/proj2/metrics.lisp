(defun check-for-nulls (args)
  "checks for null arguments in 'args' and replaces them with 'doNothing"
  (dolist (item args args)
    (if (null item)
        (setf (nth (position item args) args) 'doNothing))))
              
(defun get-header()
  (setf header '(prep discretizer cluster fss classify class a b c d acc prec pd pf f g))
  header)


(defun compute-metrics (A B C D)
  (let* ((prec (/ D (+ C D)))
         (acc (/ (+ A D) (+ A B C D)))
         (pd (/ D (+ B D)))
         (pf (/ C (+ A C)))
         (f (/ (* 2 prec (/ pd pf)) (+ prec (/ pd pf))))
         (g (/ (* 2 pf pd) (+ pf pd)))
         (params (list A B C D acc prec pd pf f g)))
    params))


(defun row-metrics (params A B C D)
  "creates a simgle row that would be added to a table of metrics to be printed out
params is the parameters passed to 'learn' as a list"
  (let* ((table))
    (setf params (check-for-nulls params))
    (setf table (list (append (compute-metrics A B C D) params)))
    table))


(defun print-metrics (table)
  "takes a table containing rows of data to be printed out, appends a header to it and prints it out"
  (setf table (cons (get-header) table))
  (format t "~:{~&~8@A, ~8@A, ~8@A,  ~8@A,   ~8@A, ~8@A, ~8@A, ~8@A, ~8@A, ~8@A, ~8@A, ~8@A, ~8@A, ~8@A, ~8@A, ~8@A ~}" table))


;; (setf row (row-metrics '(param1, param2, param3...) 1 2 3 4))
;; repeat for any other row of data, until you have a list of lists representing the table to be printed then call
;; (print-metrics table)
