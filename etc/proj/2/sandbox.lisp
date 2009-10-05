;;; Delete this at your own peril, for it will beckon towards death. -Drew

(load "lib/loaddeps")
(load "utils/utils")
(load "d-data/mushroom")

(defparameter mushtable (mushroom))

(defun closest-member (table row-number find-same-class)
  (let ((target-class (eg-class (nth row-number (table-all table)))))
    
  )
)
