#workers used to cluster with varying k and datasets, and then analyze

#split up the k to run across multiple machines using minkK and maxK
clusterKmeansWorker(){
    local minK=$1
    local maxK=$2
    local incVal=$3
    local dataDir=$4
    local stats="clusterer,k,dataset,time(seconds)"
    local statsfile=$Save/kmeans_runtimes
    echo $stats >> $statsfile

    for((k=$minK;k<=$maxK;k+=$incVal)); do
	for file in $dataDir/*.arff; do
	    filename=`basename $file`
	    filename=${filename%.*}
	    out=kmeans_k="$k"_$filename.arff 
	    echo $out
	    start=$(date +%s.%N)
	    $Clusterers -k $k $file $Save/$out
	    end=$(date +%s.%N)
	    time=$(echo "$end - $start" | bc)
	    echo "kmeans,$k,$filename,$time" >> $statsfile
	done
    done
}

clusterGenicWorker(){
    local minK=$1
    local maxK=$2
    local incVal=$3
    local dataDir=$4
    local stats="clusterer,k,dataset,time(seconds)"
    local statsfile=$Save/genic_runtimes
    echo $stats >> $statsfile

    for((k=$minK;k<=$maxK;k+=$incVal)); do
	for file in $dataDir/*.arff; do
	    filename=`basename $file`
	    filename=${filename%.*}
	    out=genic_k="$k"_$filename.arff 
	    echo $out
	    start=$(date +%s.%N)
	    $Clusterers -g $k 15 $file $Save/$out
	    end=$(date +%s.%N)
	    time=$(echo "$end - $start" | bc)
	    echo "genic,$k,$filename,$time" >> $statsfile
	done
    done
}

#this is handled a bit differently, as each canopy's clusters are stored seperately
clusterCanopyWorker(){
    local minK=$1
    local maxK=$2
    local incVal=$3
    local dataDir=$4
    local stats="clusterer,k,dataset,time(seconds)"
    local statsfile=$Save/canopy_runtimes

    echo $stats >> $statsfile
    
    for((k=$minK;k<=$maxK;k+=$incVal)); do
	for file in $dataDir/*.arff; do
	    filename=`basename $file`
	    filename=${filename%.*}
	    clustdir=$Save/canopy_k="$k"_$filename
	    mkdir -p $clustdir
	    cd $clustdir
	    out=canopy_k="$k"_$filename.arff 
	    echo $out
	    start=$(date +%s.%N)
	    $Clusterers -c $k 10 25 $file $out
	    end=$(date +%s.%N)
	    time=$(echo "$end - $start" | bc)
	    echo "canopy,$k,$filename,$time" >> $statsfile
	done
    done
}
