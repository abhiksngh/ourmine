; oneR.lisp - Classifier

; Select for classes using one attribute
; NOTE: "Missing" is treated as a separate attribute value.
(defun count-n-sort (pair-lst)
;  (format t "~A~%~%~%~%~%~%~%_________________________~%~%~%~%~%~%~%" pair-lst)
  (sort
   (compress (sort
	      (sort pair-lst (lambda (a b) (cond ((typep (first a) 'REAL)
						  (< (if (eql (first a) '?) 0 (first a))
						     (if (eql (first b) '?) 0 (first b))))
						 ((typep (first a) 'SYMBOL)
						  (string< (format nil "~a" (first a))
							   (format nil "~a" (first b)))))))
	      (lambda (c d) (string< (format nil "~a" (first (last c)))
				     (format nil "~a" (first (last d)))))))
   (lambda (e f) (cond ((and
			 (typep (caadr e) 'REAL)
			 (typep (caadr f) 'REAL))
			(< (if (eql (caadr e) '?) 0 (caadr e))
			   (if (eql (caadr f) '?) 0 (caadr f))))
		       ((typep (caadr e) 'SYMBOL)
			(string< (format nil "~a" (first (last e)))
				 (format nil "~a" (first (last f)))))))))


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
;(defun ruleset-exist (rls test)
;  (indexof test (car (ruleset-rules rls))))
(defun ruleset-exist (rls test)
  (dolist (item (ruleset-rules rls))
    (if (equal test (rule-rule item))
        (return t)
	(return nil))))

; Add a rule to the ruleset
(defun ruleset-add (rls rle prdctn errs crct)
  (push (make-rule :rule rle :prediction prdctn :errors errs :correct crct) (ruleset-rules rls)))

; Sum our rule errors.
; TODO: Needs to be fixed to work correctly with rules structure
(defun ruleset-sumerrors (rls)
  (if (null rls)
      0
      (+ (rule-errors (car rls)) (ruleset-sumerrors (cdr rls)))))

; This is probably pre-built or something trivial with mapcar?
; Unused, written as a recursion experiment.
(defun sumlst (lst)
  (if (null lst)
      0
      (+ (car lst) (sumlst (cdr lst)))))

(defun greatest (indeces classcount)
  (let ((greatest (first indeces))
	(errors 0))
    (if (< (length indeces) 2)
	(return-from greatest (list (first indeces) 0))
	(dolist (index indeces)
	  (incf errors (first (nth index classcount)))
	  (when (> (if (eql (first (nth index classcount)) '?) 0 (first (nth index classcount)))
		   (if (eql (first (nth greatest classcount)) '?) 0 (first (nth greatest classcount))))
	    (setf greatest index))))
    (decf errors (first (nth greatest classcount)))
    (list greatest errors)))

(defun ruleset-select-best (rls)
  (let ((rle)
	(best 0)
	(rate 0))
    (dolist (item (ruleset-rules rls))
      (setf rate (/ (rule-errors item) (+ (rule-errors item) (rule-correct item))))
      (when (< best rate)
	(setf best rate)
	(setf rle item)))
    (append (list (ruleset-attribute rls) rle))))
(defun best-overall (lst)
  (let ((rle)
	(best 0)
	(rate 0)
	(x 0))
    (dolist (item lst)
      (if (null (second item))
	  (return-from best-overall (list (first (nth x lst)) rle)))
      (incf x)
      (setf rate (/ (rule-errors (second item)) (+ (rule-errors (second item)) (rule-correct (second item)))))
      (when (< best rate)
	(setf best rate)
	(setf rle (second item)))
      (list (first (nth x lst)) rle))))

; We can probably condense some loops (and speed things up).
(defun slowoner (dataset &optional (columns (table-columns dataset)))
  (let ((datatable (copy-table dataset))
	(colindex nil)
	(best-rules))
    (dolist (column columns) ; FOREACH column (attribute) in the column list/dataset.
      (when (typep column 'discrete)
	(let ((classcount nil))
	  (setf colindex (indexof column (table-columns datatable)))
	  (dolist (record (table-all datatable)) ; FOREACH value in the column (attribute).
	    (setf classcount
		  (append classcount
			  (list (append (list (nth colindex (eg-features record))) (last (eg-features record)))))))
	  ; Sort and compress (count).
	  (setf classcount (count-n-sort classcount))
          ;(format t "DEBUG: ~A~%" classcount)
          ; Walk through determining what to keep.
	  (let ((rules (make-ruleset :attribute (header-name column) :records (length (table-all datatable))))
		(rule-to-add)
		(rl-lst))
	    (dolist (item classcount)
	      (when (null (ruleset-exist rules (caadr item)))
	      ; Get all records with matching attribute values
	      ; Determine the best rule.
	      ; Determine the number of errors this rule produces.
		(setf rl-lst (greatest (indexesofat (caadr item) classcount :finder #'caadr) classcount))
	;	(format t "GREATEST: ~A~%" rl-lst)
		(setf rule-to-add (nth (first rl-lst) classcount))
	      (ruleset-add rules (caadr rule-to-add) (cadadr rule-to-add) (second rl-lst) (car rule-to-add))))
	  ; (format t "~A~%" rules)
	   ; Pick the best rule for this column.
	   (setf best-rules (append best-rules (list (ruleset-select-best rules))))
	   )))
;      (return-from oner 'DONE)
)
    (format t "~A~%" (best-overall best-rules))
))
