(load "lib/loaddeps")
(load "utils/utils")
(load "d-data/mushroom")
(load "d-data/boston-housing")

(defparameter mushtable (mushroom))
(defparameter housetable (boston-housing))

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

;;; (count-classes table)

(defun generate-attribute-value-pairs (table)
  (let ((col-names (table-columns table)) (unique-features (list-unique-features table)) (pairs nil))
    (dotimes (i (length (table-columns table)))		;;; For each column.
      (let ((values nil))
        (dolist (element (nth i unique-features))
          (setf values (append values (list (first element))))
        )
        (setf pairs (append pairs (list (list (discrete-name (nth i col-names)) (copy-list values)))))
      )
    )
    pairs
  )
)

(defun remove-nth (n in-list)
  (remove (nth n in-list) in-list)
)

(defun unique-table-classes (table)
  (let ((classes nil) (class-count (count-classes table)))
    (dolist (x class-count)
      (setf classes (append classes (list (first x))))
    )
    classes
  )
)

(defun score-attribute (table subset attribute-num class)
  (let ((best-value nil) (best-score nil) (values (second (nth attribute-num (generate-attribute-value-pairs table)))))
    (dotimes (i (length values))
      (let ((passes 0))
        (dolist (row subset)
          (if (and (equalp class (eg-class row)) (equalp (nth attribute-num (eg-features row)) (nth i values)))
            (incf passes)
          )
        )
        (if (or (null best-score) (> (/ passes (length subset)) best-score))
          (setf best-value (nth i values) best-score (float (/ passes (length subset))))
        )
      )
    )
    (list best-value best-score)
  )
)

(defun prism (table)
  (let ((rules nil))
    (dolist (class (unique-table-classes table))
      (let ((rule nil) (rule-complete nil))
        (loop until (not (nullp rule-complete)) do
          
        )
      )
    )
    rules
  )
)
