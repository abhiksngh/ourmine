; oneR.lisp
;
; Discretize the data.
; * Sort each numeric attribute, along with its associated class.
; * Place the first 6 instances in bin1.
; * Grow bin1 as long as the majority class in bin1 remains constant.
; * Repeat for the rest of the data.
;
; Select for classes using one attribute.
