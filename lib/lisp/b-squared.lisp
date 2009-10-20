
(defun b-squared (data className)
	(let* (score-data(data className))				     ;take the data and set utility values
		(sort-scored(score-data data))				     ;sort the utility values for chopping
		(chop-data(sort-scored(score-data data)))		     ;chop the data into the best and rest catergory
		(find-range(chop-data(sort-scored(score-data data))))))      ;find and sort range with b^2 / (b+r) formula
		
(defun score-data(data className)					    ;takes the data table and the class name to examine
	(let* clas table-class))					    ;makes a class variable for the table data
	(dotimes (i 							    ;iterates through the class column to examine datums
	(if (eql clas className)					    ;checks class in table versus input name
		((cons 'listBest)                                           ;builds best and rest lists
		   (incf bestCtr))
		((cons 'listRest)
		    (incf restCtr)))

		
