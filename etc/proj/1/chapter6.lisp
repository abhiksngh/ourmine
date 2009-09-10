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
