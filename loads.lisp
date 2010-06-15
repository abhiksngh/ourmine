(defun loads (&rest files)
  (handler-bind 
      ((style-warning #'muffle-warning))
    (dolist (file files)
      (format t "; ~a~%" file)
      (load file))))
