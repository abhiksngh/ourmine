analysis1(){
    local origdata=$1
    local outstats=$2
    local nattrs="2 4 6 8 10 12 14 16 18 20"
    local learners="nb10 j4810 zeror10 oner10 adtree10"
    local reducers="infogain chisquared oneR"
    local tmpred=$Tmp/red

    echo "n,reducer,learner,accuracy" > $outstats

    for n in $nattrs; do
	for reducer in $reducers; do
	    $reducer $origdata $n $tmpred 
	    for learner in $learners; do
		accur=`$learner $tmpred.arff | acc`
		
		
		out="$n,$reducer,$learner,$accur"
		blabln $out
		echo $out >> $outstats
	    done
	done
    done
} 

analysis2(){
    local origdata=$1
    local outstats=$2
    local runs=2
    local bins=10
    local nattrs="40" #"2 4 6 8 10 12 14 16 18 20"
    local learners="nb j48 zeror oner adtree bnet rbfnet"
    local reducers="cfs infogain chisquared oneR"
    local tmpred=$Tmp/red

    (echo "#run,n,reducer,bin,learner,goal,a,b,c,d,acc,pd,pf,prec,bal" 
	for((run=1;run<=$runs;run++)); do	   
	    for n in $nattrs; do
		for reducer in $reducers; do
		    $reducer $origdata $n $tmpred
		    for((bin=1;bin<=$bins;bin++)); do		       
			makeTrainAndTest $tmpred.arff $bins $bin			
			goals=`cat $tmpred.arff | getClasses --brief`
			for learner in $learners; do			    
			    $learner train.arff test.arff | gotwant > result.dat
			    for goal in $goals; do
				cat result.dat | 
				abcd --prefix "$run,$n,$reducer,$bin,$learner,$goal" \
				    --goal "$goal" \
				    --decimals 1
			    done			    
			    blabln "$run,$n,$reducer,$bin,$learner"
			done
		    done
		done
	    done
	done) | malign > $outstats
} 

analysis3(){
    local origdata=$1
    local outstats=$2
    local runs=5
    local bins=5
    local learners="nb j48 zeror oner adtree bnet rbfnet"
    local tmpred=$Tmp/red
    local mfss=`basename $origdata`
    mfss=${mfss%.*}

    (echo "#run,mfss_method,bin,learner,goal,a,b,c,d,acc,pd,pf,prec,bal" 
	for((run=1;run<=$runs;run++)); do	   
	    for((bin=1;bin<=$bins;bin++)); do		       
		makeTrainAndTest $origdata $bins $bin		
		goals=`cat train.arff | getClasses --brief`
		for learner in $learners; do			    
		    $learner train.arff test.arff | gotwant > result.dat
		    for goal in $goals; do
			cat result.dat | 
			abcd --prefix "$run,$mfss,$bin,$learner,$goal" \
			    --goal "$goal" \
			    --decimals 1
		    done			    
		    blabln "$run,$mfss,$bin,$learner"
		done
	    done
	done) | malign > $outstats
} 

mfssAnalysis(){
    local mfssDir=$1
     
    for file in `ls $mfssDir`; do
    	mfss=`basename $file`
    	mfss=${mfss%.*}_STATS.csv
    	analysis3 $mfssDir$file $Save/$mfss
     done
}
