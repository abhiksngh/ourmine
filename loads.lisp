(defun loads (&rest files)
  (handler-bind 
      ((style-warning #'muffle-warning))
    (dolist (file files)
      (format t "; ~a~%" file)
      (load file))))

(defun make-lib ()
  (loads
   "../lib/deftest"
   "../lib/os"
   "../lib/macros"
   "../lib/strings"
   ))
