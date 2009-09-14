;;; 3.1 Conses
(deftest usescons ()
(let ((l (list 'Eli 'Drew (list 'Tim 'Timm))))
  (check
     (consp l))))

;;; 3.3 Pointers 

(deftest pointers () 
  (check 
    (let* ((x '(A B)) (y '(A B)))
      (and (not (eq x y))
           (equalp x y)))))

;;; 3.4 Test List Copy

(deftest test-copy ()
  (let* ((l (list 'Eli 'Drew 'Tim))
        (m (copy-list l)))
    (setf (car l) 'Elijah)
    (check (equal (car m) 'Eli))))

;;; 3.6 Access [Required]

(deftest access ()
  (check (equalp
    'D
    (nth 3 '(A B C D E)))
  )
)


;;; 3.7 Mapping Functions [Required]

(deftest invert ()
  (check (equalp
    '(t nil t)
    (mapcar #'null '(nil t nil)))
  )
)

;;; 3.10 Add Join

(deftest testaddjoin ()
  (let ((l (list 'a 'b 'c 'd 'e)))
    (check 
      (member 'q (adjoin 'q l)))))

;;; 3.11 Subsequences

(deftest testsubseq ()
  (let* ((l (list '1 '2 '3 '4 '5))
        (m (subseq l 1 3)))
    (check (equalp m (list '2 '3)))))

;;; 3.12 Stacks [Required]

(deftest reverse2 ()
  (let ((stack nil))
    (check (equalp
      '(C B A)
      (progn 
        (push 'A stack)
        (push 'B stack)
        (push 'C stack)
        stack
      ))
    )
  )
)
