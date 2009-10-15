##PUT ME IN YOUR LISP DIRECTORY##

nb-lisp(){
    #must include these for lisp code
    local load="miner"   
    local testfile=$2
    local trainfile=$1  
    local testlisp=test.lisp
    local trainlisp=train.lisp 
    local testfun=`cat $testfile | getDataDefun`  
    local trainfun=`cat $trainfile | getDataDefun` 

    sbcl --noinform --eval '
  (progn (load "'$load'") 
  (print (nb ('$testfun') ('$trainfun')))
  (quit))'  > $Tmp/tmp

  cat $Tmp/tmp | formatGotWant 
}

catchLispStats(){   
    local bins=10

    #outfile for stats
    local tmp=$Tmp/stats
    local out=stats.csv

    #varibles for exp
    local data="$Data/discrete/audiology.arff"
    local learners="nb nb-lisp"

    rm -rf $tmp

     #begin experiment here
        for dat in $data; do
            goals=`cat $dat | getClasses --brief`
	        for bin in $bins; do
		    makeTrainAndTest $dat $bins $bin
		    for learner in $learners; do			
			$learner train.arff test.arff | gotwant > produced.dat		     
			for goal in $goals; do
			    cat produced.dat | 
			    abcd --prefix "`basename $dat`,$learner,$goal" --goal "$goal" >> $out
			done
		    done
		done
	done
	winLossTie --test mw --fields 12 --perform 9 --input $out --key 2
}
