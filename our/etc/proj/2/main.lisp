; Main.lisp
; Entry point for Proj2a.
; Load necessary files.
;
; Defun learn (use template from project definition).
;(format t "Loading files~a");

(defparameter *files* '("../../../lib/lisp/tests/deftest"
			"../../../lib/lisp/tricks/normal"))

(defun make1 (files)
  (let ((n 0))
    (dolist (file files)  
      (format t ";;;; ~a.lisp~%"  file)
      (incf n)
      (load file))
    (format t ";;;; ~a files loaded~%" n)))

(defun make (&optional (verbose nil))
  (if verbose
      (make1 *files*)
      (handler-bind
          ((style-warning #'muffle-warning))
        (make1 *files*))))

;(defun learn (&key (k 8)
	;      (prep #'bore)
	 ;     (discretizer #'normalChops)
	  ;    (cluster #'(lambda (data) (genic2 k data))) ; May need to correct this.
	   ;   (fss #'nomograms)
	    ;  (classify #'oner) ; Need to do naivebayes too.
;	      (train "train.lisp")
;	      (test "test.lisp"))
	     ; (train "quake.lisp")
	      ;(test "quake.lisp"))
;  (let ((training (load train))
	;(testing  (load test)))
    ; Code.
;    )


(format t "Loading Files~%")
(make)
