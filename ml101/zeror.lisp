(defun zeror (&key f (bins 3))
  (labels ((ready (tbl) (maxof (table-klasses tbl)
			       :key #'klass-n :result #'klass-name)))
  (data f)
  (traintest bins
	     :train #'defrow
	     :ready #'majority
	     :tester #'isMajority
	     :reporter #'abcd
  t)))