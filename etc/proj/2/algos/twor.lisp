;;; Claimee: Tim
;; Classifiers make decisions. 

(print " - Loading TwoR") ;; Output for a pretty log


(defun mkstr (tbl)
  "Makes a structure based off of the unique classes in a dataset"
  (let ((l (justclasses tbl)))
    (progn
      (push 'classstr l)
      (push 'defstruct l))
    (eval l)))

