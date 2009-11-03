(defun GAC (tbl)
  (let ((column-names nil)
        (node-list nil)
        (done nil))
    (normalize tbl)
    (dolist (col (table-columns tbl))
      (push (header-name col) column-names))
    (setf column-names (reverse column-names))
    (dolist (row (table-all tbl))
      (push (make-node :data (eg-features row) :parent nil :left-child nil :right-child nil) node-list))
    (loop while (not done) do
          
