;;; Searching a vector (sorted list) - pg60

(defun bin-search (obj vec)
  (let ((len (length vec)))
    (and (not (zerop len))
	 (finder obj vec 0 (- len 1)))))

(defun finder (obj vec start end)
  (let ((range (- end start))) ; range is the number of elements in the vector
    (if (zerop range)   ; if range is 0 then ...
	(if (eql obj (aref vec start)) ; if obj is the first element then...
	    obj ; return obj
	    nil) ; else return nil
	(let ((mid (+ start (round (/ range 2))))) ; mid = start + (round (range/2))
	  (let ((obj2 (aref vec mid))) ; obj2 = the middle element in the range
	    (if (< obj obj2) ; if obj < obj2 then...
		(finder obj vec start (- mid 1)) ; call finder and have it search from start to (mid - 1)
		(if (> obj obj2) ; if obj > obj2 then ...
		    (finder obj vec (+ mid 1) end) ; call finder and have it search from (mid + 1) to end
		    obj))))))) ; return obj

(deftest test-bin-search ()
  (check
    (bin-search 3 #(0 1 2 3 4 5 6 7 8 9))))


;;; sort a string of characters. The function char< takes care of this.
(deftest test-sort()
  (check
    (sort "elbow" #'char<)))


;;; replace elements in a string
(deftest test-copy-seq ()
  (let ((str (copy-seq "Merlin")))
    (check
      (setf (char str 3) #\k)
      str)))

;;; testing for equal strings
(deftest test-string-equal()
  (let ((str1 "fred") (str2 "Fred"))
    (check
      (string-equal str1 str2))))


;;; string concatenation
(deftest test-concatenate()
  (let ((str1 "not") (str2 "worry"))
    (check
      (concatenate 'string str1 str2))))

;;; mirror function
(defun mirror? (s)
  (let ((len (length s))) ;len = length of s
    (and (evenp len) ; if the length is even... (can't have palindromes with odd length)
	 (do ((forward 0 (+ forward 1)) 
	      (back (- len 1) (- back 1)))
	     ((or (> forward back) ; if the 2 pointers have crossed paths, ie. forward > back
		  (not (eql (elt s forward) ; or the element at forward position != element at back position
			    (elt s back))))
	      (> forward back)))))) ; nil is returned if either one of these conditions is satisfied
; otherwise if the loop ends and none of the given conditions is met, then true is returned.

(deftest test-mirror()
  (check
    (mirror? "abba")))


;; position function
(deftest test-position()
  (check
    (position 'a '((c d) (a b)) :key #'car))) ; position of the first element whose car is the symbol a

;; note:
;; from-end arguement starts searching for a match from the end of the input.
;; so (position #\a "fantasia" :from-end t) outputs 7

;; second word
(defun second-word (str)
  (let ((p1 (+ (position #\  str) 1)))
    (subseq str p1 (position #\  str :start p1))))

(deftest test-second-word()
  (let ((myword "follows"))
    (check
      (string-equal (second-word "Form follows function.") myword))))

;; position-if - takes a function and a sequence, and returns the position of the first element satisfying the function
(deftest test-position-if()
  (check
    (position-if #'oddp '(2 3 4 5))))
  


;; Identifying Tokens
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

(deftest test-tokens()
  (check
    (tokens "ab12 3cde.f" #'alpha-char-p 0)))

(defun parse-date (str)
  (let ((toks (tokens str #'constituent 0)))
    (list (parse-integer (first toks))
	  (parse-month (second toks))
	  (parse-integer (third toks)))))

(defconstant month-names
  #("jan" "feb" "mar" "apr" "may" "jun"
    "jul" "aug" "sep" "oct" "nov" "dec"))

(defun parse-month (str)
  (let ((p (position str month-names
		     :test #'string-equal)))
    (if p
	(+ p 1)
	nil)))

(deftest test-parse-date()
  (check
    (parse-date "03 Sep 2009")))
