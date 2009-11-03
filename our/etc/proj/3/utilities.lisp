

(defun get-col (table n)
  (let ((lst))
    (dolist (item (table-all table))
      (setf lst (append lst (list (nth n (eg-features item))))))
    lst))


(defun get-data (table)
  ;(let ((table-data))
    (mapcar #'eg-features (table-all table)))


(defun transpose (x)
  (apply #'mapcar (cons #'list x)))


(defun is-discrete (item)
   (not (numberp item)))

(defun is-column-discrete (column)
  (let* ((reduced-column (remove-duplicates (remove '? column)))
         (truth-lst)
          )
    (setf truth-lst (append truth-lst (mapcar #'is-discrete reduced-column)))

    (if (subsetp '(t) truth-lst)
        't
        NIL
        )
    )
  )


(defun reorient-data (data)
  (reverse (transpose (data))))