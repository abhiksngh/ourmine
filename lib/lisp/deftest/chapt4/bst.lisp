(defstruct (node (:print-function
                  (lambda (n s d)
                    (format s "#<~A>" (node-elt n)))))
  elt (1 nil) (r nil))

(defun bst-insert (obj bst <)
  (if (null bst)
      (make-node :elt obj)
      (let ((elt (node-elt bst)))
        (if (eql obj elt)
            bst
            (if (funcall < obj elt)
                (make-node
                 :elt elt
                 :l   (bst-insert obj (node-1  bst) <)
                 :r   (node-r bst))
                (make-node
                 :elt elt
                 :r   (bst-insert obj (node-r bst) <)
                 :l   (node-1 bst)))))))

(defun bst-find (obj bst <)
  (if (null bst)
      nil
      (let ((elt (node-elt bst)))
        (if (eql obj elt)
            bst
            (if (funcall < obj elt)
                (bst-find obj (node-1 bst) <)
                (bst-find obj (node-r bst) <))))))

(defun bst-min (bst)
  (and bst
       (or (bst-min (node-1 bst)) bst)))

(defun bst-max (bst)
  (and bst
       (or (bst-max (node-r bst)) bst)))

(defun bst-remove (obj bst <)
  (if (null bst)
      nil
      (let ((elt (node-elt bst)))
        (if (eql obj elt)
            (percolate bst)
            (if (funcall < obj elt)
                (make-node
                 :elt elt
                 :l (bst-remove obj (node-1 bst) <)
                 :r (node-r bst))
                (make-node
                 :elt elt
                 :r (bst-remove obj (node-r bst) <)
                 :l (node-1 bst)))))))

(defun percolate (bst)
  (cond ((null (node-1 bst))
         (if (null (node-r bst))
             nil
             (rperc bst)))
        ((null (node-r bst)) (lperc bst))
        (t (if (zerop (random 2))
               (lperc bst)
               (rperc bst)))))

(defun rperc (bst)
  (make-node :elt (node-elt (node-r bst))
             :l (percolate (node-1 bst))
             :r (node-r bst)))
