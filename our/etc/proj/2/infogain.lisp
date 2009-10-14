; function infoGain(col,  all,klass,before,after,probKlass) {
; all  = Uniques[col,0]
; before = bitsInColumn(all,col);
; for(klass in N) {
; probKlass = N[klass]/Instances
; after  += probKlass * bitsInKlass(all,col,klass)
; }
; return before - after;
; }


;summation of probability squared * log(probability)


(defun compute-infogain (column);, all, klass, before, after , pKlass)
  (let* ((all (remove-duplicates column))
         (sum 0)
         (prob)
         )
    (dolist (item all)
      (setf prob (probability item column))
      (setf sum (+ sum (* (* prob prob) (log prob))))
;      (print sum)))
      )
    sum))




(defun probability (value lst)
  (let ((total 0))
    (dolist (item lst)
      (if (equalp item value)
          (incf total)))
    (/ total (length lst))))





(defun infogain (source-table percent)
  (let* ((table (copy-table source-table))
         (gain-lst)
         (max-gain)
         (new-table)
         (transposed-data (transpose (get-data source-table)))
         )
;get info-gain for all columns
    (dolist (one-column transposed-data)
      
      (setf gain-lst (append gain-lst (list (compute-infogain one-column))))
      )

    (setf max-gain (max-list gain-lst))
    
    max-gain))


(defun max-list (lst)
  (let ((current-max (first lst)))
    (dolist (item lst)
      (setf current-max (max current-max item)))
    current-max))