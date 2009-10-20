;;EUC-DISTANCE
;;Calculates the distance between two rows of data
;;Parameters: node1, list of data. node2, list of data. columns, to know what to expect in the column
;;Returns: Number
;;Author: David Asselstine

(defun euc-distance (node1 node2 columns)
  (let ((n 0)
        (distance 0))
    (dolist (col columns)
      (if (numericp col)
          (if (numberp (nth n node1))
              (if (numberp (nth n node2))
                  (incf distance (square (- (nth n node2) (nth n node1))))
                  (incf distance (square (nth n node1))))
                (if (numberp (nth n node2))
                    (incf distance (square (nth n node2)))))
          (if (samep (nth n node1) (nth n node2))
              '(nothing)
              (incf distance)))
      (incf n))
    (sqrt distance)))

;;QSORT
;;Sorts a list of numbers smallest to largest
;;Parameters: list, list of numbers
;;Returns: the sorted list
;;Author David Asselstine

(defun qsort (list)
  (if (<= (length list) 1)
      list
      (let ((pivot (car list))
            (less-then '())
            (great-then '()))
        (dolist (n (cdr list) (append (qsort less-then) `(,pivot) (qsort great-then)))
          (if (<= n pivot)
              (push n less-then)
              (push n great-then))))))

;;NUMERIC-MEDIAN
;;Finds the median of a number list
;;Parameters: a list of numbers
;;Returns: the median
;;Author David Asselstine

(defun numeric-median (numbers)
  (if (evenp (length numbers))
      (let ((f (nth (- (/ (length numbers) 2) 1) numbers))
            (s (nth (/ (length numbers) 2) numbers)))
        (/ (+ f s) 2)) 
      (nth (floor (/ (length numbers) 2)) numbers)))

;;MOST-FREQ-SYMBOL
;;Finds the most common symbol in a list of egs
;;Parameters: A list of symbols
;;Returns the most common symbol or the first one found if equal in freq
;;Author David Asselstine

(defun most-freq-symbol (list)
  (let ((found-list '())
        (freq-found-list '()))
    (dolist (datan list freq-found-list)
      (if (member datan found-list)
          (progn
            (dotimes (i (length found-list))
              (when (samep (nth i found-list) datan)
                (incf (nth i freq-found-list)))))
          (progn
            (push datan found-list)
            (push 1 freq-found-list))))
    (let ((most-frequent 0))
      (dotimes (i (length found-list) (nth most-frequent found-list))
        (if (> (nth i freq-found-list) (nth most-frequent freq-found-list))
            (setf most-frequent i))))))

;;MAKE-MEDIAN
;;This will take two nodes and return a median of the two. Requires Normalized Numerics
;;Parameters: Node1, first list of features. Node2, second list of features. Columns, list of column headers
;;Returns: List of features
;;Author David Asselstine

(defun make-median (node1 node2 columns)
  (let ((new-features '())
        (n 0))
    (dolist (col columns)
      (if (numericp col)
          (progn
            (if (numberp (nth n node1))
                (if (numberp (nth n node2))
                    (push (numeric-median `(,(nth n node1) ,(nth n node2))) new-features)
                    (push (nth n node1) new-features))
                (push (nth n node2) new-features)))
          (push (nth n node1) new-features))
      (incf n))
    (setf new-features (reverse new-features))))
                    
