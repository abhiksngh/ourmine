gawk -f sizestats.awk -v Filename=../proj2/HyperPipes/OutputFiles/outputFile-$1000-0-0.txt  -v Classes=$2 > ../proj2/HyperPipes/SetPlotData/$1-baseline.dat

gawk -f sizestats.awk -v Filename=../proj2/HyperPipes/OutputFiles/outputFile-$1000-10-0.txt -v Classes=$2 > ../proj2/HyperPipes/SetPlotData/$1-alpha10.dat

gawk -f sizestats.awk -v Filename=../proj2/HyperPipes/OutputFiles/outputFile-$1000-25-0.txt  -v Classes=$2 > ../proj2/HyperPipes/SetPlotData/$1-alpha25.dat

gawk -f sizestats.awk -v Filename=../proj2/HyperPipes/OutputFiles/outputFile-$1000-50-0.txt  -v Classes=$2 > ../proj2/HyperPipes/SetPlotData/$1-alpha50.dat

inpath=../proj2/HyperPipes/SetPlotData

gnuplot<<EOF
set terminal postscript eps dashed enhanced color "Helvetica" 12
set key inside top left
set output "../proj2/HyperPipes/Plots/$1-setsize.eps"
set title "$1"
set xlabel "Rows Learned"
set ylabel "% classes in disjunction"
set yrange [0:1]
plot	"$inpath/$1-baseline.dat" using 1:2 title 'Baseline',\
	"$inpath/$1-alpha10.dat" using 1:2 title '10% Alpha',\
	"$inpath/$1-alpha25.dat" using 1:2 title '25% Alpha',\
	"$inpath/$1-alpha50.dat" using 1:2 title '50% Alpha'
EOF

epstopdf $outpath../proj2/HyperPipes/Plots/$1-setsize.eps

