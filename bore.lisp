;;;; ourmine lite
;;; bore (best or rest)

(handler-bind 
    ((style-warning #'muffle-warning))
  (mapc #'load '(
  		; standard stuff
		 "lib/deftests"
		 "lib/os"
		 "lib/macros"
		 "lib/strings"
		 "lib/structs"
		 ; stuff specific to bore
		 "bore/bore-structs"
		 "bore/bore-main"
		 "bore/bore-tests"
		 )))



