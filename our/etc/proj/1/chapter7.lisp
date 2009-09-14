; 7.1 reading and writing from a file

;create path variable
(setf path (make-pathname :name "asimpleoutput"))
;open stream to file
(setf str (open path :direction :output
:if-exists :supersede))
;write to file and close
(format str "This is output from LISP~%")
(close str)

;deftest
(deftest test-7_1 ()
	(setf aFile (make-pathname :name "asimpleoutput"))
	(setf aStream (open aFile :direction :input))
	(setf aWrd (read-line aStream))
	(check
		(equalp aWrd "This is output from LISP"))
	(close aStr))

;;7.3 output using format functions
(deftest test-7_3 ()
		(check
			(equal (format nil "~,2F" 26.123456789) "26.12")))


