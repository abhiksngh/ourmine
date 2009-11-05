(defstruct cluster
  centroid      ;The centroid for the cluster
  members       ;The members that are next to the centroid
  )


(defstruct node
  data         ;the data in the node
  left-child   ;The left child of the node
  right-child  ;The right child of the node
  )

(defstruct rule
  class
  rules
  )
