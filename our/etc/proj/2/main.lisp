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

(defun learn (&key (k 8)
                   (prep #'normalize-numerics)
				   (discretizer #'10bins)
				   (clusterer (lambda (data) (kmeans k data)))
				   (fss #'infogain)
				   (classify #'naiveBayes)
				   (train "train.lisp")
				   (test "test.lisp"))
  (let ((training (load train))
		(testing (load test)))
	(let* ((preptrain (prep training))
		   (preptest (prep testing))
		   (discrete-table (discretizer preptrain))
		   (clusters (clusterer preptrain))
		   (features (fss clusters))
		   (classification (classify discrete-table features))))))

(load "../../../lib/lisp/tests/data/quake")
(load "../../../lib/lisp/tests/data/sick")
(display-table-simple (bore (quake)))
;(oner (sick))
(format t "~a ~%" (table-ranges (normal-chops (bore (quake) '($latitude)))))
