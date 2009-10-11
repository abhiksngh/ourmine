;Replace all "?" with the most common symbol (in discrete columns)
;or the median value (in numeric columns) for rows of that class.


;psuedo
;for each column
;if numeric, get the median of all items, skipping "?"
;if discrete, replace with most common discrete

(defconstant unknown '?)

(defun fill-in (source-table)
  (let* ((symbol-list)
         (table (copy-table source-table))
         (median-value)
         (most-common-value)
         (numeric-check-lst)
         (column-contents)
         )
    (dotimes (col-count (table-width table))
      ;Get the column
      (setf column-contents (get-col table col-count))
      ;Is the column numeric?
      (setf numeric-check-lst (remove-duplicates (mapcar #'is-discrete column-contents)))

      (if (equalp numeric-check-lst 't)
          (progn
            ;If column is numeric
            (print "Numeric column")
            (setf median-value (get-median column-contents))
            
          )
          (progn
            (print "Discrete column")
          

(defun is-discrete (item)
  (or (not (numberp item)) (not (equalp item unknown)) 't))
;(if (numberp item)

(defun fix-unknowns-nums (lst median)
  (let ((newlst))
    (dolist (item lst)
      (if (equalp item unknown)
          (setf newlst (append newlst (list median)))
          (setf newlst (append newlst (list item)))))
    newlst))
  
    
;returns list of column n
(defun get-col (table n)
  (let ((lst))
    (dolist (item (table-all table))
      (setf lst (append lst (list (nth n (eg-features item))))))
    lst))


(defun get-median (num-list)
  (let ((sorted-lst)
        (median-value))
    (setf sorted-lst (sort num-list '<))
    (if (equalp (mod (length sorted-lst) 2) 0)
        (setf median-value (/ (+ (nth (/(length sorted-lst) 2) sorted-lst) (nth (- (/(length sorted-lst) 2) 1) sorted-lst)) 2))                               
        (setf median-value (nth (+ 1 (/ (- (length sorted-lst) 1) 2)) sorted-lst)))
    median-value))

(deftest test-median ()
  (check
    (equalp (get-median (get-col (group1bolts) 0)) '24.5)))

;(defun get-most-common-item (lst)
 ; (let ((current

    