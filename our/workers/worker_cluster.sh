#workers used to cluster with varying k and datasets, and then analyze

clusterKmeansWorker(){
    local kay="2 4 8 16 32 64 128"
    local stats="clusterer,k,dataset,time(minutes)"
    local statsfile=$Save/kmeans_runtimes
    echo $stats >> $statsfile

    for k in $kay; do
	for file in $Data/sparse/*; do
	    filename=`basename $file`
	    filename=${filename%.*}
	    out=kmeans_k="$k"_$filename.arff 
	    echo $out
	    start=$(date +%M)
	    $Clusterers -k $k $file $Save/$out
	    end=$(date +%M)
	    echo "kmeans,$k,$filename,$((end - start))" >> $statsfile
	done
    done
}

clusterGenicWorker(){
    local kay="2 4 8 16 32 64 128"
    local stats="clusterer,k,dataset,time(minutes)"
    local statsfile=$Save/genic_runtimes
    echo $stats >> $statsfile

    for k in $kay; do
	for file in $Data/sparse/*; do
	    filename=`basename $file`
	    filename=${filename%.*}
	    out=genic_k="$k"_$filename.arff 
	    echo $out
	    start=$(date +%M)
	    $Clusterers -g $k 15 $file $Save/$out
	    end=$(date +%M)
	    echo "genic,$k,$filename,$((end - start))" >> $statsfile
	done
    done
}

#this is handled a bit differently, as each canopy's clusters are stored seperately
clusterCanopyWorker(){
    local kay="2 4 8 16 32 64 128"
    local stats="clusterer,k,dataset,time(minutes)"
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
	    start=$(date +%M)
	    $Clusterers -c $k 10 25 $file $out
	    end=$(date +%M)
	    echo "canopy,$k,$filename,$((end - start))" >> $statsfile
	done
    done
}

clusterAll(){
	clusterKmeansWorker
	clusterGenicWorker
	clusterCanopyWorker
}
