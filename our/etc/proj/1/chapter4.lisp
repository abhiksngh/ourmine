(deftest test-make-array ()
  (check
    (let ((array (make-array 4 :initial-element 0)))
      (and (= 0 (aref array 0))
           (= 0 (aref array 1))
           (= 0 (aref array 2))
           (= 0 (aref array 3))))))

(deftest test-vector ()
  (check
    (let ((array (vector 1 2 3 4 5)))
      (and (= 1 (aref array 0))
           (= 2 (aref array 1))
           (= 3 (aref array 2))
           (= 4 (aref array 3))
           (= 5 (aref array 4))))))

(deftest test-char-code ()
  (check
    (and (= 97 (char-code #\a))
         (= 65 (char-code #\A)))))

(deftest test-char< ()
  (check
    (char< #\A #\a)))
         

(deftest test-char= ()
  (check
     (char= #\A #\A)))
          

(deftest test-char ()
  (check
     (equal (char "abc" 1) #\b)
     (equal (char "def" 2) #\f)))
    

(deftest test-concatenate ()
  (check
     (equal (concatenate 'string "Hello " "World!") "Hello World!")))

(deftest test-elt ()
  (check
    (equal (elt '(a b c d) 2) 'c)))

(deftest test-position ()
  (check
    (equal (position #\o "Hello World!") 4)))
