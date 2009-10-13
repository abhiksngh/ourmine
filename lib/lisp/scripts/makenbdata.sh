for file in NBOutput/*.txt; do
base=`basename $file`
gawk -f stats.awk -v Filename=$file > NBOutput/${base%.txt}.dat
done
