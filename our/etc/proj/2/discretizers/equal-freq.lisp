;Percentile chop: diver data into N equal sized bins

;    * Pass1: collect all numbers for each column. Sort them. Break the sorted numbers into N equal frequency regions (checking that numbers each size of the break are different).
;    * So the frequency counts in each bin is equal (flat histogram).
;    * Example: In practice, not quite flat. e.g. 10 equal frequency bins on the above data:

;      0,0,0,0,0,0,0,0,1,1,1,1,1,1,1,2,2,2,2,3,4,5,10,20,40,80,100
;      -----|----|-----|-----|-----|-----|-----|------|---------|
;      bin1  bin2 bin3  bin4  bin5  bin6  bin7  bin8   bin9
;
;    * Note the buckets with repeated entries. Its a design choice what to do with those.
;    * We might squash them together such that there are no repeats in the numbers that are the boundaries between bins.
;
;      0,0,0,0,0,0,0,0,1,1,1,1,1,1,1,2,2,2,2,3,4,5,10,20,40,80,100
;      --------------|-------------|--------|----|-------|-------
;      bin1           bin2          bin3     bin4 bin5     bin6 

(defun equal-freq (data &optional (nbins 10))
    (let* ((len (length (columns-header (table-columns data))))
           (per-bin (floor (/ (negs data) nbins)))
           (egs) (features))

       ; for each column
        (loop for i from 0 to (- len 1)
            do
                ; sort the data by that column
                (setf egs (table-all (sort-table2 data i)))
                
                ; replace values with bin #, "per-bin" in each bin
                (doitems (per-instance j egs)
                    (setf features (eg-features per-instance))
                    (setf (nth i features) (floor (/ j per-bin)))
                )
        )
        egs
       ; data 
    
; we need to determine a number of bins, nbins, divide the #cols by it
; that will give us how many in each bin, so starting at the first one
; we say it's bin 0, up until bin-size.  Then we check the next value
; and if it's the same as the current, call it bin 0 too until the value
; changes.  Then increment the bin number and start assigning the next ones
    )
)

(defun sort-table2 (tbl col)
    (setf (table-all tbl)
        (sort (table-all tbl) 'string-lessp :key #'(lambda (n)
                  (format nil "~A" (nth col (eg-features n))))))
    tbl
)

