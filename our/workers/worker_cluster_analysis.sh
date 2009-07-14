#cluster similarity & purity measures, pass in clusterer and max k to be analyzed (counts in powers of 2)

kmeansGenicSimWorker(){
    local clusterer=$1
    local maxK=$2
    local clusterdir=$3
    local runtimefile=$4
    local outfile=$5

    echo "clusterer,k,dataset,intersim,intrasim,time(sec)" >> $outfile

    for ((k=2;k<$maxK;k*=2)); do
	for file in `ls $clusterdir | grep $clusterer | grep k=$k`; do
	    sims=`$Clusterers -sim $file`
	    intersim=`echo $sims | cut -f 1 -d, | cut -f 2 -d=`
	    intrasim=`echo $sims | cut -f 2 -d, | cut -f 2 -d=`
	    file=`basename $file`
	    file=${file%.*}
	    dataset=""
	    time=""

	    for d in `cat $runtimefile | grep $clusterer,$k | cut -f 3 -d,`; do
		if grep -q $d $file; then
		    dataset=$d
		    time=`cat $runtimefile | grep $clusterer,$k | grep $dataset | cut -f 4 -d,`
		    break
		fi		
	    done

	    out="$clusterer,$k,$dataset,$intersim,$intrasim,$time"
	    echo $out
	    echo $out >> $outfile
	done    
    done
} 

#this is different due to the stored structure of canopy's clusters
canopySimWorker(){
    local clusterer=$1
    local maxK=$2
    local clusterdir=$3
    local runtimefile=$4
    local outfile=$5

    echo "clusterer,k,dataset,intersim,intrasim,time(sec)" >> $outfile

    for ((k=2;k<$maxK;k*=2)); do
	for dir in `ls $clusterdir | grep $clusterer | grep k=$k`; do
	    cd $dir
	    totalintersim=0
	    totalintrasim=0

	    #sum up the similarities
	    for file in `ls $dir`; do
		sims=`$Clusterers -sim $file`
		intersim=`echo $sims | cut -f 1 -d, | cut -f 2 -d=`
		intrasim=`echo $sims | cut -f 2 -d, | cut -f 2 -d=`
		totalintersim=`add $intersim $totalintersim`
		totalintrasim=`add $intrasim $totalintrasim`
	    done

	    dataset=""
	    time=""

	    for d in `cat $runtimefile | grep $clusterer,$k | cut -f 3 -d,`; do
		if grep -q $d $dir; then
		    dataset=$d
		    time=`cat $runtimefile | grep $clusterer,$k | grep $dataset | cut -f 4 -d,`
		    break
		fi		
	    done
	    out="$clusterer,$k,$dataset,$totalintersim,$totalintrasim,$time"
	    echo $out
	    echo $out >> $outfile
	done    
    done
}

kmeansGenicPurityWorker(){
    local clusterer=$1
    local maxK=$2
    local clusterdir=$3
    local runtimefile=$4
    local classfile=$5
    local $outfile=$6

    echo "clusterer,k,dataset,purity,time(sec)" >> $outfile

    for ((k=2;k<$maxK;k*=2)); do
	for file in `ls $clusterdir | grep $clusterer | grep k=$k`; do
	    purity=`$Clusterers -purity $file $classfile`

	    file=`basename $file`
	    file=${file%.*}
	    dataset=""
	    time=""

	    for d in `cat $runtimefile | grep $clusterer,$k | cut -f 3 -d,`; do
		if grep -q $d $file; then
		    dataset=$d
		    time=`cat $runtimefile | grep $clusterer,$k | grep $dataset | cut -f 4 -d,`
		    break
		fi		
	    done

	    out="$clusterer,$k,$dataset,$purity,$time"
	    echo $out
	    echo $out >> $outfile
	done    
    done
} 

canopyPurityWorker(){
    local clusterer=$1
    local maxK=$2
    local clusterdir=$3
    local runtimefile=$4
    local classfile=$5
    local outfile=$6

    echo "clusterer,k,dataset,purity,time(sec)" >> $outfile

    for ((k=2;k<$maxK;k*=2)); do
	for dir in `ls $clusterdir | grep $clusterer | grep k=$k`; do
	    cd $dir
	    totalpurity=0

	     #sum up the purities
	     for file in `ls $dir`; do
	  	purity=`$Clusterers -purity $file $classfile`
	 	totalpurity=`add $purity $totalpurity`
	     done

	     dataset=""
	     time=""

	    for d in `cat $runtimefile | grep $clusterer,$k | cut -f 3 -d,`; do
		if grep -q $d $dir; then
		    dataset=$d
		    time=`cat $runtimefile | grep $clusterer,$k | grep $dataset | cut -f 4 -d,`
		    break
		fi		
	    done
	    out="$clusterer,$k,$dataset,$purity,$time"
	    echo $out
	    echo $out >> $outfile
	done    
    done
}

#gives the ability to add floating point vals
add() (IFS=+; echo "$*" | bc -l)
