(defun make-data-Enjoy-Sports ()
  (data
   :name   'EnjoySports
   :columns '(Sky AirTemp Humidity Wind Water Forecast EnjoySports)
   :egs    '((Sunny Warm Normal Strong Warm Same Yes) 
             (Sunny Warm High Strong Warm Same Yes)
             (Rainy Cold High Strong Warm Change No)
             (Sunny Warm High Strong Cool Change Yes)
             )))


(defun find-s (train)
  (let ((inst (table-all train))
        (hypothesis '(0 0 0 0 0 0)))
    (dolist (obj inst)
      (if (equal (eg-class obj) 'Yes)
          hypothesis))))


(defun generalize (hypothesis instance)
  (if (null hypothesis)
      nil
      (cons (consistent (car hypothesis) (car instance))
              (generalize (cdr hypothesis) (cdr instance)))))

(defun consistent(hyp inst)
  (if (equal hyp inst) hyp
      (if (equal hyp 0) inst '?)))
