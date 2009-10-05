(defmethod print-object ((h hash-table) str)
  (format str "{hash of ~a items}" (hash-table-count h)))



(defun showh (h &key
              (indent 0) (stream t) (before "") (after "")
              (if-empty "empty")
              (show #'(lambda (x)
                        (format stream "~a~a = ~a~%"
                           (nchars indent) (first x) (rest x))))
              (lt #'lt))
 (if (zerop (hash-table-count h))
     (format stream "~a~a~a" before if-empty after)
     (let (l)
       (format stream "~a" before) 
       (maphash #'(lambda (k v) (push (cons k v) l)) h)
       (mapc show 
             (sort l #'(lambda (a b)
                         (funcall lt (car a) (car b)))))
       (format stream "~a" after)
       h)))

;; (deftest test-showh ()
;;   (let ((h (make-hash-table)))
;;     (dolist (one '(apple pear banana))
;;       (setf (gethash (length (string one)) h) one))
;;    (check
;;      (samep (with-output-to-string (s) (showh h  :stream s))
;;             "4 = PEAR
;;              5 = APPLE
;;              6 = BANANA"))))
