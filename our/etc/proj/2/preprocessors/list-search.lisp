; return true if the passed argument is found in the passed list
(defun list-search (lst item)
    (let ((found nil))
        (dolist (per-item lst)
            (if (equal per-item item)
                (return-from list-search t)
                () ; do nothing
            )
        )
        (and found) ; return true if found
    )
)

(deftest test-search ()
    (check
        (and (list-search (list 1 2 3 4) 2)
             (not (list-search (list 1 2 3 4) 5)))
    ) 
)
