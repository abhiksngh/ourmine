#generate a bar graph representing the frequency of a class contained
#within a disjunction versus the actual appearance of that class in the data

BEGIN {
	parseData()
}

function parseData() {
	getline #ignore first line (there's a nil in prediction)
	while (getline) {
		gsub(/\(/,"",$0)
		gsub(/\)/,"",$0)

		class = $NF

		LineCount++
		Hits[class]++
		for (i = 3; i < NF; i++)
			Picks[$NF]++
	}

}

END {
	for (key in Hits) {
		score = (Picks[key] - Hits[key])/Picks[key]
		uniqueScore = score + rand() * 0.000001
		ScoreToKey[uniqueScore] = key
		KeyToScore[key] = uniqueScore
	}

	n = asort(KeyToScore)
	for (i = n; i > 0; i--) {
		print ScoreToKey[KeyToScore[i]]" "KeyToScore[i]
	}

}
