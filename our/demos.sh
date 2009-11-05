# ----------------- LEARNERS-----------------
#cats the first used dataset
demo000(){
    cat $Data/discrete/weather.arff;
}

# naive bayes
demo001() {
    local train=$Data/discrete/iris.arff
    nb10 $train
}

# j48
demo002() {
    local train=$Data/discrete/weather.arff
    j4810 $train
}

# j48 + extraction
demo003() {
    demo002 | para 18 16
}

demo004(){
    local out=$Save/demo004-results.csv
    [ -f $out ] && echo "Caution: File exists!" || demo004worker $out  
}

# run learners and perform analysis
demo004worker(){

    local learners="nb j48"
    local data="$Data/discrete/iris.arff"
    local bins=10
    local runs=5
    local out=$1
    
    cd $Tmp
    (echo "#data,run,bin,learner,goal,a,b,c,d,acc,pd,pf,prec,bal"
	for((run=1;run<=$runs;run++)); do
	    for dat in $data; do
		
		blab "data=`basename $dat`,run=$run" 
		for((bin=1;bin<=$bins;bin++)); do
		    
		    rm -rf test.lisp test.arff train.lisp train.arff
		    makeTrainAndTest $dat $bins $bin 
		    goals=`cat $dat | getClasses --brief`
		    
		    for learner in $learners; do
			$learner train.arff test.arff | gotwant > produced.dat
			extractGoals goal "`basename $dat`,$run,$bin,$learner,$goal" `pwd`/produced.dat
		    done
		done
		blabln
	    done
	done | sort -t, -r -n -k 11,11) | malign  > $out
    
    #perform wilcoxon test on the ouput, perform=pd, key=learner
    winLossTie --input $out --test w --fields 14 --key 4 --perform 11 
}



#------------------CLUSTERERS----------------------

# kmeans, using K centroids
demo006() {
    local k=4
    kmeans $Data/numeric/bolts.arff $k
}

# kmeans, using K centroids +  extraction
demo007() {
    demo006 | para 1 -3
}

# worker, finds log likelihoods
demo008worker() {
    local k=$1
    for f in $Data/numeric/*; do
	dat=`basename $f`
	dat=${dat%.*}
	echo -n "$dat,$k,"
	em $f $k | grep "Log likelihood" | cut -d: -f2
    done
}

demo008 () {
    (echo "data,k,log likelihood"
    demo008worker 4 ) | malign  
}


#---------------FEATURE SUBSET SELECTION-------------------

# rank attributes via infogain, using N attributes
demo009() {
    local n=3
    (rankViaInfoGain $Data/discrete/weather.arff $n $Tmp/tmp;
    cat $Tmp/tmp.arff | grep @attribute | cut -d" "  -f2 ) | malign
}

# reduce via PCA, using N attributes
demo010() {
    local n=3
    reduceViaPCA $Data/discrete/weather.arff $n $Tmp/tmp;
    cat $Tmp/tmp.arff
}

#------------------PREPROCESSING--------------------

#tokenization
demo011() {
    echo "I REALLY @*%#^#@ like Ourmine...." | tokes
}

#tokenization + caps
demo012() {
    demo011 | caps
}

#tokenization + caps + stoplists
demo013() {
    demo012 | stops $Lists/stops.txt
}

#tokenization + caps + stoplists + stemming
demo014() {
    demo013 | stems
}

#clean with tokenization, stoplists, stemming, etc. on all docs
demo015(){
    local out=$Tmp/tmp.txt
    for i in $Docs/*; do
	cat $i | 
	tokes | 
	caps | 
	stops $Lists/stops.txt > $out | 
	stems $out;
	echo " "; echo "$i";
	cat $out;
    done
}

#clean all docs, and produce doc out file
demo016() {
    rm -rf $Tmp/tmp;
    clean $Docs $Tmp/tmp;
    cat $Tmp/tmp
}

#tf*idf using top 100 terms 
demo017(){
    rm -rf $Tmp/tmp;
    clean $Docs $Tmp/tmp;
    tfidf $Tmp/tmp | sort -t, -k2,2 -r | cut -f1 -d, | head -100
}

#-------------------TEXT MINING--------------------

#produce sparse arff file from all documents
demo018(){
    rm -rf $Tmp/tmp
    docsToSparff $Docs $Tmp/tmp
    cat $Tmp/tmp.arff
}

#produce sparse arff file using tf-idf values from all docs, and N top attributes
demo019(){
    local n=50
    rm -rf $Tmp/tmp
    docsToTfidfSparff $Docs $n $Tmp/tmp
    cat $Tmp/tmp.arff
}

#reduce using PCA and Tf*Idf and cluster
demo020(){
    
    local sparff=$Tmp/tmp1
    local numclusters=3
    local numattrs=15  
    
    #first, create sparse arff from docs
    docsToSparff $Docs $sparff

    #reduce using tf-idf, using top N attrs
    docsToTfidfSparff $Docs $numattrs $Tmp/tmp2

    #reduce using PCA, using top N attrs
    reduceViaPCA $sparff.arff $numattrs $Tmp/tmp3

    #kmeans
    $Clusterers -k $numclusters $Tmp/tmp2.arff $Tmp/k_tmp2_$numclusters.arff
    $Clusterers -k $numclusters $Tmp/tmp3.arff $Tmp/k_tmp3_$numclusters.arff

    #genic
    $Clusterers -g $numclusters 15 $Tmp/tmp2.arff $Tmp/g_tmp2_$numclusters.arff
    $Clusterers -g $numclusters 15 $Tmp/tmp3.arff $Tmp/g_tmp3_$numclusters.arff
}

rundemos(){
     local demo="demo000 demo001 demo002 demo006 demo007 demo009 demo010"
     for d in $demo; do
	 blabln About to run $d. Press Enter to continue, or Control-C to quit.
	 read && $d; 
     done
}
