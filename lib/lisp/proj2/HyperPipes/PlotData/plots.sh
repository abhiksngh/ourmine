#Tmp=~/tmp
#[ ! -d "$Tmp" ] && mkdir $Tmp
#dat="$Tmp/tmp.dat"

#rm $dat;
#sbcl --load "main.lisp" $1;

file1="outputFile-"$1"000-0-0.txt"
file2="outputFile-"$1"001-0-0.txt"
file3="outputFile-"$1"100-0-0.txt"
file4="outputFile-"$1"110-0-0.txt"
file5="outputFile-"$1"000-0-1.txt"

file6="outputFile-"$1"000-10-0.txt" #alpha=.10
file7="outputFile-"$1"000-25-0.txt" #alpha=.25
file8="outputFile-"$1"000-50-0.txt" #alpha=.50

gnuplot<<EOF
set terminal postscript eps dashed enhanced color "Helvetica" 15
set output "../Plots/$1.eps"
set title "$1"
set xlabel "Rows Learned"
set ylabel "Accuracy"
set key top left
plot "$file1"
replot "$file2"
replot "$file3"
replot "$file4"
replot "$file5"
replot "$file6"
replot "$file7"
replot "$file8"
EOF

epstopdf ../Plots/$1.eps
#ls -lsa $Tmp/dat.pdf
#cp $Tmp/dat.pdf ./plot.pdf
#evince ./plot.pdf

#plot "$file1" index 0 using 1:2 title "Wins" , \
# "$dat" index 0 using 1:3 title "Losses" , \
# "$dat" index 0 using 1:4 title "Ties"
#
