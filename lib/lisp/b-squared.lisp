
(defun b-squared (table className)
	(let* data (table-copy(data table))
	        (score-data(data className)				     ;take the data and set utility values
		(sort-scored(score-data data)				     ;sort the utility values for chopping
		(find-range(score-data data))		    
		(sort-scored (find-range(score-data data)))                           ;find and sort range with b^2 / (b+r) formula
		
(defun score-data(data className)					    ;takes the data table and the class name to examine
	(let* (clas table-class))					    ;makes a class variable for the table data
	(dotimes (i 							    ;iterates through the class column to examine datums
	(if (eql clas className)					    ;checks class in table versus input name
		((cons 'listBest)                                           ;builds best and rest lists
		   (incf bestCtr))
		((cons 'listRest)
		    (incf restCtr)))

		
(defun find-range(score-data data className)
	(let (rangeBest (bestCtr / (bestCtr + restCtr))
		(rangeRest (restCtr / (bestCtr + restCtr)))
		(if (rangeBest rangeRest >)
			(let rangeBest 0))
			
(defun sort-scored(find-range(score-data data className))
	(let*   (medianScore (/ (* best best) (+ best rest)))
		(scoredBest (sort rangeBest #'< medianScore))
		(scoredRest (sort rangeRest #'< medianScore))
	(append scoredBest scoredRest)
	(loop for x in scoredBest
		do (if (scoredBest 0.8 #'>)
			(push x result)))))
	
	