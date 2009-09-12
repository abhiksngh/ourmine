(defun parse-date (str)
  (let ((toks (tokens str #'constituent 0)))
    (list (parse-integer (first toks))
          (parse-month (second toks))
          (parse-integer (third toks)))))

;Trips strange warning when (load "miner") occurs.  Seems to work fine otherwise.
(defvar month-names
  #("jan" "feb" "mar" "apr" "may" "jun"
    "jul" "aug" "sep" "oct" "nov" "dec"))

(defun parse-month (str)
  (let ((p (position str month-names :test #'string-equal)))
    (if p
        (+ p 1)
        nil)))

(deftest test-parsemonth ()
  (check (compare-lists (parse-date "7 Nov 1984") '(7 11 1984))))
