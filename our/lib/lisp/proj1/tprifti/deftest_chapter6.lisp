;;;; Deftest for chapter 3. Including figure 6.1

;;; Testing the single? utility. Fig 6.1
(deftest test_single? ()
  ;;build a cons of one element
  (let* ((lst (cons 1 nil)))
    (check (single? lst))))

;;; Testing the append1 utility.
(deftest test_append1()
  (let* ((lst nil))
    ;;Local function. Build a list of 3 elements
    (labels ((append_key (&key (x 1) (y 2) (z 3))
               (list x y z)))
      ;;append each element of list to lst
      (dolist (obj (append_key))
        (setf lst (append1 lst obj))))
    (check (equal lst '(1 2 3)))))

;;; Testing the map_int utility.
(deftest test_map-int()
  ;;create a list of 5 int by calling the map_int function
  (let* ((lst (map-int #'(lambda (x) (+ x 100)) 5)))
    (check (equal '(100 101 102 103 104) lst))))
             

;;; Testing the filter function
(deftest test_filter ()
  ;;create a list which contains some list elements inside
  (let* (( lst '(1 (2) (1 2) 3 4))
         ;;create a new list by checking how many list elements are in the above list
         ( lst1 (filter #'(lambda (x) (listp x)) lst)))
    (check (equal lst1 '(T T)))))

;;; Testing most utility
(deftest test_most ()
  (let* ((lst nil))
    ;; checking a list for the longest list element
    ;; the longest element and the length is returned 
    (multiple-value-bind (elm score) (most #'length '((1) (1 2) (1 2 3)))
      (setf lst (list elm score)))
    (check (equal '((1 2 3) 3) lst))))
                          
