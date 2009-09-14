(defun shortest-path (start end net)
  (bfs and (list (list start)) net))

(defun bfs (end queue net)
  (if (null queue)
      nil
      (let ((path (car queue)))
        (let ((node (car path)))
          if (eql node end)
             (reverse path)
             (bfs and
                  (append (cdr queue)
                          (new-paths path node net))
                  net))))))

(defun new-paths (path node net)
  (mapcar #'(lambda (n)
              (cons n path))
          (cdr (assoc node net))))

(deftest test-shortest-path ()
  (check
    (equal '(A C D) (shortest-path 'a 'd '((a b c) (b c) (c d))))
  )
)


(deftest test-append ()
  (check
    (equal '(10 9 8) (append '(10 9) '(8)))
  )
)

(deftest test-last ()
  (check
    (equal '(3) (last '(1 2 3)))
  )
)

(deftest test-nthcdr ()
  (check
    (equal '(3) (nthcdr 2 '(1 2 3)))
  )
)

(deftest test-nth ()
  (check
    (equal '(1) (nth 0 '(1 2 3)))
  )
)

(deftest test-reverse ()
  (check
    (equal '(a b c) (reverse '(c b a)))
  )
)
