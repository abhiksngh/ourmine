(defun test-data ()
  (data
   :name 'test
   :columns '($number1 symbol $number2 stuff)
   :egs '((0 TRUE 0 true)
          (0 False 0 true)
          (0 true 0 false)
          (0 false 0 false)
          (1 true 1 true)
          (1 false 1 false)
          (1 true 1 false)
          (1 false 1 true))))

(defun ekrem-c ()
  (let ((tbl (xindex (test-data))))
    (close-node '(1) (egs tbl))))

(defun close-node (row egs)
  (if (= 0 (length egs))
      '(done)
      (progn
        (close-node (row (cdr egs))))))

(defun euc-distance (node1 node2 columns)
  (let ((n 0)
        (distance 0))
    (dolist (col columns)
      (if (numericp (header-name col))
          (progn
            (if (numberp (nth n node1))
                (progn
                  (if (numberp (nth n node2))
                      (incf distance (square (- (nth n node1) (nth n node2))))
                      (incf distance (square (nth n node1)))))
                (if (numberp (nth n node2))
                    (incf distance (square (nth n node2)))))))
      (progn
        (if (samep (nth n node1) (nth n node2))
            '(nothing)
            (incf distance)))
      (incf n))
    (sqrt distance)))
