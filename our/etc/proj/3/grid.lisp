;; Algorithm GRIDCLUS
;; (0) Initialization

;; (1) Create the Grid Structure

;; (2) Calculate the block densities DBi

;; (3) Generate a sorted block sequence S = <B1'. B2', ... Bb'>
;; sort by block density

;; (4) Mark all blocks 'not active' and 'not clustered'


;; (5) while a 'not active' block exist do
;; (7)      u := u + 1

;; (8)      Find active blocks Bi' .. Bj'
;; (9)      for each 'not clustered' block Bk' := B1' .. Bj' do
;; (10)           create a new cluster set C[u]
;; (11)           W[u] := W[u] + 1
;; (12)           C[u, W[u]] <- Bk'
;; (13)           mark block Bk' clustered
;; (14)           NEIGHBOR-SEARCH(Bk', C[u, W[u]})
;; (15)     endfor

;; (16)     for each 'not active' block Bl do
;; (17)          W[u] := W[u] + 1
;; (18)          C[u, W[u]] <- Bl
;; (19)     endfor
;; (20)     Mark all blocks 'not clustered'
;; (21) endwhile
;; end GRIDCLUS

;; Procedure NEIGHBOR-SEARCH(B, C)
;; (22) for each 'active' and 'not clustered' neighbor Bn of B do
;;     (23) C <- Bn
;;     (24) mark block Bn clustered
;;     (25) NEIGHBOR-SEARCH(Bn, C)
;; (26) endfor
;; end NEIGHBOR-SEARCH

(defun grid (source-table)
  (let* ((table (copy-table (10bins source-table)))   ;; (1) Create the Grid Structure
         (transposed-data (transpose table))
         (class-lst)
         (new-table)
         (new-data)
         (block-lst)
         (not-active-blocks)
         (not-clustered-blocks)
         (u)
         (DB-lst)
         )
    
    (setf class-lst (first (last transposed-data)))
    (setf transposed-data (remove class-lst transposed-data))
    


    ;; (2) Calculate the block densities DBi

    ;;(setf block-den-lst (append block-den-lst (mapcar #'desity-block block-lst)))

    ;;
   
    
    ;;Sort bins by density

    ;;(setf DB-lst (append DB-lst (mapcar #'DB
    

    ;;find most dense bin (first or last depending on sort)

    ;;While has-transitive-neighbor
    ;;  add-to-bucket
    
    ;;return table



    (setf new-data (append new-data (list class-lst)))
    
    (setf new-table (data
                     :name (table-name table)
                     :columns (columns-header (table-columns table))
                     :klass (table-class table)
                     :egs
                     (reverse (transpose newdata))))
    
    new-table
    )
  )



(defun spatial-volume (block)
  ;the cartesian product of extents e of the block B in each dimension
  (let ((
         ))

    )
  )

(defun density-block (block)
  ;the ratio of the actual number of patterns pb contained in block B and the 
                                        ; (/ (p block) (spatical-volume block))

)

;;is this sysnonimous with bin?
(defstruct block-struct
  block-id   ;;
  contents
  )

(defun build-grid (data)
  (let (
        (grid) ;;list of blocks
        ;; bin size = 10 * #instances
        )
    ;;apply concept of nbins (10) all instances



    ))

;; The GRIDCLUS algorithm handles all pattern in a common block as ties. With a large number of
;; pattern, these situation proved not to be a drawback. A large bucket size results in few blocks
;; covering large areas of the value space. In contrary small bucket sizes (near 1) produce an
;; artificially fine partitioned value space. This leads on the one hand to an increased computational
;; amount and on the other hand doesn't reflect the actual pattern distribution. The best results were
;; produced with bucketsizes of 3% to 5% of the data set size. Bucket sizes from 1% to 3% and
;; from 5% to 10% produced equally good results but led to longer calculation times. Bucket sizes
;; beyond this interval showed the above mentioned problems.
