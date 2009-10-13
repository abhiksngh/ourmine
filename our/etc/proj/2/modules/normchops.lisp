(defun normal-chops (tbl)
  (let (normval
        (rtntable (copy-table tbl))
        (bins (make-array 7))
        std
        m
        (n 0))
    (init-bins bins 7)
     
    (dolist (column (table-columns rtntable))
      (when (typep column 'numeric)
        (setf normval (fill-normal rtntable n))
        (setf std (stdev normval))
        (setf m (mean normval))
        (dolist (record (table-all rtntable))
          (chopscan record bins n m std))
        (incf n)
        (push (build-bin-list bins) (table-ranges rtntable))
        (init-bins bins 7)
     ))
    (setf (table-ranges rtntable) (reverse (table-ranges rtntable)))
    rtntable
  ))

(defun chop-it-up (record bins i column-number mean stddev
                   &key (lower-bound -3) (upper-bound 3))
  (when (funcall (directional-compare i)
                 (nth column-number (eg-features record))
                 (+ mean (* (directional-integer i) stddev)))
    (add (aref bins (+ upper-bound i))
         (nth column-number (eg-features record)))
    (setf (nth column-number (eg-features record))
          (format nil "bin ~a" i))
    (return-from chop-it-up t))
  nil)

(defun chopscan (record bins column-number mean stddev
                 &key (lower-bound -3) (upper-bound 3))
  (loop for i from lower-bound upto 0 do
       (when (chop-it-up record bins i column-number mean stddev)
         (return-from chopscan bins)))
  (loop for i from upper-bound downto 1 do
       (when (chop-it-up record bins i column-number mean stddev)
         (return-from chopscan bins))))

    


  
