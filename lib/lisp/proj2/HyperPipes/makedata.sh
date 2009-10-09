for file in OutputFiles/*.txt; do
base=`basename $file`
gawk -f stats.awk -v Filename=$file > PlotData/$base
done
