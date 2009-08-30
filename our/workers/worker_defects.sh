promiseDefectFilterExp(){

local learners="nb"
local datanames="KC1 CM1 KC1 KC2 KC3 MC2 MW1 PC1"
local bins=10
local runs=10
local out=$Save/defects.csv

cd $Tmp
(echo "#data,run,bin,treatment,learner,goal,a,b,c,d,acc,pd,pf,prec,bal"
for((run=1;run<=$runs;run++)); do
    for dat in $datanames; do

	combined=$Data/promise/combined_$dat.arff
	shared=$Data/promise/shared_$dat.arff

	blabln "data=$dat run=$run" 
	for((bin=1;bin<=$bins;bin++)); do

	    rm -rf test.lisp test.arff train.lisp train.arff

	    cat $shared | 
	    logArff 0.0001 "1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19" > logged.arff
	    makeTrainAndTest logged.arff $bins $bin
	    goals=`cat $shared | getClasses --brief`

	    mv test.arff test_shared.arff; mv train.arff train_shared.arff;
	    
	    for learner in $learners; do
                
		#learn on within-company data
		blabln "WC"
		$learner train_shared.arff test_shared.arff | gotwant > produced.dat
		for goal in $goals; do
		    cat produced.dat | 
		    abcd --prefix "$dat,$run,$bin,WC,$learner,$goal" \
			 --goal "$goal" \
			 --decimals 1
		done

		#learn on filtered within-company data
		blabln "WCkNN"
		rm -rf knn.arff
		$Clusterers -knn 10 test_shared.arff train_shared.arff knn.arff
		#java -jar $Java/KNN.jar test_shared.arff train_shared.arff 10 > knn.arff
		$learner knn.arff test_shared.arff | gotwant > produced.dat
		for goal in $goals; do
		    cat produced.dat |
		    abcd --prefix "$dat,$run,$bin,WkNN,$learner,$goal" \
			--goal "$goal" \
			--decimals 1  
		done

                
		#learn on cross-company data
		blabln "CC"
		makeTrainCombined $combined > com.arff	
		cat com.arff |
		logArff 0.0001 "1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19" > logged.arff
		$learner logged.arff test_shared.arff | gotwant > produced.dat
		for goal in $goals; do
		    cat produced.dat |
		    abcd --prefix "$dat,$run,$bin,CC,$learner,$goal" \
			--goal "$goal" \
			--decimals 1
		done

		#learn on filtered cross-company data
		blabln "CkNN"
		rm -rf knn.arff
		makeTrainCombined $combined > com.arff	
		cat com.arff |
		logArff 0.0001 "1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19" > logged.arff
		$Clusterers -knn 10 test_shared.arff logged.arff knn.arff
		#java -jar $Java/KNN.jar test_shared.arff logged.arff 10 > knn.arff
		$learner knn.arff test_shared.arff | gotwant > produced.dat
		for goal in $goals; do
		    cat produced.dat |
		    abcd --prefix "$dat,$run,$bin,CkNN,$learner,$goal" \
			--goal "$goal" \
		        --decimals 1
		done
	    done
	done
	blabln
    done
done ) | malign | sort -t, -r -n -k 12,12 > $out

less $out
} 


#written by greg gay
makeTrainCombined(){
	gawk -v F=$1 -v Seed=$RANDOM 'BEGIN{
		numDef=0
		numN=0
		srand(Seed);

		while(getline x < F){
			if((x !~ /^[ \t]*$/)&&(x !~ /@attribute/)&&(x !~ /@data/)&&(x!="")&&(x !~ /@relation/)&&(x !~ /^%/)) {
                                 if((x ~ /true/)||(x ~ /TRUE/)){
					def[numDef]=x
					numDef++
				}
				else if((x ~ /false/)||(x ~ /FALSE/)){
					nondef[numN]=x
					numN++
				}
                        }
                        else
                        	print x

		}
		close(F);

		allowedD = round(numDef*0.9);
		allowedN = round(numN*0.9);

		while(allowedD>0 || allowedN >0){
			r=int(rand()*1000);
			if((r%2==0)&&(allowedD>0)){
				d=int(numDef*rand());

				if(def[d] !~ /used/){
					print def[d];
					def[d]="used";
					allowedD--;
				}
			}
			else if(allowedN>0){
				d=int(numN*rand());

				if(nondef[d] !~ /used/){
					print nondef[d];
					nondef[d]="used";
					allowedN--;
				}
			}
		}
	}

  function round(x,   ival, aval, fraction)
     {
        ival = int(x)    # integer part, int() truncates
     
        # see if fractional part
        if (ival == x)   # no fraction
           return x
     
        if (x < 0) {
           aval = -x     # absolute value
           ival = int(aval)
           fraction = aval - ival
           if (fraction >= .5)
              return int(x) - 1   # -2.5 --> -3
           else
              return int(x)       # -2.3 --> -2
        } else {
           fraction = x - ival
           if (fraction >= .5)
              return ival + 1
           else
              return ival
        }
     }'
}