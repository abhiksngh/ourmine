(defun lt (x y)
  "warning: this is the slowest possible way to compare two things"
  (if (string-lessp (format nil "~a" x) (format nil "~a" y))
      t
      nil))

(defun nchars (n &optional (char #\Space))
  (with-output-to-string (s)
    (dotimes (i n)
      (format s "~a" char ))))

(defun whiteout (seq)
  (remove-if #'whitespacep  seq))

(defun whitespacep (char)
  (member char '(#\Space #\Tab #\Newline #\Page) :test #'char=))

(defun samep (thing1 thing2)
  (string= (string-downcase (whiteout (format nil "~a" thing1)))
	   (string-downcase (whiteout (format nil "~a" thing2)))))

(deftest test-samep ()
    (check (samep "4 Score and SEVEN years
                   ago our     fore-fathers"
                  "4 score and seven years ago our fore-fathers")))
