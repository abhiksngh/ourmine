BEGIN {
	RandSeed ? srand(RandSeed) : srand()
}

{
	File[++LineNum] = $0
}

END {
	NumRows = LineNum

	for (i = 1; i <= NumRows * 10; i++) {
		pick1 = int (rand() * NumRows + 1)
		pick2 = int (rand() * NumRows + 1)
		
		tmp = File[pick1]
		File[pick1] = File[pick2]
		File[pick2] = tmp
	}

	for (i = 1; i <= NumRows; i++)
		print File[i]

}
