;;; GenIc: 

;;; Claimee: Drew

(print " - Loading Genic") ;; Output for a pretty log

(defun new-random-center (table &optional (num-needed 1))
  (let ((newclusters nil) (num-fields (length (table-all table))))
    (dotimes (n num-needed newclusters)
      (setf newclusters (append (list (nth (random num-fields) (table-all table))) newclusters))
    )
  )
)

(defun fetch-generation (table gen-size generation)
  (let ((start (* gen-size generation)) (end (* gen-size (+ 1 generation))) (subset nil))
    (loop for n from start to end do
      (setf subset (append (list (nth n (table-all table))) subset))
    )
    subset
  )
)

(defun score-clusters (member clusters table)
  (let ((number-fields (length (eg-features member))) (scores (make-list (length clusters))))
    (dotimes (n (length clusters))
      (setf (nth n scores) 0)
      (loop for i from 0 to number-fields do
        (let ((score 0))
          (if (numeric-p (nth i (eg-features member)))
            (if (<= (nth i (eg-features member)) (nth i (eg-features (nth n clusters))))
              (setf score (/ (nth i (eg-features member)) (nth i (eg-features (nth n clusters)))))
              (setf score 
                (/ 
                  (- 
                    ;;; (Max - C)
                    (- (nth i (find-testiest-numerics table #'max))
                       (nth i (eg-features (nth n clusters)))) 
                    ;;; -(C - Value)
                    (- 
                      (nth i (eg-features member)) 
                      (nth i (eg-features (nth n clusters)))))
                  (- 
                    ;;; (Max - C)
                    (nth i (find-testiest-numerics table #'max)) 
                    (nth i (eg-features (nth n clusters))))
                )
              )
            )
            (if (equalp (nth i (eg-features member)) (nth i (eg-features (nth n clusters))))
              (setf score 1)
              (setf score 0)
            )
          )
          (setf (nth n scores) (+ score (nth n scores)))
        )        
      )
    )
    (let ((bestscore 0) (bestpos 0))
      (dotimes (n (length scores))
        (if (>= (nth n scores) bestscore)
           (setf bestpos n bestscore (nth n scores))
        )
      )
      bestpos
    )
  )
)

