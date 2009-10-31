for file in ../proj2/HyperPipes/OutputFiles/*.txt; do
base=`basename $file`
gawk -f stats.awk -v Filename=$file > ../proj2/HyperPipes/PlotData/$base
done
