#!/usr/bin/bash
cd ..
outpath=proj2/HyperPipes/OutputFiles
plotdata=../proj2/HyperPipes/PlotData
file=`basename $1`	#remove directory
file=${file%.lisp}	#remove .lisp
echo "Running all HyperPipes options on $file dataset"
sbcl --load scripts/batch.lisp --noinform --eval "(batch \"$file\")"

echo "Generating Plot Datafile"
for file in `ls $outpath | grep $1`; do
base=`basename $file`
gawk -f scripts/stats.awk -v Filename=proj2/HyperPipes/OutputFiles/$file > proj2/HyperPipes/PlotData/$base
done

echo "Creating Plots"
for file in `ls $outpath | grep $1`; do
bash scripts/plot.sh $1
done

