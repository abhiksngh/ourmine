BEGIN {
	Dataset ? Dataset : Dataset = "Nameless Dataset"
	Source ? Source : Source = "tmp"
	OutPath ? OutPath : OutPath = "tmp"
	NB ? NB : NB = "no"

	Blends ? Blends : Blends = 10
	KeyLoc = "inside top left"
	

	printHeader()
	for (i = 1; i <= Blends; i++) {
		printBlend(i)
	}
}

function printHeader() {
	print "set terminal postscript eps dashed enhanced color \"Helvetica\" 12"
	print "set key "KeyLoc
	print "set output \""OutPath"/"Dataset"-accuracy.eps\""
	print "set title \""Dataset"\""
	print "set xlabel \"Rows Learned\""
	print "set ylabel \"Accuracy\""
	print "set yrange [0:1]"
	printf "plot	"
}

function printBlend(i) {
	#multipipes
	print "\""Source"/outputFile-blend"i"-"Dataset"000-0-0-0-0-0.txt-accuracy-stats.txt\" using 1:2 title 'MultiPipes' with lines 1 2,\\"

if (NB == "yes")
	print "\""Source"/nb-outputFile-blendnb"i"-"Dataset".txt-accuracy-stats.txt\" using 1:2 title 'Naive Bayes' with lines 4 2,\\"

	print "\""Source"/outputFile-blend"i"-"Dataset"001-0-0-0-0-0.txt-accuracy-stats.txt\" using 1:2 title 'Centroid' with lines 3 3,\\"
	print "\""Source"/outputFile-blend"i"-"Dataset"100-0-0-0-0-0.txt-accuracy-stats.txt\" using 1:2 title 'Weighted 0' with lines 3 2,\\"
	print "\""Source"/outputFile-blend"i"-"Dataset"110-0-0-0-0-0.txt-accuracy-stats.txt\" using 1:2 title 'Weighted 1' with lines 4 2,\\"
	print "\""Source"/outputFile-blend"i"-"Dataset"000-0-1-0-0-0.txt-accuracy-stats.txt\" using 1:2 title 'HyperPipes' with lines 4 2,\\"

	print "\""Source"/outputFile-blend"i"-"Dataset"000-10-0-0-0-0.txt-accuracy-stats.txt\" using 1:2 title 'Alpha .10' with lines 1 2,\\"
	print "\""Source"/outputFile-blend"i"-"Dataset"000-25-0-0-0-0.txt-accuracy-stats.txt\" using 1:2 title 'Alpha .25' with lines 1 2,\\"
	printf "\""Source"/outputFile-blend"i"-"Dataset"000-50-0-0-0-0.txt-accuracy-stats.txt\" using 1:2 title 'Alpha .50' with lines 1 2"
	if (i != Blends)
		print ",\\"
}
