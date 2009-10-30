BEGIN {
	if (RandSeed) print "Random seed used: "RandSeed; else print "No random seed presented"
}

{
	File[++LineNum] = $0
}

END {
	PicksLeft = LineNum

	while (PicksLeft > 0) {
		split("",RowsLeft,"")
		RowsLeft[0] = PicksLeft

		cntr = 0
		for (key in File) {
			RowsLeft[++cntr] = 1
		}

		


}
