#workers for dimensionality reduction, n=number of desired attributes, increase by inc val

reduceWorkerTfidf(){
    local datadir=$1
    local minN=$2
    local maxN=$3
    local incVal=$4
    local outdir=$5

    for((n=$minN;n<=$maxN;n+=$incVal)); do
	for file in $datadir/*.arff; do
	    out=`basename $file`
	    out=${out%.*}
	    out=tfidf_n="$n"_$out.arff
	    echo $out
	    $Reducers -tfidf $file $n $outdir/$out
	done
    done
} 

reduceWorkerPCA(){
    local datadir=$1
    local minN=$2
    local maxN=$3
    local incVal=$4
    local outdir=$5

    for((n=$minN;n<=$maxN;n+=$incVal)); do
	for file in $datadir/*.arff; do
	    out=`basename $file`
	    out=${out%.*}
	    out=pca_n="$n"_$out.arff
	    echo $out
	    reduceViaPCA $file $n $outdir/$out
	done
    done
} 
