catchLispStats(){
    #add all lisp learners here
    local lisplearners="nb-clisp.sh"
    
    #outfile for stats
    local tmp=$Tmp/stats
    local out=stats.csv

    #varibles for weka exp
    local data="$Data/discrete/weather.nominal.arff"
    local learners="nb10"

    #execute lisp code here
    ./$lisplearners > $tmp
    cat $tmp | grep -v ";" >> $out

    rm -rf $tmp

    #execute weka code here
        for dat in $data; do
            goals=`cat $dat | getClasses --brief`;
            for learner in $learners; do
                $learner $dat | gotwant > produced.dat;
                for goal in $goals; do
                    cat produced.dat | 
		    abcd --prefix "`basename $dat`,$learner,$goal" --goal "$goal" --decimals 1 >> $out;
                done;
            done;
	done

	cat $out | malign
	winLossTie --test w --fields 12 --perform 9 --input $out --key 2
}
