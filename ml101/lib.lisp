(defun appendl (a b) (append a (list b)))

(defun lt (x y)
  (string< (format nil "~a" x) (format nil "~a" y)))

(defun nchars (n &optional (char #\Space))
  (with-output-to-string (s)
    (dotimes (i n)
      (format s "~a" char))))
