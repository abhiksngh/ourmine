(defun discretize2 (train &key (k 10))
  (let* ((cols (table-columns train))
         (ranges '())
         (class (table-class train))
         (new-inst '())
         (instances (get-features (table-all train))))
    (dolist (cl cols)
      (if (not (header-classp cl))
      (setf ranges (append ranges (list (col-range cl train))))))
    (dolist (inst instances)
      (setf new-inst (append new-inst
                             (list (append (disc-instance ranges inst k class)
                                     (list (nth class inst)))))))
    (make-desc-table (table-name train) (table-columns train) (reverse new-inst))))
    


(defun col-range (col train)
  (let* ((classes (klasses train))
         (min most-negative-fixnum)
         (max most-positive-fixnum))
    (doitems (cl n  classes)
      (if (not (header-classp col))
      (multiple-value-bind (ma mi)(get-range col cl)
        (if (>= max mi)(setf min mi))
        (if (<= min ma)(setf max ma)))))
    (list min max)))

(defun get-bin (value range k-bins)
  (let* ((min (car range))
         (max (car (last range)))
         (r (/ (- max min) k-bins))
         (bin))
    (setf bin (floor (float (/ (- value min) r))))))

(defun disc-instance (ranges inst k-bins class)
  (let* ((new-inst '()))
    (doitems (value n inst)
      (if (not (equal n class))
          (setf new-inst (append new-inst (list (get-bin value (nth n ranges) k-bins))))))
  new-inst))
         
(defun make-desc-table (name cols instances)
  (let* ((new-cols))
    (dolist (c cols)
      (setf new-cols (append new-cols (list (remove #\$ (symbol-name (header-name c)))))))
    (data :name name
          :columns new-cols
          :egs instances)))

(defun make-simple-table (name cols instances)
  (let* ((new-cols))
    (dolist (c cols)
      (setf new-cols (append new-cols (list (header-name c)))))
    (data :name name
          :columns new-cols
          :egs instances)))

(defun table-egs-to-lists (data)
  (get-features (table-all data)))




                        
                       
