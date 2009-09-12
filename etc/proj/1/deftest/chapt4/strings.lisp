(defun second-word (str)
  (let ((p1 (+ (position #\  str) 1)))
    (subseq str p1 (position #\  str :start p1))))

(deftest test-removeduplicates ()
  (check (string-equal (remove-duplicates "abracadabra") "cdbra")))

(deftest test-secondword ()
  (check (string-equal (second-word "Apple Sauce is yummy") "Sauce")))
