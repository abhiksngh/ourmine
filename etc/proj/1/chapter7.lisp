;;; 7.1 Streams [Required]

(deftest inputstream () 
  (check (equalp
    "Hello, world!"
    (read-line (open (make-pathname :name "streamtester.txt") :direction :input)))
  )
)


