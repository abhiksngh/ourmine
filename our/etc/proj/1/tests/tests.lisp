;; Chapter 4 Tests
;; Figure 4.2
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

(defun constituent (c)
  (and (graphic-char-p c)
       (not (char= c #\ ))))

(deftest tokens-test ()
  (check (and 
    (equalp 
      (tokens "aaBBBcDDD" #'upper-case-p 0)
      '("BBB" "DDD"))
    (equalp
      (tokens "aaBBBcDDD" #'lower-case-p 0)
      '("aa" "c")) 
    (equalp
      (tokens "aaaa   bbbb cccc.dddd eeee f123" #'alphanumericp 0)
      '("aaaa" "bbbb" "cccc" "dddd" "eeee" "f123")))))

(deftest constituent-test ()
  (check (and
    (constituent #\a)
    (not (constituent #\ ))
    (constituent #\A)
    (constituent #\$)
    (constituent #\1))))

;; Figure 4.5
(defstruct (node (:print-function
                  (lambda (n s d)
                    (declare (ignore d))
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
                  :l   (bst-insert obj (node-l bst) <)
                  :r   (node-r bst))
                (make-node
                  :elt elt
                  :r   (bst-insert obj (node-r bst) <)
                  :l   (node-l bst)))))))

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

(deftest bst-test ()
  (let (bst)
    (dolist (i '(1 2 3 4 5 6 7 8 9 10))
      (setf bst (bst-insert i bst #'<)))
    (check (and
      (equalp 
        (node-elt (bst-min bst))
        1)
    (setf bst (bst-insert 0 bst #'<))
      (equalp 
        (node-elt (bst-min bst))
        0)
      (equalp 
        (node-elt (bst-max bst))
        10)
    (setf bst (bst-insert 11 bst #'<))
      (equalp 
        (node-elt (bst-max bst))
        11)
      (equalp
        (node-elt (bst-find 5 bst #'<))
        5)
      (equalp
        (bst-find 12 bst #'<)
        nil)))))

;;Figure 4.6
(defun bst-remove-min (bst)
  (if (null (node-l bst))  
      (node-r bst)
      (make-node :elt (node-elt bst)
                 :l   (bst-remove-min (node-l bst))
                 :r   (node-r bst))))

(defun bst-remove-max (bst)
  (if (null (node-r bst)) 
      (node-l bst)
      (make-node :elt (node-elt bst)
                 :l (node-l bst)
                 :r (bst-remove-max (node-r bst)))))


(defun percolate (bst)
  (let ((l (node-l bst)) (r (node-r bst)))
    (cond ((null l) r)
          ((null r) l)
          (t (if (zerop (random 2))
                 (make-node :elt (node-elt (bst-max l))
                            :r r
                            :l (bst-remove-max l))
                 (make-node :elt (node-elt (bst-min r))
                            :r (bst-remove-min r)
                            :l l)))))) 

(defun bst-remove (obj bst <)
  (if (null bst)
      nil
      (let ((elt (node-elt bst)))
        (if (eql obj elt)
            (percolate bst)
            (if (funcall < obj elt)
                (make-node
                  :elt elt
                  :l (bst-remove obj (node-l bst) <)
                  :r (node-r bst))
                (make-node
                  :elt elt
                  :r (bst-remove obj (node-r bst) <)
                  :l (node-l bst)))))))


(deftest bst-remove-test ()
  (let (bst)
    (dolist (i '(1 2 3 4 5 6 7 8 9 10))
      (setf bst (bst-insert i bst #'<)))
    (check (and 
      (equalp
        (node-elt (bst-find 5 bst #'<))
        5)
    (setf bst (bst-remove 5 bst #'<))
      (equalp
        (bst-find 5 bst #'<)
        nil)
      (equalp
        (node-elt (bst-max bst))
        10)
    (setf bst (bst-remove 10 bst #'<))
      (equalp
        (node-elt (bst-max bst))
        9)))))

(deftest vector-test ()
  (let ((vec (vector 1 2 3 4 5 6 7 8 9 10)))
      (check (and
        (equalp
          (svref vec 0)
          1)
        (equalp
          (svref vec 9)
          10)
      (setf (svref vec 9) 0)
        (equalp
          (svref vec 9)
          0)))))

(deftest string-test ()
  (check (and
    (not (equal
          "abc"
          "ABC"))
    (string-equal
      "abc"
      "ABC")
    (char=
      (aref "abc" 0)
      (char "abc" 0)
      #\a))))

(deftest elt-test ()
  (check (and
    (equalp
      (elt '(a b c) 0)
      'a)
    (equalp
      (elt "abc" 0)
      #\a)
    (equalp
      (elt (vector 'a 'b 'c) 0)
      'a))))

(defstruct point x y)
(deftest struct-test ()
  (let ((p (make-point :x 4 :y 2)))
    (check (and
      (equalp 
        (point-x p)
        4)
      (equalp 
        (point-y p)
        2)
    (setf (point-x p) 6)
    (setf (point-y p) 9)
      (equalp 
        (point-x p)
        6)
      (equalp 
        (point-y p)
        9)))))

(deftest ht-test ()
  (let ((ht (make-hash-table)))
    (check (and
      (equalp
        (gethash 'a ht)
        nil)
    (setf (gethash 'a ht) 1)
      (equalp
        (gethash 'a ht)
        1)
    (remhash 'a ht)
      (equalp
        (gethash 'a ht)
        nil)))))

(deftest reduce-test ()
  (check
    (=
      (reduce #'+ '(1 2 3 4 5))
      (+ 1 2 3 4 5)
      15)))

;; Chapter 5 Tests
;; Figure 5.2
(defparameter month
  #(0 31 59 90 120 151 181 212 243 273 304 334 365))

(defconstant yzero 2000)

(defun leap? (y)
  (and (zerop (mod y 4))
       (or (zerop (mod y 400))
           (not (zerop (mod y 100))))))

(defun year-days (y) (if (leap? y) 366 365))

(defun month-num (m y)
  (+ (svref month (- m 1))
     (if (and (> m 2) (leap? y)) 1 0)))

(defun year-num (y)
  (let ((d 0))
    (if (>= y yzero)
        (dotimes (i (- y yzero) d)
          (incf d (year-days (+ yzero i))))
        (dotimes (i (- yzero y) (- d))
          (incf d (year-days (+ y i)))))))

(defun date->num (d m y)
  (+ (- d 1) (month-num m y) (year-num y)))

(defun num-year (n)
  (if (< n 0)
      (do* ((y (- yzero 1) (- y 1))
            (d (- (year-days y)) (- d (year-days y))))
           ((<= d n) (values y (- n d))))
      (do* ((y yzero (+ y 1))
            (prev 0 d)
            (d (year-days y) (+ d (year-days y))))
           ((> d n) (values y (- n prev))))))

(defun nmon (n)
  (let ((m (position n month :test #'<)))
    (values m (+ 1 (- n (svref month (- m 1)))))))

(defun num-month (n y)
  (if (leap? y)
      (cond ((= n 59) (values 2 29))
            ((> n 59) (nmon (- n 1)))
            (t        (nmon n)))
      (nmon n)))


(defun num->date (n)
  (multiple-value-bind (y left) (num-year n)
    (multiple-value-bind (m d) (num-month left y)
      (values d m y))))


(defun date+ (d m y n)
  (num->date (+ (date->num d m y) n)))

(deftest num->date-test ()
  (check (and
    (equalp
      (multiple-value-list (date+ 7 9 2009 10))
      '(17 9 2009))
    (equalp
      (multiple-value-list (num->date 0))
      '(1 1 2000))
    (equalp
      (date+ 7 9 2009 21)
      (num->date (+ (date->num 7 9 2009) 21)))
    (=
      (num-year 400)
      2001))))

;; Figure 6.1
(defun single? (lst)
  (and (consp lst) (null (cdr lst))))

(defun append1 (lst obj)
  (append lst (list obj)))

(defun map-int (fn n)
  (let ((acc nil))
    (dotimes (i n)
      (push (funcall fn i) acc))
    (nreverse acc)))

(defun filter (fn lst)
  (let ((acc nil))
    (dolist (x lst)
      (let ((val (funcall fn x)))
        (if val (push val acc))))
    (nreverse acc)))

(defun most (fn lst)
  (if (null lst)
      (values nil nil)
      (let* ((wins (car lst))
             (max (funcall fn wins)))
        (dolist (obj (cdr lst))
          (let ((score (funcall fn obj)))
            (when (> score max)
              (setf wins obj
                    max  score))))
        (values wins max))))

(deftest util-test ()
  (check (and
    (single? '(a))
    (not (single? '(a b)))
    (not (single? 'a))
    (equalp
      (append1 '(a b c) 'd)
      '(a b c d))
    (equalp
      (map-int #'(lambda (i) (* i 5)) 10)
      '(0 5 10 15 20 25 30 35 40 45))
    (equalp
      (filter #'(lambda (i) (and (oddp i) i)) '(1 2 3 4 5 6 7 8 9 10))
      '(1 3 5 7 9))
    (=
      (most #'identity '(1 2 3 4 5 6 7 8 9 10))
      10))))

;; Chapter 6.1 Tests
(deftest global-fn-test ()
  (check (and
    (fboundp '+)
    (not (fboundp 'not-a-function))
    (equalp
      (symbol-function '+)
      #'+))))

;; Chapter 6.2 Tests
(deftest local-fn-test ()
  (check
    (labels ((new-car (lst) (car lst)))
      (equalp
        (new-car '(a b c))
        (car '(a b c))))))

;; Chapter 10.1 Tests
(deftest eval-test ()
  (check (and
    (equalp
      (eval '(car (list 'a 'b 'c)))
      (car (list 'a 'b 'c)))
    (=
      (eval (+ 1 2 3))
      (+ 1 2 3)
      6))))

;; Chapter 10.2 Tests
(defmacro multiply10 (i)
  (list '* i 10))
(deftest macro-test ()
  (check
    (= 
      (multiply10 5)
      (* 10 5)
      50)))

;; Chapter 10.3 Tests
(deftest backquote-test ()
  (check (and
    (equalp
      `(1 2 3 ,(+ 2 2))
      '(1 2 3 4)))
    (equalp
      `(1 ,@(list 2 3 4))
      '(1 2 3 4))))

(defun run-tests ()
  (tokens-test)
  (constituent-test)
  (bst-test)
  (bst-remove-test)
  (vector-test)
  (string-test)
  (elt-test)
  (struct-test)
  (ht-test)
  (reduce-test)
  (num->date-test)
  (util-test)
  (global-fn-test)
  (local-fn-test)
  (eval-test)
  (macro-test)
  (backquote-test))