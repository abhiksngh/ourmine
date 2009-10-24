outpath=proj2/HyperPipes/PlotData/

file1=$outpath"outputFile-"$1"000-0-0-0-0.txt" #baseline
file2=$outpath"outputFile-"$1"001-0-0-0-0.txt" #centroid
file3=$outpath"outputFile-"$1"100-0-0-0-0.txt" #Weighted 0
file4=$outpath"outputFile-"$1"110-0-0-0-0.txt" #Weighted 1
file5=$outpath"outputFile-"$1"000-0-1-0-0.txt" #Original

file6=$outpath"outputFile-"$1"000-10-0-0-0.txt" #alpha=.10
file7=$outpath"outputFile-"$1"000-25-0-0-0.txt" #alpha=.25
file8=$outpath"outputFile-"$1"000-50-0-0-0.txt" #alpha=.50
file9=$outpath"nb-outputFile-"$1".dat" #nb stuff

file10=$outpath"outputFile-"$1"000-0-0-1-0.txt" #Relearn on overfit
file11=$outpath"outputFile-"$1"000-0-0-0-1.txt" #Revert on overfit

file10labels=$outpath$1"-relearndata.txt" #Relearn labels on overfit
file11labels=$outpath$1"-revertdata.txt" #Revert labels on overfit

gnuplot<<EOF
set terminal postscript eps dashed enhanced color "Helvetica" 12
set key inside top left
set output "proj2/HyperPipes/Plots/$1.eps"
set title "$1"
set xlabel "Rows Learned"
set ylabel "Accuracy"
set yrange [0:1]

plot	"$file1" using 1:2 title 'MultiPipes' with lines 1 2,\
	"$file9" using 1:2 title 'Naive Bayes' with lines 4 2,\
	"$file2" using 1:2 title 'Centroid' with lines 3 3,\
	"$file5" using 1:2 title 'Original' with lines 2 6,\
	"$file6" using 1:2 title 'Alpha .10' with lines 13 4,\
	"$file7" using 1:2 title 'Alpha .25' with lines 9 4,\
	"$file8" using 1:2 title 'Alpha .50' with lines 5 4

EOF

gnuplot<<EOF
set terminal postscript eps dashed enhanced color "Helvetica" 12
set key inside top left
set output "proj2/HyperPipes/Plots/$1-weighted.eps"
set title "$1 Weighted Scores"
set xlabel "Rows Learned"
set ylabel "Weighted Score"
set yrange [0:1]

plot	"$file1" using 1:3 title 'MultiPipes' with lines 1 2,\
	"$file6" using 1:3 title 'a = .10' with lines 13 4,\
	"$file7" using 1:3 title 'a = .25' with lines 9 4,\
	"$file8" using 1:3 title 'a = .50' with lines 5 4,\
	"$file10" using 1:3 title 'Relearn on Overfit' with lines 2 6,\
	"$file11" using 1:3 title 'Revert on Overfit' with lines 3 5


EOF

#	"$file10labels" using 1:2 title 'Relearn points' with lines 9 2,\
#	"$file11labels" using 1:2 title 'Revert points' with lines 11 2

epstopdf proj2/HyperPipes/Plots/$1.eps

#	"$file9" using 1:3 title 'Naive Bayes' with points 2 2,\


#	"$file3" using 1:2 title 'Weighted Numerics (Method 0)' with points 9 3,\
#	"$file4" using 1:2 title 'Weighted Numerics (Method 1)' with points 9 2,\

#	"$file3" using 1:2 title 'Weighted 0',\
#	"$file4" using 1:2 title 'Weighted 1',\

#ls -lsa $Tmp/dat.pdf
#cp $Tmp/dat.pdf ./plot.pdf
#evince ./plot.pdf

#plot "$file1" index 0 using 1:2 title "Wins" , \
# "$dat" index 0 using 1:3 title "Losses" , \
# "$dat" index 0 using 1:4 title "Ties"
#
