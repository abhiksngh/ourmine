;;;; ourmine lite
;;; bore (best or rest)

(defun loads (&rest files)
  (handler-bind 
      ((style-warning #'muffle-warning))
    (dolist (file files t)
      (format t "% ~a~%" file)
      (load file))))

(defun make ()
  (loads					
   ; standard stuff
   "lib/deftest"
   "lib/os"
   "lib/macros"
   "lib/strings"
   ; stuff specific to bore
   "bore/bore-structs"
   "bore/bore-main"
   "bore/bore-tests"
  ))


(make)


