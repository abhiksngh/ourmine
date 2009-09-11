;;; 10.2 Macros [Required]

(defmacro truthify (x)
  (list 'setf x T))

(deftest macro ()
  (let ((n nil))
    (truthify n)
    (check n)))

