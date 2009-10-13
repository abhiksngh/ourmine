; oneR.lisp - Classifier
;
; Select for classes using one attribute
; NOTE: "Missing" is treated as a separate attribute value.

(defun oner (dataset &optional (columns (table-columns dataset)))
  (let ((datatable (copy-table dataset))
	(classcount nil)
	(colindex nil)
	)
    ; FOREACH column (attribute) in the dataset.
    (dolist (column columns)
      ; IF the column (attribute) is discrete.
      (if (typep column 'discrete)
	  (progn
	    (setf colindex (indexof column (table-columns datatable)))
	    ; FOREACH value in the column (attribute)
	    (dolist (record (table-all datatable))
	      (setf classcount
		    (append classcount
			    (list (append (list (nth colindex (eg-features record))) (last (eg-features record)))))))
	    ; Sort and compress (count).
	    (setf classcount (count-n-sort classcount))
	    ; Debugging
;	    (dolist (item classcount)
;	      (format t "~a~%" item))
;	    (return-from oner 'DONE)

	    ; Walk through determining what to keep.
	    (let ((rules (make-ruleset :attribute (header-name column) :records (length (table-all datatable))))
		  )
	      (dolist (item classcount)
		(if (ruleset-exist rules (caadr item))
		    nil
		    (progn
		      nil
;		      (ruleset-add rules (caadr item)        ; rle pred errs
		      )))
	      (format t "~a~%" rules))
	    (return-from oner 'DONE)
	    )
	  ))))

; Counts and sorts list of pairs of the form ((number symbol) (number symbol))
; First order by number, then symbol.
; Compress (count).
; Order again according to attribute value.
(defun count-n-sort (pair-lst)
  (sort
   (compress (sort
	      (sort pair-lst (lambda (a b) (< (if (eql (first a) '?) 0 (first a))
					      (if (eql (first b) '?) 0 (first b)))))
	      (lambda (a b) (string< (string (first (last a)))
				     (string (first (last b)))))))
   (lambda (a b) (< (if (eql (caadr a) '?) 0 (caadr a))
		    (if (eql (caadr b) '?) 0 (caadr b))))))


(defstruct ruleset
  attribute ; The name of the attribute.
  rules     ; List of rules.
  records   ; Number of records for error calculations.
)

(defstruct rule
  rule       ; The rule.
  prediction ; The prediction.
  errors     ; Number of errors.
  correct    ; Number of times this rule was correct.
)

; Check for existing rules.
(defun ruleset-exist (rls rule)
  (if (null (indexof rule (car (ruleset-rules rls))))
      nil
      t))

; Add a rule to the ruleset
(defun ruleset-add (rls rle prdctn errs)
  (push (make-rule :rule rle :prediction prdctn :errors errs) (rules-rules rls)))

; Sum our rule errors.
; TODO: Needs to be fixed to work correctly with rules structure
(defun ruleset-sumerrors (rls)
  (if (null rls)
      0
      (+ (rule-errors (car rls)) (rules-sumerrors (cdr rls)))))

; This is probably pre-built or something trivial with mapcar?
; Unused, written as a recursion experiment.
(defun sumlst (lst)
  (if (null lst)
      0
      (+ (car lst) (testing (cdr lst)))))
