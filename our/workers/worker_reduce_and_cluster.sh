pcaKmeansWorker(){
    
    local datadir=$1
    local minN=$2
    local maxN=$3
    local minK=$4
    local maxK=$5
    local incVal=$6
    local outdir=$7
    local outClusterDir=$8
    local runtimes=$outdir/pca_runtimes

    reduceWorkerPCA $datadir $minN $maxN $incVal $Save/$outdir
    clusterKmeansWorker $minK $maxK $incVal $Save/$outdir    
} 


pcaGenicWorker(){
    
    local datadir=$1
    local minN=$2
    local maxN=$3
    local minK=$4
    local maxK=$5
    local incVal=$6
    local outdir=$7
    local outClusterDir=$8
    local runtimes=$outdir/pca_runtimes

    reduceWorkerPCA $datadir $minN $maxN $incVal $Save/$outdir
    clusterGenicWorker $minK $maxK $incVal $Save/$outdir 
} 

