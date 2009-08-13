;;;; -*- mode: lisp; -*-

(defsystem "tests"
    :description "unit testing for LISP code. 
                  Based on Peter Seibel's code"
    :version     "0.01"
    :author      "The Mountain Lisp Gang and Tim Menzies (ed)"
    :licence     "GPL3.0"
    :components
    (
     (:file "tests/deftest")
	)
)
