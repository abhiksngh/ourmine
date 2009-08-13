discretizeViaFayyadIrani() {
    blab "x"
    $Weka weka.filters.supervised.attribute.Discretize \
		-c last -R first-last  -i $1 -o $Tmp/tmp.arff
    cat $Tmp/tmp.arff
}
logArff() { 
	cat - | gawk -F, '
	BEGIN          { N=split("'$2'",Args,",") 
                     Min='"$1"'
		             OFS=FS=","
			         IGNORECASE=1}
	Data && NF > 1 { logs(N,Args,Min) }
    /@data/        { Data=1 }
                   { print  }
    function logs(n,args,min,    i) {
		for(i=1;i<=n;i++){
		     $i=log($i < min ? min : $i)
                   if($i=="-inf") $i=0
                 }
	}'
} 
caps(){ 
     tr A-Z a-z 
}

tokes(){
     sed 's/[^A-Za-z]/ /g'
}

stops(){
    awk '  {
         for(i=1;i<=NF;i++) {doc[i]=$i; max++}
	 while (getline < "'$1'") stop[$1]=$0;}
         END{for(i=1;i<=max;i++)
                 if(!stop[doc[i]]) printf "%s ", doc[i]
	 }'
}

clean(){
    local docdir=$1
    local out=$2

    for file in $docdir/*; do
        cat $file | 
	tokes | 
	caps | 
	stops $Lists/stops.txt > tmp 
	stems tmp >> $out 
	rm tmp
    done
}

tfidfDocFreqs(){
    
    for file in $1/*; do
	cat $file |
        tokes |
        caps |
        stops $Lists/stops.txt > $Tmp/tmp1
        stems $Tmp/tmp1 |

	awk '{
            for(i=1;i<=NF;i++) freq[$i]++;
              while(getline < "'$2'") tfidfterms[$1]=$0;}
             END{for(term in tfidfterms){
                    if(freq[term]) printf "%s,", freq[term]; 
                    else printf "%s,", 0} 
             }' |
	sed 's/,$//g' >> $Tmp/$3
    done
}
 
stems(){
    perl $Perl/stemming.pl $1;
}

tfidf() { 
    #executes tf*idf computations on specified file
    gawk -f $Awk/tfidf.awk --source ' 
    { train() } 
    END { OFS=","; for(I in Word) print I, tfidf(I) } ' $1 ; 
}  

tfidfByTerm(){
    #computes tf*idf computations based on a specified term
     gawk -f $Awk/tfidf.awk --source ' 
    { train() } 
    END {print tfidf("'$2'") } ' $1 ; 
}   
