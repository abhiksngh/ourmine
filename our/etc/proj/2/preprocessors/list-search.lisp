; return true if the passed argument is found in the passed list
(defun list-search (class-list class-arg)
    (let ((found nil))
        (dolist (per-class class-list)
            (if (equal per-class class-arg)
                (return-from list-search t)
                () ; do nothing
            )
        )
        (and found) ; return true if found
    )
)

