;;; 6.1 Global Functions [Required]

(defun negativate (n)
  "Takes an integer and performs a permutation upon it to mirror it's value across the integer spectrum."
  (* n -1))

(deftest global () 
  (check (equalp
    -8
    (negativate 8))
  )
)

;;; 6.3 Parameter Lists

(defun makelist (x &rest args)
  (list x args))

(deftest paramlists ()
  (check (equalp
    '(A (B C))
    (makelist 'A 'B 'C))))

;;; 6.4 6.5 6.9
