;;; 3.6 Access [Required]

(deftest access ()
  (check (equalp
    'D
    (nth 3 '(A B C D E)))
  )
)


;;; 3.7 Mapping Functions [Required]

(deftest invert ()
  (check (equalp
    '(t nil t)
    (mapcar #'null '(nil t nil)))
  )
)

;;; 3.12 Stacks [Required]

(deftest reverse2 ()
  (let ((stack nil))
    (check (equalp
      '(C B A)
      (progn 
        (push 'A stack)
        (push 'B stack)
        (push 'C stack)
        stack
      ))
    )
  )
)
