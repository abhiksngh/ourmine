#Tmp=~/tmp
#[ ! -d "$Tmp" ] && mkdir $Tmp
#dat="$Tmp/tmp.dat"

#rm $dat;
#sbcl --load "main.lisp" $1;

file1="outputFile-"$1"000-0-1.txt"
echo file1

#gnuplot<<EOF
#set size 0.5,0.5
#set clip two
#set terminal postscript eps dashed enhanced color "Helvetica" 15
#set output "$Tmp/dat.eps"
#set style fill solid 0.50 border
#set style data lines
#set title "Tic-Tac-Toe Training Size vs Win/Loss/Tie"
#set xlabel "Training Samples"
#set ylabel "Frequency %"
#set key top left
#set yrange [-1:101]
#plot "$dat" index 0 using 1:2 title "Wins" , \
# "$dat" index 0 using 1:3 title "Losses" , \
# "$dat" index 0 using 1:4 title "Ties"
#EOF

#epstopdf $Tmp/dat.eps
#ls -lsa $Tmp/dat.pdf
#cp $Tmp/dat.pdf ./plot.pdf
#evince ./plot.pdf
