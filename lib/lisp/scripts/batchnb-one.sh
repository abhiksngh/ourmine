#!/usr/bin/bash
cd ..
outpath=proj2/HyperPipes/OutputFiles
plotdata=../proj2/HyperPipes/PlotData
tmpdir=tmp
file=`basename $1`	#remove directory
file=${file%.lisp}	#remove .lisp
echo "Running all HyperPipes options on $file dataset"

for ((i = 1; i <= 10; i++))
do
gawk -f scripts/datablend.awk -v RandSeed=$RANDOM -v Filename=proj2/HyperPipes/Data/$1".lisp" > $tmpdir/blend$i-$1.lisp
done


sbcl --load scripts/batch.lisp --eval "(batch \"$file\")"
echo "Running naive bayes on $file dataset"
#sbcl --load scripts/nb-batch.lisp --eval "(nb-batch \"$file\")"

echo "Generating Plot Datafiles"
for file in `ls $outpath | grep $1`; do
base=`basename $file`
gawk -f scripts/stats-noavg.awk -v Filename=proj2/HyperPipes/OutputFiles/$file -v Classes=$2 > proj2/HyperPipes/PlotData/$base
done

echo "Generating Label Plot Datafiles"
gawk -f scripts/labelstats.awk -v y=0.1 -v Filename=proj2/HyperPipes/OutputFiles/outputFile-$1""000-0-0-0-1.txt > proj2/HyperPipes/PlotData/$1-revertdata.txt
gawk -f scripts/labelstats.awk -v y=0.05 Filename=proj2/HyperPipes/OutputFiles/outputFile-$1""000-0-0-1-0.txt > proj2/HyperPipes/PlotData/$1-relearndata.txt

echo "Generating Plot Datafile for NB"
#gawk -f scripts/stats.awk -v Filename=proj2/HyperPipes/NBOutput/nb-outputFile-$1.txt > proj2/HyperPipes/PlotData/nb-outputFile-$1.dat

echo "Generating Overfit Data"
cat proj2/HyperPipes/OutputFiles/outputFile-$1""000-0-0-0-0.txt | gawk -f scripts/plotoverfit.awk > proj2/HyperPipes/PlotData/$1-overfitdata.txt
cat proj2/HyperPipes/OutputFiles/outputFile-$1""000-0-0-1-0.txt | gawk -f scripts/plotoverfit.awk > proj2/HyperPipes/PlotData/$1-reset-overfitdata.txt
cat proj2/HyperPipes/OutputFiles/outputFile-$1""000-0-0-0-1.txt | gawk -f scripts/plotoverfit.awk > proj2/HyperPipes/PlotData/$1-revert-overfitdata.txt

echo "Creating Plots"
#for file in `ls $outpath | grep $1`; do
bash scripts/plot-with-nb.sh $1
bash scripts/plot-overfit.sh $1
#done

