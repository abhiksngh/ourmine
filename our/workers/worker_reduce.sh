#workers for dimensionality reduction, n=number of desired attributes, increase by inc val

reduceWorkerTfidf(){
    local datadir=$1
    local minN=$2
    local maxN=$3
    local incVal=$4
    local outdir=$5
    local runtimes=$outdir/tfidf_runtimes

    echo "reducer,n,dataset,time" > $runtimes

    for((n=$minN;n<=$maxN;n+=$incVal)); do
	for file in $datadir/*.arff; do
	    out=`basename $file`
	    out=${out%.*}
	    dataset=$out
	    out=tfidf_n="$n"_$out.arff
	    echo $out
	    start=$(date +%s)
	    $Reducers -tfidf $file $n $outdir/$out
	    end=$(date +%s)
	    time=$((end - start))
	    echo "tfidf,$n,$dataset,$time"
	done
    done
} 

reduceWorkerPCA(){
    local datadir=$1
    local minN=$2
    local maxN=$3
    local incVal=$4
    local outdir=$5
    local runtimes=$outdir/pca_runtimes

    echo "reducer,n,dataset,time" > $runtimes

    for((n=$minN;n<=$maxN;n+=$incVal)); do
	for file in $datadir/*.arff; do 
	    out=`basename $file`
	    out=${out%.*}
	    dataset=$out
	    out=pca_n="$n"_$out.arff
	    echo $out
	    start=$(date +%s)
	    reduceViaPCA $file $n $outdir/$out
	    end=$(date +%s)
	    time=$((end - start))
	    echo "pca,$n,$dataset,$time"	   
	done
    done
} 
