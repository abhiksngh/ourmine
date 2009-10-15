; Main.lisp
; Entry point for Proj2a.
; Load necessary files.
;
; Defun learn (use template from project definition).
;(format t "Loading files~a");
(load "miner")
(load "modules/bore")
(load "modules/oner")
(load "modules/normchops")
;(load "modules/genic2")
(load "../../../lib/lisp/tests/data/quake")
(load "../../../lib/lisp/tests/data/sick")

(defun learn (&key (k 8) prep discretizer clusterer fss classify
				   (train "train.lisp")
				   (test "test.lisp")
				   (training (load train))
				   (testing (load test)))
 (let* ((preptrain (funcall prep training))
		(preptest (funcall prep testing))
		(discrete-table (funcall discretizer preptrain))
		(clustered-table (funcall clusterer preptrain k))
		(features (funcall fss clustered-table))
		(classification (funcall classify discrete-table features)))
  (values preptest classification)))
