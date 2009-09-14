(defun enigma (x)
  (and (not (null x))
       (or (null (car x))
           (enigma (cdr x)))))

#|(deftest test-enigma10a()
  (let ((x '(a b nil c d nil)))
    (dotimes (i (- (length x) 1))
      (pop x)
;      (print x)
      (check
        (enigma x)
        ))))
  |#

(deftest test-enigma()
  (check
    (enigma '(nil 3 4 5))
    (enigma '(nil))
    (not (enigma '(3 4 5)))
    (enigma '( 3 4 5 nil))))

  
(deftest test-remove()
    (let ((lst '(c a r a t)))
      (let ((x (remove 'a lst)))
        (check 
          (equal lst '(c a r a t))
          (samep x '(c r t))))))

(defun length10 (lst)
  (if (null lst) 0
      (+ 1 (length10 (cdr lst)))))


(deftest test-length()
  (check
    (equal (length10 '(1 2 3 4 5 6 nil)) 7)
    (equal (length10 '(nil)) 1)
    (equal (length10 '()) 0)))

#|(defun idots (x)
  (if (> x 0)
      (do ((i 0 (+ 1 i)))
          ((equal i x) 'done)
        (format t "."))))

(defun rdots (x)
  (if (> x 0)
      (progn
        (format t ".")
        (rdots (- x 1)))))


(deftest test-rdots()
  (let ((x (rdots 0)))
    (print x)
    (check
       (samep x "NIL"))))
|#

(deftest test-fcall()
  (check
    (samep (apply #'+ 1 '(3 7)) 11)
    (samep (funcall #'+ 3 7 1) 11)))

(deftest test-dolist()
  (let ((n 0))
    (dolist (s '(1 2 3 4 5))
      (setf n (+ s n)))
    (check
      (equal n 15))))

; global n
(defparameter n 1)

(deftest test-local()
  (let ((n '(a b c)))
    (check
      (equal n '(a b c))))
  (check
    (equal n 1)))

(deftest test-or()
  (check
    (or 13 nil)))

(deftest test-and()
  (check
    (not (and nil 1))))

(deftest test-quote()
  (check
    (samep (quote (aha)) '(aha))))

(defun tests10()
  (test-enigma)
  (test-remove)
  (test-length)
  (test-fcall)
  (test-dolist)
  (test-local)
  (test-format)
  (test-or)
  (test-and)
  (test-quote)
  )

