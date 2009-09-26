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


(defun get-col (clist colnum)
  "goes through a table, creates a list out of each element in the rows and returns the list"
  (let* ((col-list))
    (dolist (item clist)
      (setf col-list (cons (nth colnum item) col-list)))
    col-list))


(defun get-all-cols (clist cols)
  (let* ((allcols))
    (dolist (i cols allcols)
      (setf allcols (cons (get-col clist i) allcols)))))


(defun find-majority (lst)
  (let* ((classes))
    (dolist (item lst)
      (setf classes (add-class (nth (position item lst) lst) classes)))
    (if (listp classes)
        (majority classes) nil)))


(defun find-classes (data indices)
  (let* ((result-classes))
    (if (not (listp (car data)))
        (dolist (i indices (reverse result-classes))
          (setf result-classes (cons (nth i data) result-classes)))
        (progn
          (let* ((c-list (get-all-cols data indices)))
            (dolist (item c-list result-classes)
              (setf result-classes (cons (find-majority item) result-classes))))))))
    
