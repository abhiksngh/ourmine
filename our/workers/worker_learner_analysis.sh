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
