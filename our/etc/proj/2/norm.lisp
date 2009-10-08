(defun minmax (lst) 
  (let ((start (reduce #'min lst))
	(end (reduce #'max lst))) 
    (mapcar #'(lambda (x) 
		(/ (- x start) (- end start))) 
	    lst)))

; puts data into 'bins' number of bins but the first and last are half size
(defun nbins1 (start end bins)
   (do (( x start (+ x 1)))
     ((> x end) 'Done)
     (format t "~A ~%" (round (* (/ (- x start)(- end start)) bins)))))

; correct version - all bins have the same width (whenever data allows)
(defun nbins (start end bins)
  (do (( x start (+ x 1)))
    ((> x end) 'Done)
    (format t "~A ~%" (floor (* (/ (- x start)(- end start)) bins)))))
