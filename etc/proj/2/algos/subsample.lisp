;;; Subsample: Poll data for a tally on all the classes.  Find the smallest class, and randomly delete
;;;   lines until they are all equal in prevelence.  Once the classes are all the same size, the data
;;;   is now ready for the discretizer.

;;; Claimee: Drew

(print " - Loading Subsample") ;;; Logging for a pretty run.

(defun count-classes (table)
  (let ((class-count (make-hash-table)) (seen nil) (ranks nil))
    (dolist (x (table-all table)) 
      (if (null (gethash (eg-class x) class-count))
        (setf (gethash (eg-class x) class-count) 1 seen (append seen (list (eg-class x))))
        (setf (gethash (eg-class x) class-count) (+ 1 (gethash (eg-class x) class-count)))
      )
    )
    (dolist (x seen)
      (setf ranks (append ranks (list (list x (gethash x class-count)))))
    )
    ranks
  )
)

(defun minority-class (table)
  (let ((minority (list nil 0)) (ranks (count-classes table)))
    (dolist (x ranks)
      (if (or (< (second x) (second minority)) (equalp (second minority) 0))
        (setf minority x)
      )
    )
    (first minority)
  )
)

(defun subsample (table)
  (let ((minority (minority-class table)) (ranks (count-classes table)))
   ;;; Poll for frequency of all class types.  Keep tally.
   ;;; Identify smallest class, hold this value.
   ;;; Begin to do multiple passes over the data.  If a class is encountered that is too large,
   ;;;   randomly decide to remove it or not, decrement tally.
   ;;; At the end of a pass, if all counts are not equal, pass again.  Else, return data subset. 
  )
)
