;;;; Deftest for chapter 10. Fig 10.1 10.2

;;; Testing the sorting function
(deftest test_quicksort ()
  (let* ((vec #(1 2 4 5 3))
         (vec1 (quicksort vec 0 4)) ;sorting vec
         (lst nil)) ;lst will act as accumulator
    (dotimes (x (length vec1)) ;adding the elem of the sorted vector to the list
      (setf lst (append1 lst (svref vec1 x))))
    (check (equal lst '(1 2 3 4 5)))))


;;; Testing the for function
(deftest test_for ()
  (let* ((lst nil))
    ;;calling for with a lambda function which pushes each x value into lst
    (for x 1 5 (funcall #'(lambda (x) (setf lst (push x lst))) x))
    (check (equal lst '(5 4 3 2 1)))))

;;; Testing the in function
(deftest test_in ()
  (check (and (in '+ '- '+)
              (in 3 1 2 3))))

;;; Testing the random_choice 
(deftest test_random-choice ()
  (let* ((val1 (random-choice (+ 1 2) (+ 1 3)))
         (val2 (random-choice (+ 1 2) (+ 1 3)))
         (lst (list val1 val2)))
    (check (or (member 3 lst)
               (member 4 lst)))))

;;; Testing the average function
(deftest test_avg ()
  (check (equal (avg 2 4 6) 4))) ; calc the avg of three integers

;;; Testing the gensyms variable assignment
(deftest test_with-gensyms ()
  (with-gensyms (x y z)
  (setf x 1 y 2 z 3)
  (check (equal (+ x y z) 6))))

;;; Testing the aif function
(deftest test_aif ()
  (let* ((it 2)) 
    (aif 1 (+ it 1)) ; intentional variable capture
    (check (equal 2 it))))
