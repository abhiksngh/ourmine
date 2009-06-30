# ----------------- LEARNERS-----------------

# naive bayes
demo001() {
    
    local train=$Data/discrete/weather.arff
    nb10 $train
}

# j48
demo002() {
    
    local train=$Data/discrete/weather.arff
    j4810 $train
}

# j48 + extraction
demo003() {
    local train=$Data/discrete/weather.arff
    demo002 | para 18 16
}

# logs
demo004() {
	for i in $Data/numeric/*; do
		echo $i
		cat $i | logArff 0.0001 "1,2,3,4" > $Tmp/`basename $i`
		cat $Tmp/`basename $i`
	done
}

# run learner/discretizer on all data
demo005worker() {
	local what
	local learner=$1
	local report=$2
	for i in $Data/discrete/*; do 
		what=`basename $i`
 		what=${what%.*}
		(
		echo -n "$what $learner raw "
		$learner $i | para 1 $report 

		echo -n "$what $learner discrete " 
		discretizeViaFayyadIrani $i > $Tmp/tmp.arff
		$learner $Tmp/tmp.arff | para 1 $report 

		echo ""
		) | gawk '{gsub(/[ \t]+/,","); print}' | sort -t, -n -k 7
	done 
}
demo005() {
	(echo ""
	echo "#data,learner,rx,TPrate,FPrate,Precision,Recall,F-Measure,ROCarea,class"
	demo005worker j4810 10
	demo005worker nb10  -3
	) |
	malign 
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
    local clusterers="kmeans em"
    local numclusters=3
    local numattrs=50  
    
    #first, create sparse arff from docs
    docsToSparff $Docs $sparff

    #reduce using tf-idf, using top N attrs
    docsToTfidfSparff $Docs $numattrs $Tmp/tmp2

    #reduce using PCA, using top N attrs
    reduceViaPCA $sparff $numattrs $Tmp/tmp3

    #clusterer with N clusters
    for clusterer in $clusterers; do 
	$clusterer $Tmp/tmp2.arff $numclusters 
	$clusterer $Tmp/tmp3.arff $numclusters 
    done
}


