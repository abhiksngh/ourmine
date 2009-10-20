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
         (new-header)
         (new-columns)
         )
    (dolist (item all) ; <== could appear as third arg
      (setf prob (probability item column))
      (setf sum (+ sum (* prob (i prob))))
      ; (incf sum (* prob (i prob)))
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
         (min-allowed-gain)
         (new-table)
         (new-header)
         (new-data)
         (transposed-data (transpose (get-data source-table)))
         )

      
    ;get info-gain for all columns
    (dolist (one-column transposed-data)
      (setf gain-lst (append gain-lst (list (compute-infogain one-column))))
      )
    
    ;get the max gain
    (setf max-gain (max-list gain-lst))

    ; get minimum gain
    (setf min-allowed-gain (* max-gain (/ percent 100)))

    ;for width of table
    (dotimes (n (table-width table))
      ;if the current gain is above the min-allowed-gain
      ;Keep
      ;(print min-allowed-gain)
      ;(print "versus")
      ;(print (nth n gain-lst))
      ;(print (< min-allowed-gain (nth n gain-lst)))
      ;(print " ")
      
      
      (if (< min-allowed-gain (nth n gain-lst))
          (progn
     ;       (print "found less")
                                        ;Add to new header
                                        ;Add column to new data
            
            (setf new-header (append new-header (list (nth n (columns-header (table-columns source-table))))))
            (setf new-data (append new-data (list (nth n transposed-data))))
            )
          )
      )


(if (not (equalp (last transposed-data) (last new-data)))
    (progn
      (setf new-data (append new-data (last transposed-data)))
      (setf new-header (append new-header (last (columns-header (table-columns source-table)))))))
                                        ;(print "new-header")
    ;  (print new-header)
    ;  (print (transpose new-data))
      (setf new-table (data
                      :name (table-name table)
                      :columns new-header
                      :klass (- (length (first (transpose new-data))) 1)
                      :egs
                      (transpose new-data)))
      ))

(defun max-list (lst)
  (let ((current-max (first lst)))
    (dolist (item lst)
      (setf current-max (max current-max item)))
    current-max))


(defun i (probability)
  (* (- 0 probability) (log probability 2)))

; (1- 


