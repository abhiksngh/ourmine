#generate a bar graph representing the frequency of a class contained
#within a disjunction versus the actual appearance of that class in the data

BEGIN {
	parseData()
}

function parseData() {
	getline #ignore first line (there's a nil in prediction)

}
