;Test Count: 7

;4.1 Arrays

(let ((arr nil))
  (deftest test-4-1 ()
    (setf arr (make-array '(2 3) :initial-element nil))
    (setf (aref arr 0 0) 'gus)
    (check
      (equalp (aref arr 0 0) 'gus))))

;4.3 Sort function
(let ((str "window"))
  (deftest test-4-3 ()
    (check
      (string-equal (sort str #'char<) "dinoww"))))

;4.4 Sequences

(let ((str "please"))
  (deftest test-4-4_1 ()
    (check
      (eql (position #\e str) 2)))
  (deftest test-4-4_2 ()
    (check
      (eql (position #\e str :start 3) 5)))
  (deftest test-4-4_3 ()
    (check
      (eql (find #\a str) #\a)))
  (deftest test-4-4_4 ()
    (check
      (string-equal (remove-duplicates str) "plase"))))
  

  
; Figure 4.2
; Identifying tokens

(defun tokens (str test start)
  (let ((p1 (position-if test str :start start)))
    (if p1
        (let ((p2 (position-if #'(lambda (c)
                                         (not (funcall test c)))
                               str :start p1)))
          (cons (subseq str p1 p2)
                (if p2
                    (tokens str test p2)
                    nil)))
        nil)))

(deftest test-fig-4-2 ()
  (check
   (equalp (tokens "where is bill" #'alpha-char-p 0) '("where" "is" "bill"))))

; Figure 4.5

(defstruct (node (:print-function
                  (lambda (n s d)
                    (format s "#<~A>" (node-elt n)))))
  elt (l nil) (r nil))

(defun bst-insert (obj bst <)
  (if (null bst)
      (make-node :elt obj)
      (let ((elt (node-elt bst)))
        (if (eql obj elt)
            bst
            (if (funcall < obj elt)
                (make-node
                 :elt elt
                 :l (bst-insert obj (node-l bst) <)
                 :r (node-r bst)))))))

(defun bst-find (obj bst <)
  (if (null bst)
      nil
      (let ((elt (node-elt bst)))
        (if (eql obj elt)
            bst
            (if (funcall < obj elt)
                (bst-find obj (node-l bst) <)
                (bst-find obj (node-r bst) <))))))

(defun bst-min (bst)
  (and bst
       (or (bst-min (node-l bst)) bst)))

(defun bst-max (bst)
  (and bst
       (or (bst-max (node-r bst)) bst)))
;(defun get-elt (bst)
  

(let ((nums nil))
  (dolist (x '(8000 4565 8 345678 44 88123 1234))
    (setf nums (bst-insert x nums #'<)))
  (deftest test-fig-4-5_1 ()
    (check
      (eql (bst-find 124 nums #'<) nil)))
  (deftest test-fig-4-5_2 ()
    (check
      (eql (node-elt(bst-min nums)) 1234)))
  (deftest test-fig-4-5_3 ()
    (check
      (eql (node-elt(bst-max nums)) 1234))))
                                        ; Figure 4.6