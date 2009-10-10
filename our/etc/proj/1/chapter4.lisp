(defstruct (node (:print-function
                  (lambda (n s d)
                    (format s "#<~S>" (node-elt n)))))
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
                 :l   (bst-insert obj (node-l  bst) <)
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

(defun percolate (bst)
  (cond ((null (node-l bst))
      (if (null (node-r bst))
          nil
          (rperc bst)))
      ((null (node-r bst)) (lperc bst))
      (t (if (zerop (random 2))
            (lperc bst)
	    (rperc bst)))))

(defun rperc (bst)
      (make-node :elt (node-elt (node-r bst))
                 :l (node-l bst)
                 :r (percolate (node-r bst))))

(defun lperc (bst)
      (make-node :elt (node-elt (node-l bst))
                 :l   (percolate (node-l bst))
                 :r   (node-r bst)))

(defun Make-Test-Tree ()
  (let ((nums))
    (dolist (x '(5 8 4 2 1 9 6 7 3) nums)
       (setf nums (bst-insert x nums #'<)))))

(deftest test-bst-remove ()
  (let ((tree (Make-Test-Tree)))
      (check 
        (equal (bst-find 2 tree #'<) (bst-remove 2 tree #'<)))))

(defun parse-date (str)
  (let ((toks (tokens str #'constituent 0)))
    (list (parse-integer (first toks))
          (parse-month (second toks))
          (parse-integer (third toks)))))

(defvar month-names
  #("jan" "feb" "mar" "apr" "may" "jun"
    "jul" "aug" "sep" "oct" "nov" "dec"))

(defun parse-month (str)
  (let ((p (position str month-names :test #'string-equal)))
    (if p
        (+ p 1)
        nil)))

(deftest test-parsemonth ()
  (check 
     (equal '(16 8 1980) (parse-date "16 Aug 1980"))))

(deftest test-string-equal ()
  (check
    (string-equal "tom" "tom")))

(deftest test-equal-string ()
  (check
    (equal "tim" "tim")))

(deftest test-svref ()
  (let ((v (vector 14 15 16)))
    (check (= 14 (svref v 0)))))

; MP
; Fig. 4.2 (2 tests)
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
       (not (char= c #\  ))))

(deftest test-tokens ()
  (check
;   (equal '("123" "456" "789") (tokens "123abc456*&^789." #'numberp 0))))
   (equal '("abc" "d" "ef") (tokens "123abc4$32d9898ef." #'alpha-char-p 0))))

(deftest test-constituent ()
  (check
   (equal T (constituent #\d))))

; Fig 4.8 (1 test)
(defun bst-traverse (fn bst)
  (when bst
    (bst-traverse fn (node-l bst))
    (funcall fn (node-elt bst))
    (bst-traverse fn (node-r bst))))

;(deftest test-bst-traverse ()
;  (check
;   (let ((tree (Make-Test-Tree)))
