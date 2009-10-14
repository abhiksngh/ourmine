


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
         (discrete-check-lst)
         (column-contents)
         (fixed-data)
         (newtable)
         (transposed-data (transpose (get-data table))))
    
    ;(print transposed-data)
    (dolist (one-column transposed-data)
     ; (
    
    ;(dotimes (col-count (table-width table))
      ;Get the column
      ;(setf column-contents (nth col-count 
      ;(setf column-contents (get-col table col-count))
      ;Is the column numeric?
      ;(print "With ?:")
      ;(print (remove '? one-column))
      ;(print one-column)
      ;(print discrete-check-lst)
      
      (if (equalp (listp (remove '? one-column)) NIL)
          (setf one-column (list one-column)))
      
      (setf discrete-check-lst (remove-duplicates (mapcar #'is-discrete (remove '? one-column))))
      
      (if (subsetp '(t) discrete-check-lst)
          (setf discrete-check-lst '(t)))
      
;      (print "discrete check result:")
;      (print discrete-check-lst)
;      (print (equalp discrete-check-lst '(t)))

      (if (equalp (remove '? one-column) NIL)
          (progn
            ;(print "this")
            ;(print (columns-header (table-columns source-table)))
            ;(print one-column)
            (setf one-column (fix-unknowns one-column '??))
            (setf fixed-data (append fixed-data (list one-column)))
            )
          
          (progn
            (if (equalp discrete-check-lst '(t))
                (progn
                 ; (print "Discrete column")
                  (setf most-common-value (get-most-common one-column))

                  ;(print "most common:")
                  ;(print most-common-value)

                  (setf one-column (fix-unknowns one-column most-common-value))
                  (setf fixed-data (append fixed-data (list one-column)))
                  ;(print one-column)
                  )
                (progn
                                        ;If column is numeric
                 ; (print "Numeric column")
                  (setf median-value (get-median one-column))

                 ; (print median-value)
                 ; (print median-value)

                  (setf one-column (fix-unknowns one-column median-value))
                  (setf fixed-data (append fixed-data (list one-column)))  
                  ;(print one-column)
                  )
                )
            )
          )
      )
           
              
            
;    (print (transpose fixed-data))
;    (setf (get-data table) (transpose fixed-data))
    (setf fixed-data (transpose fixed-data))
    (dotimes (n (table-width table))
      (setf (eg-features (nth n (table-all table))) (nth n fixed-data)))
                                        ;(print (eg-features (nth n (table-all table)))))
;    (print (first fixed-data))
    ;(print "UP THERE")
    
    (setf newtable (data
                    :name (table-name table)
                    :columns (columns-header (table-columns table))
                    :klass (table-class table)
                    :egs
                    fixed-data))
    
    newtable))
                                       ;  Here up
          

(defun is-discrete (item)
   (not (numberp item)))
;(if (numberp item)

(defun fix-unknowns (lst replacement-value)
  (let ((newlst))
    (dolist (item lst)
      (if (equalp item unknown)
          (setf newlst (append newlst (list replacement-value)))
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
    (setf sorted-lst (sort (remove '? num-list) '<))
    (if (equalp (mod (length sorted-lst) 2) 0)
        (progn
          ;(print "even length")
          (setf median-value (/(+ (nth (/(length sorted-lst) 2) sorted-lst) (nth (- (/(length sorted-lst) 2) 1) sorted-lst)) 2))                               )
        (progn
          ;(print "odd length")
          (setf median-value (nth (/ (- (length sorted-lst) 1) 2) sorted-lst))))
    median-value))



(defun get-most-common (lst)
  (let ((most-common 'temp)
        (current-max 0)
        (count)
        (lst2))
    (setf lst2 (remove '? lst))
    (dolist (check-item lst)
      ;(print most-common)
      (setf count 0)
      ;(print check-item)
      (dolist (current-item lst2)
        ;(print `(,check-item ,current-item))
        (if (equalp check-item current-item)
            (incf count))
        ;(print count)
        ;(print current-max)
        (if (> count current-max)
            (progn
              (setf current-max count)
              (setf most-common check-item)))))
        ;(print most-common)))
    most-common))
                                        ;)))

(defun get-data (table)
  (let ((table-data))
    (mapcar #'eg-features (table-all table))))


(deftest test-median ()
  (check
    (equalp (get-median (get-col (group1bolts) 0)) '24.5)))



(deftest test-most-common ()
  (check
    (equalp (get-most-common '(x x y y y y z)) 'y)))

(deftest test-fill ()
  (check
    (equalp (eg-features (table-all (fill-in (anneal)))) '(TN C A 0 85 T S 2 0 N P G 2 Y Y Y M Y C P Y Y Y B Y COIL 4 610 0 Y 500 3 U))))
