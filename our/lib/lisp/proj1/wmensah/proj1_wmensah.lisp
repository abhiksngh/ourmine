;1
(defun is-list(x)
   (listp '(a b c)))

;deftest
(deftest test-is-list()
  (check
   (is-list '(1 2 3 4))))
;run by calling (test-is-list)

;2
(defun is-null(x)
   (null nil))

;deftest
(deftest test-is-null()
  (check
   (is-null '(3 2))))
;run by calling (test-is-null)

;3
(defun our-third (x)
   (car (cdr (cdr x))))

;deftest
(deftest test-our-third(guess_val)
  (check
   (equal (our-third '(a b c d)) guess_val)))
;run by calling (test-our-third 'x), if x is the 3rd element, test returns T

;4
(defun sum-greater (x y z)
  "test whether the sum of any 2 numbers is greater than the third"
  (> (+ x y) z))

;deftest
(deftest test-sum-greater()
  (check
   (sum-greater 1 4 3)))

;run by calling (test-sum-greater)

;5
(defun our-member (obj lst)
  (if (null lst)
      nil
      (if (eql (car lst) obj)
	  lst
	  (our-member obj (cdr lst)))))

;deftest
(deftest test-our-member()
  (check
   (our-member 'b '(a b c))))

;6
(defun our-atom(x)
  (not (consp x)))

;deftest
(deftest test-our-atom()
  (check
   (our-atom '(2 3 4))))

;7 - equality
(defun is-equal()
     (eql (cons 'a nil) (cons 'a nil)))

;deftest
(deftest test-is-equal()
  (check
   (is-equal)))

;8
(defun is-equal2()
  (setf x (cons 'a nil))
  (equal x (cons 'a nil)))

;deftest
(deftest test-is-equal2()
    (check
     (is-equal2)))

;9
(defun our-equal (x y)
  (or (eql x y)
      (and (consp x)
	   (consp y)
	   (our-equal (car x) (car y))
	   (our-equal (cdr x) (cdr y)))))

;deftest
(deftest test-our-equal ()
  (check
   (our-equal '(2 3) '(2 4)))
  (check
   (our-equal '(2 3) '(2 3))))


;10
(defun compress (x)
  (if (consp x) 
      (compr (car x) 1 (cdr x))
      x))

(defun compr (elt n lst)
  (if (null lst)
      (list (n-elts elt n))
      (let ((next (car lst)))
        (if (eql next elt)
            (compr elt (+ n 1) (cdr lst))
            (cons (n-elts elt n)
                  (compr next 1 (cdr lst)))))))

(defun n-elts (elt n)
  (if (> n 1)
      (list n elt)
      elt))

;deftest
(deftest test-compress()
  (check
   (compress '(1 1 1 0 1 0 0 0 0 1))))
;run by calling (test-compress)
