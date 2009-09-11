;;; 14.2 Binary Streams [Required]

;;; 14.5 Loop

(deftest loop10 () 
  (check (equalp
    123456789
    (let ((x 0))
      (loop for n from 1 to 9 do
        (setf x (+ n (* x 10))))
      x))))

