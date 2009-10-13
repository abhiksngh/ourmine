(defun normal-chops (tbl &optional(n (- (table-width tbl) 1)))
  (let (normval
        (normalbins (make-normbins))
        (bins (make-bin))
        std
        m)
    (setf normval (fill-normal tbl n))
    (setf std (stdev normval))
    (setf m (mean normval))    
    m))
  
