;;;; Deftests for chapter 2

;;; Testing the evaluation 
(deftest test_eval ()
  (check (equal (+ 1 3) (/ (* 2 4) 2))))

;;; Testing the list function
(deftest test_list ()
  (check (equal
          ;;a list is constructed using the list function
          (list (and (listp 3) t) (+ 1 3))
          '(nil 4))))

;;; Testing a if a list contains list elements
(deftest test_list1 ()
  (let* ((lst '(1 2 '(2 3) 4)))
    ;; local function to test for list elements 
    (labels ((listElem (x) (and (not (null x))
                                (or (listp (car x))
                                    (listElem (cdr x))))))
      (check (listElem lst)))))
                            

;;; Testing the cons function
(deftest test_cons ()
  (check (equal (cons '(1 2) '(3 4 5)) (list '(1 2) 3 4 5))))

;;; Testing the lambda function
(deftest test_lambda ()
  (check (equal (list 1 4 9)
                ;;appling the square function to the elements of the list
                (mapcar #'(lambda (x) (* x x)) (list 1 2 3)))))

;;;; Testing the apply function
(deftest test_apply ()
  (let ((a 1)
        (b 2)
        (c 3))
    (check (equal (+ a b c)
                  (apply #'+ '(1 2 3))))))
;;;; Testing the setf function
(deftest test_assignment ()
  (let* ((lst (list nil 2 3 4)))
    ;;setting the first element of the list equal to the sum of the rest of elements
    (funcall #'(lambda (x) (setf  (car x) (apply #'+ (cdr lst))))
             lst)
    (check (equal (car lst) 9))))

;;;; Testing the setf function
(deftest test_assignment1 ()
  (let* ((lst '(a b b b )))
    ;; remove the first element of the lst
    (setf lst (remove (car lst) lst))
    (check (equal lst '(b b b)))))

;;;; Testing the do function (iteration)
(deftest test_do()
  (let* ((start 1)
         (end 5)
         (lst nil))
    (do ((i start (+ i 1)))
        ((> i end) )
      ;;building a list containing as elements the squares of i
      (setf lst (cons (* i i) lst)))
    (check (equal (reverse lst) '(1 4 9 16 25)))))

;;;; Testing the local functions
(deftest test_functions ()
  ;;declaring a function that increases by 1 each element of a list
  (labels ((list_incf (lst)
             (if (listp lst)
                 (mapcar #'(lambda (x) (+ x 1)) lst)
                 nil)
             ))
    (check (equal (list_incf '(1 2 3 4)) '(2 3 4 5)))))
