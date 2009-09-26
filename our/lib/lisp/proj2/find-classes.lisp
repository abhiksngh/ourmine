(defun find-classes (lst &optional (indices (list (- (length (car lst)) 1))))
  "returns the class with the highest rank among multiple classes. Classes don't have to be in the last column.
   If the list passed to this function is not a list of lists, the column number which contains the classes will
   have to be provided"
  (let* ((classes))
    (if (not (listp (car lst)))
        (dolist (ndx indices classes)
          (setf classes (cons (nth ndx lst) classes)))
        (progn
          (dolist (instance lst classes)
            (dolist (ndx indices classes)
              (setf classes (add-class (nth ndx instance) classes))))
          (if (listp classes)
              (majority classes) nil)))))
        
(defun add-class (c clist)
  "checks if class is in class-list, if it is, increment its count, else add it"
    (if (null (assoc c clist))
        (setf clist (acons c 1 clist))
        (progn
          (incf (cdr (assoc c clist)))
          clist)))

(defun majority (clist)
  "iterates over an association list and returns the car of the item whose cdr has the largest value"
  (let* ((majority-class (car (car clist)))
         (highest-rank (cdr (car clist))))
    (dolist (item clist)
      (if (> (cdr item) highest-rank)
          (progn
            (setf majority-class (car item))
            (setf highest-rank (cdr item)))))
    majority-class))
