#Tmp=~/tmp
#[ ! -d "$Tmp" ] && mkdir $Tmp
#dat="$Tmp/tmp.dat"

#rm $dat;
#sbcl --load "main.lisp" $1;
#counttype meantype centroid
file1="outputFile-"$1"000-0-0.txt" #baseline
file2="outputFile-"$1"001-0-0.txt" #centroid
file3="outputFile-"$1"100-0-0.txt" #Weighted 0
file4="outputFile-"$1"110-0-0.txt" #Weighted 1
file5="outputFile-"$1"000-0-1.txt" #Original

file6="outputFile-"$1"000-10-0.txt" #alpha=.10
file7="outputFile-"$1"000-25-0.txt" #alpha=.25
file8="outputFile-"$1"000-50-0.txt" #alpha=.50

gnuplot<<EOF
set terminal postscript eps dashed enhanced color "Helvetica" 12
set key inside bottom right
set output "../Plots/$1.eps"
set title "$1"
set xlabel "Rows Learned"
set ylabel "Accuracy"
set yrange [0:1]
plot	"$file1" using 1:2 title 'Baseline', \
	"$file2" using 1:2 title 'Centroid',\
	"$file3" using 1:2 title 'Weighted 0',\
	"$file4" using 1:2 title 'Weighted 1',\
	"$file5" using 1:2 title 'Original',\
	"$file6" using 1:2 title 'Alpha .10',\
	"$file7" using 1:2 title 'Alpha .25',\
	"$file8" using 1:2 title 'Alpha .50'
EOF

epstopdf ../Plots/$1.eps
#ls -lsa $Tmp/dat.pdf
#cp $Tmp/dat.pdf ./plot.pdf
#evince ./plot.pdf

#plot "$file1" index 0 using 1:2 title "Wins" , \
# "$dat" index 0 using 1:3 title "Losses" , \
# "$dat" index 0 using 1:4 title "Ties"
#
