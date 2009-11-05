;; Algorithm GRIDCLUS
;; (0) Initialization

;; (1) Create the Grid Structure

;; (2) Calculate the block densities DBi

;; (3) Generate a sorted block sequence S = <B1'. B2', ... Bb'>

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

    

    
    (setf new-data (append new-data (list class-lst)))
    
    ;;Sort bins by density
    

    ;;find most dense bin (first or last depending on sort)

    ;;While has-transitive-neighbor
    ;;  add-to-bucket
    
    ;;return table

    
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
  ;
  (let ((
         ))

    )
  )

(defun density-block (block)
  ; (/ (p block) (spatical-volume block))