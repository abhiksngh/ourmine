file1=proj2/HyperPipes/PlotData/$1"-overfitdata.txt" #baseline
file2=proj2/HyperPipes/PlotData/$1"-reset-overfitdata.txt" #baseline
file3=proj2/HyperPipes/PlotData/$1"-revert-overfitdata.txt" #baseline

gnuplot<<EOF
set terminal postscript eps dashed enhanced color "Helvetica" 8
set key inside top left
set output "proj2/HyperPipes/Plots/$1-overfitting.eps"
set title "$1 Overfitting"
set xlabel "Class"
set ylabel "Miss Percentage"

plot	"$file1" using 2:xticlabel(1) title "Percent overfit" with boxes,\
	"$file2" using 2:xticlabel(1) title "Reset overfit" with boxes,\
	"$file3" using 2:xticlabel(1) title "Revert overfit" with boxes

EOF


#set style fill solid 1.000000 border -1
