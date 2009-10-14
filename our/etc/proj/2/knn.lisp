;;Returns the euclidean distance between the numeric values in row1 and row2 from 
;;table structure tbl.  Ignores discrete columns.
(defun euclid-distance (row1 row2 tbl)
  (sqrt (reduce #'+
                (mapcar #'(lambda (v1 v2 column-header)
                          (if (and (column-header-orderedp column-header)
                                   (not (column-header-classp column-header)))
                            (expt (- v2 v1) 2)
                            0))
                        (get-row-features row1)
                        (get-row-features row2)
                        (get-table-column-headers tbl)))))

(deftest euclid-distance-test ()
  (check
    (and
      (equalp (euclid-distance (first (get-table-rows (ar3))) (first (get-table-rows (ar3))) (ar3)) 0)
      (equalp (euclid-distance (first (get-table-rows (ar3))) (second (get-table-rows (ar3))) (ar3)) 198331.9)))) 

;;Returns the k rows in tbl that are nearest to the instance row.
(defun knn (instance tbl k)
  (setf tbl (table-deep-copy tbl))
  (let ((neighbors nil)
        (distances nil))
    (dolist (row (get-table-rows tbl))
      (push (list (euclid-distance instance row tbl) row) distances))
    (setf neighbors (subseq (sort distances #'< :key #'car) 0 k))
    (mapcar #'second neighbors)))

(deftest knn-test ()
  (check
    (and
      (equalp (car (knn (car (get-table-rows (ar3))) (ar3) 1)) (car (get-table-rows (ar3))))
      (equalp (length (knn (car (get-table-rows (ar3))) (ar3) 10)) 10))))

;; this is a foo eval
;; in real world we have to use the *g* metric
(defun foo-knn-eval (samples tbl k)
  (let ((gs 0))
    (dotimes (i k gs)
      (setf gs (+ gs (reduce #'+ samples))))))

;(defun knn-eval (rowsnum tbl)
;   (let ((test (table-deep-copy tbl))
;	(test-all
;   	(last (learn (test tbl)))

(defun bestk (tbl)
  (xindex tbl)
  (let ((n (f tbl))     ; number of instances
        (samples nil)   ; random sampling
        (gs nil))
    (dotimes (i 20 samples)  			; select 20 instances
      (push (my-random-int n) samples))
    (dotimes (k (- n 1) gs)		; evaluate performance for different k
      (push (knn-eval samples tbl (+ k 1)) gs)) 
      ;(push (knn-eval samples tbl ) gs)) 
    ;; return the k-value which gave the best (max) performance
    (- n 1 (position (reduce #'max gs) gs))))	; gs is reversed

