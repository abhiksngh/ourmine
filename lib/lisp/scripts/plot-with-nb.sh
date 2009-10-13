outpath=proj2/HyperPipes/PlotData/

file1=$outpath"outputFile-"$1"000-0-0.txt" #baseline
file2=$outpath"outputFile-"$1"001-0-0.txt" #centroid
file3=$outpath"outputFile-"$1"100-0-0.txt" #Weighted 0
file4=$outpath"outputFile-"$1"110-0-0.txt" #Weighted 1
file5=$outpath"outputFile-"$1"000-0-1.txt" #Original

file6=$outpath"outputFile-"$1"000-10-0.txt" #alpha=.10
file7=$outpath"outputFile-"$1"000-25-0.txt" #alpha=.25
file8=$outpath"outputFile-"$1"000-50-0.txt" #alpha=.50
file9=$outpath"nb-outputFile-"$1".dat" #nb stuff

gnuplot<<EOF
set terminal postscript eps dashed enhanced color "Helvetica" 12
set key inside top left
set output "proj2/HyperPipes/Plots/$1.eps"
set title "$1"
set xlabel "Rows Learned"
set ylabel "Accuracy"
set yrange [0:1]

plot	"$file1" using 1:2 title 'Baseline' with points 1 2,\
	"$file9" using 1:2 title 'Naive Bayes' with points 2 2,\
	"$file2" using 1:2 title 'Centroid' with points 3 3,\
	"$file5" using 1:2 title 'Original' with points 2 6,\
	"$file6" using 1:2 title 'Alpha .10' with points 13 4,\
	"$file7" using 1:2 title 'Alpha .25' with points 9 4,\
	"$file8" using 1:2 title 'Alpha .50' with points 5 4

EOF

epstopdf proj2/HyperPipes/Plots/$1.eps

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
