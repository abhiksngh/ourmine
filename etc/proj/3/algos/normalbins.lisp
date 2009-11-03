(load "lib/loaddeps")
(load "utils/utils")
(load "d-data/mushroom")
(load "d-data/boston-housing")

(defparameter mushtable (mushroom))
(defparameter housetable (boston-housing))

;;; Claimee: Drew

;;;  (EASY) Normal-chops
;;;    Assume data is Gaussian and divide into -3, -2, -1, 0, 1,2,3 standard 
;;;    deviations away from the mean. Hint: see lisp/tricks/normal.lisp

;;; 1. Compute the mean of a column.

(defun column-mean (table column-num)
  (let ((sum 0))
    (dolist (row (table-all table))
      (incf sum (nth column-num (eg-features row)))
    )
    (/ sum (length (table-all table)))
  )
)

;;; 2. Compute the standard deviation of a column.  StDev is measured as
;;;    the average of the distances of each value from the mean.  Relevant
;;;    equation is: stddev = sqrt(1/n * Summation((member - mean)^2))

(defun column-stddev (table column-num)
)

;;; 3. Generate bin widths, return a list of staring and ending values
;;;    in the format of ((-20 -10) (-10 0) (0 10)) and so forth.  When
;;;    doing binning, the lower value is inclusive, the upper value
;;;    is not, so >= car and < cdar meets critera for binning.

(defun column-binwidths (table column-num)
)

;;; 4. For each numeric column in the table, compute average, then
;;;    standard deviation, then compute bin ranges, then overwrite
;;;    column values with their new bin number.

(defun normal-bins (table)
)
