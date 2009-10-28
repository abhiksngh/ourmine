;;; Claimee: Drew

;;; For each class C 
;;;   Initialize E to the instance set 
;;;   While E contains instances in class C 
;;;     Create a rule R with an empty left-hand side that predicts class C 
;;;     Until R is perfect (or there are no more attributes to use) do 
;;;       For each attribute A not mentioned in R, and each value v, 
;;;         Consider adding the condition A = v to the left-hand side of R 
;;;         Select A and v to maximize the accuracy p/t 
;;;           (break ties by choosing the condition with the largest p) 
;;;       Add A = v to R 
;;;     Remove the instances covered by R from E 


