;;;; ourmine lite
;;; bore (best or rest)

(handler-bind 
    ((style-warning #'muffle-warning))
  (mapc #'load '(
		 "tests"
		 "os"
		 "macros"
		 "strings"
		 "structs"xsl
		 "bore1"
		 )))