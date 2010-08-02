(defun nb (f)
  (setf (wme-! *w*) #'bayes-row
	(wme-ready *w*) #'bayes-ready
	(wme-run
  (data f)
  )