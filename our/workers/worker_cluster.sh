#workers used to cluster with varying k and datasets, and then analyze

#split up the k to run across multiple machines
clusterKmeansWorker1(){
    local kay="2 4 8 16 32"
    local stats="clusterer,k,dataset,time(seconds)"
    local statsfile=$Save/kmeans_runtimes
    echo $stats >> $statsfile

    for k in $kay; do
	for file in $Data/sparse/*; do
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

clusterKmeansWorker2(){
    local kay="64 128 256"
    local stats="clusterer,k,dataset,time(seconds)"
    local statsfile=$Save/kmeans_runtimes
    echo $stats >> $statsfile

    for k in $kay; do
	for file in $Data/sparse/*; do
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
    local kay="2 4 8 16 32 64 128"
    local stats="clusterer,k,dataset,time(seconds)"
    local statsfile=$Save/genic_runtimes
    echo $stats >> $statsfile

    for k in $kay; do
	for file in $Data/sparse/*; do
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
    local kay="2 4 8 16 32 64 128"
    local stats="clusterer,k,dataset,time(seconds)"
    local statsfile=$Save/canopy_runtimes
    local clustdir=$Save/canopy_clusters

    echo $stats >> $statsfile
    mkdir -p $clustdir
    cd $clustdir

    for k in $kay; do
	for file in $Data/sparse/*; do
	    filename=`basename $file`
	    filename=${filename%.*}
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

clusterAll(){
	clusterKmeansWorker1
	clusterKmeansWorker2
	clusterGenicWorker
	clusterCanopyWorker
}
