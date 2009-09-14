;;; 4.2 Binary Search [Required]

(defun binsearch (item vector &optional (start 0) (end (length vector)))
  (let ((pivot (round (/ (+ start end) 2))))
    (if (and (listp vector) (> (length vector) 0))
      (if (equalp item (nth pivot vector))
        pivot
        (if (not (zerop (- start end)))
          (if (> item (nth pivot vector))
            (binsearch item vector pivot end)
            (binsearch item vector start pivot)
          )
          nil
        )
      )
      nil
    )
  )
)

(deftest testbinsearch ()
  (check (equalp
    2
    (binsearch 3 '(1 2 3 4 5 6 7 8)))))

;;; 4.5 Parsing Based on Test[Required]
(deftest tokenremoval ()
  (defun removenonalpha (str test start)
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

  (check
     (equal (removenonalpha "eli123abc..d" 
		#'alpha-char-p 0) 
		'("eli" "abc" "d"))))

;;; 4.6 Structures [Required]
(defstruct item
  price
  name)

(deftest test-structure ()
   (setf p (make-item :price 5 :name "Chicken"))
   (check
    (equal (item-price) 5)))
