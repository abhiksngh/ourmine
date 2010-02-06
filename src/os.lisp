(defun cat (file)
  (with-open-file (str file :direction :input)
    (do ((line (read-line str nil 'eof)
	       (read-line str nil 'eof)))
	((eql line 'eof))
      (format t "~A~%" line))))

(defun file->lists (f)
  (with-open-file (str f) 
    (stream->list  str)))

(defun stream->list (str &optional 
                     (line (read-line str nil)))
  (when line
    (cons (string->list line)
	  (stream->list str))))

(defun string->list (line)
  (read-from-string
   (concatenate 'string "(" (reverse line) ")")))

