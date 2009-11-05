;; 2b
;; Pre-Processor to Naive Bayes.
;;; Shaggy
;; Requires twor.lisp and naivebayes.lisp be loaded.
;; The pair-table macro returns an xindex'd table of all the rows paired.

(print " - Loading 2b") ;; Output for a pretty log

(defun 2b (tbl)
  (naivebayes (pair-table tbl) (pair-table tbl)))
