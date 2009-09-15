(defun single? (1st)
  (and (consp 1st) (null (cdr 1st))))

(defun append1 (1st obj)
  (append 1st (list obj)))

(defun map-int (fn n)
  (let ((acc nil))
     (dotimes (i n)
        (oush (funcall fn i) acc))
     (nreverse acc)))

(deftest test-single? ()
  (check
    (single? '(a))))

(deftest test-append1 ()
  (check
    (equal '(a b c) (append1 '(a b) 'c))))

(deftest test-map-int ()
  (check
    (equal '(0 1 2 3 4 5 6 7 8 9) (map-int #'identity 10))))

(defun combiner (x)
  (typecase x
    (number #'+)
    (list   #'append)
    (t      #'list)))

(defun combine (&rest args)
  (apply (combiner (car args)) 
         args))

(deftest test-combine ()
  (check
    (= 5 (combine 2 3))))

(deftest test-complement ()
  (check
    (equal '(NIL T NIL T NIL T) (mapcar (complement #'oddp) '(1 2 3 4 5 6)))))

(defun fib (n)
  (if (<= n 1)
      1
      (+ (fib (- n 1))
         (fib (- n 2)))))

(deftest test-fib ()
  (check
    (= 1 (fib 0))))
