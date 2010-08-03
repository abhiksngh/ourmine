(defun appendl (a b) (append a (list b)))

(defmethod print-object ((h hash-table) str)
  (format str "{hash of ~a items}" (hash-table-count h)))
