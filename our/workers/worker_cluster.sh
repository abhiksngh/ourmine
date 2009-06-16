
#runtimes of kmeans and canopy, with varying dataset and k
worker001(){
    local clusterers="-k -c"
    local numclusters="4 16 32 64 128 256 512" 
    local datadir=$1
    local outdir=$2

    for clusterer in $clusterers; do
	for f in $datadir/*; do
	    for k in $numclusters; do
		out=`basename $f`
		out=${out%.*}
		out=$out"_k=$k"
		echo $out
		start=$(date +%s)
		$Clusterers $clusterer $k $datadir/`basename $f` $outdir/$out.arff 5 15;
		end=$(date +%s)
		time=$((end - start))
		echo "$clusterer,$out,$time" >> clustertimes
	    done
	done
    done
} 