; Main.lisp
; Entry point for Proj2a.
; Load necessary files.
;
; Defun learn (use template from project definition).
;(format t "Loading files~a");
(load "miner")
(load "modules/bore")
(load "modules/slowbore")
(load "modules/oner")
(load "modules/normchops")
(load "modules/normalization")
(load "modules/nchops")
(load "modules/b-squared")
(load "modules/nomograms")
(load "modules/genic2")
(load "modules/2b.lisp")
(load "tests/data/quake")
(load "tests/data/sick")
(load "tests/data/vehicle")
(load "tests/data/bolts")
(load "tests/data/cloud")
(load "tests/data/autos")
(load "tests/data/ionosphere")
(load "tests/data/german_credit")
(load "tests/data/servo")
(load "tests/data/meta")
(load "tests/graphs")

(defstruct rule column value prediction)

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
  (values classification preptest)))
