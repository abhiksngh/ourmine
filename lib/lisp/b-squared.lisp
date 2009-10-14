
(defun b-squared (data)
	(let* (score-data(data))					     ;take the data and set utility values
		(sort-scored(score-data data))				     ;sort the utility values for chopping
		(chop-data(sort-scored(score-data data)))		     ;chop the data into the best and rest catergory
		(find-range(chop-data(sort-scored(score-data data))))))      ;find and sort range with b^2 / (b+r) formula
		
(defun score-data(data)
	(let * 