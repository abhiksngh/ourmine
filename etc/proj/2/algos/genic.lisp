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

(defun genic-clusters (table &optional (generation-size 4) (num-clusters 3))
  (let ((generation nil) (clusters nil) (clusters-weight (make-list num-clusters)) 
       (generations (floor (/ (length (table-all table)) generation-size))))
    (setf clusters (new-random-center table num-clusters))
    (fill clusters-weight 0)
    (loop for i from 0 to (- generations 2) do
      (setf generation (fetch-generation table generation-size i))
      (loop for j from 0 to (- generation-size 1) do
        (let ((sample (nth j generation)))
          (let ((best-cluster (score-clusters sample clusters table)))
            (setf (nth best-cluster clusters-weight) (+ 1 (nth best-cluster clusters-weight)))
          )
        )
      )
      (let ((worst-score generation-size) (worst-position nil))
        (loop for k from 0 to (- (length clusters-weight) 1) do
          (if (or
                (and (null worst-score) (null worst-position))
                (<= (nth k clusters-weight) worst-score))
            (setf worst-score (nth k clusters-weight) worst-position k)
          )
        )
        (setf (nth worst-position clusters) (first (new-random-center table)))
      )
      (fill clusters-weight 0)
    )
    clusters
  )
)

(defun genic2-clusters (table &optional (generation-size 4) (num-clusters 10))
  (let ((generation nil) (clusters nil) (clusters-weight (make-list num-clusters)) 
       (generations (floor (/ (length (table-all table)) generation-size))))
    (setf clusters (new-random-center table num-clusters))
    (fill clusters-weight 0)
    (loop for i from 0 to (- generations 2) do
      (setf generation (fetch-generation table generation-size i))
      (loop for j from 0 to (- generation-size 1) do
        (let ((sample (nth j generation)))
          (let ((best-cluster (score-clusters sample clusters table)))
            (setf (nth best-cluster clusters-weight) (+ 1 (nth best-cluster clusters-weight)))
          )
        )
      )
      (let ((best-score (first (sort (copy-list clusters-weight) #'>))) (expand-clusters t))
        (loop for k from 0 to (- (length clusters-weight) 1) do
          (if (<= (nth k clusters-weight) (/ best-score 2))
            (setf (nth k clusters) (first (new-random-center table)) expand-clusters nil)
          )
        )
        (if expand-clusters
          (let ((to-add (floor (* (length clusters) 0.5))))
            (setf 
              clusters-weight (append clusters-weight (make-list to-add))
              clusters (append clusters (new-random-center table to-add))
            )
          )
        )
      )
      (fill clusters-weight 0)
    )
    clusters
  )
)

(defun genic (table &optional (generation-size 4) (num-clusters 3))
  (let* ((clusters (genic-clusters table generation-size num-clusters)) (clustered-tables (make-list (length clusters))))
    (loop for n from 0 to (- num-clusters 1) do
      (setf 
        (nth n clustered-tables) (make-table)
        (table-name (nth n clustered-tables)) (table-name table)
        (table-columns (nth n clustered-tables)) (table-columns table)
        (table-class (nth n clustered-tables)) (table-class table)
        (table-cautions (nth n clustered-tables)) (table-cautions table)
        (table-indexed (nth n clustered-tables)) (table-indexed table)
      )
    )
    (dolist (x (table-all table) clustered-tables)
      (let ((target-table (score-clusters x clusters table)))
        (setf 
          (table-all (nth target-table clustered-tables)) 
          (append (table-all (nth target-table clustered-tables)) (list x)))
      )
    )
  )
)

(defun genic2 (table)
  (let* ((clusters (genic2-clusters table)) (clustered-tables (make-list (length clusters))))
    (loop for n from 0 to (- (length clusters) 1) do
      (setf 
        (nth n clustered-tables) (make-table)
        (table-name (nth n clustered-tables)) (table-name table)
        (table-columns (nth n clustered-tables)) (table-columns table)
        (table-class (nth n clustered-tables)) (table-class table)
        (table-cautions (nth n clustered-tables)) (table-cautions table)
        (table-indexed (nth n clustered-tables)) (table-indexed table)
      )
    )
    (dolist (x (table-all table) clustered-tables)
      (let ((target-table (score-clusters x clusters table)))
        (setf 
          (table-all (nth target-table clustered-tables)) 
          (append (table-all (nth target-table clustered-tables)) (list x)))
      )
    )
  )
)
