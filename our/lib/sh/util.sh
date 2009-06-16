reset()  { cd $Here; . lib/sh/minerc.sh; }
blab()   { printf "$*"   >&2; }
blabln() { printf "$*\n" >&2; }

show() {
	local goal1="^$1"
	local com="/^$1 /,/^}/{print}"
	if   (set | grep $goal1 | grep "=" > /tmp/debug)
   	then set  | grep $goal1
   	else set  | gawk "$com"
   	fi
}

para() { 
	cat - |
	gawk  'BEGIN { Want='$2'
                   RS=""; FS="\n"} 
		         { R[++N]=indent($0) } 
           END   { print " "; 
		           if (Want < 0) Want= N + 1 + Want;
				   print R[Want];
				 }
           function indent(str, i, out) {
           		for(i=1;i<=NF;i++)
           			out=out str('$1'," ")  $i "\n"
           		return out
           }
		   function str(n,c,  out) { 
				while(--n > 0) out = out c; return out; }	
           '
} 
malign() {
	cat - | gawk '
	BEGIN { Width=1;
	        Gutter=1;
			OFS=FS=",";
	}		 
	{ N++;  
	  for(I=1;I<=NF;I++) {
			if( (L=length($I)) > Max[I]) Max[I]=L;
			++Data[N,0];
			Data[N,I]=$I; }
	}
	END {for(J=1;J<=N;J++) {
			Str=Sep1="";
			if (Data[J,0]>1) {  
				for(I=1;I<=NF;I++) {
					L=length(Data[J,I]);
					Str = Str Sep1 \
					      str(most(Width,Max[I]+Gutter+1)-L," ") \
						  Data[J,I];
					Sep1= OFS;
				}} 
			else {Str=Data[J,1]}
		  print Str;}
	}
	function str(n,c,  out) { while(--n > 0) out = out c; return out; }	
    function most(x,y)      { return x > y ? x : y; }  
	' 
}

medians()    { 
	local start="2"
    while [ `echo $1 | grep "-"` ]; do
       case $1 in
		   	-s|--start) start=$2;;
			*)           blabln "'"$1"' unknown\n usage medians [options]"; 
				         return 1;;
       esac
       shift 2
    done
	gawk '
	BEGIN{FS=","}
	     {print}
	/^[ \t]*$/ {next}	 
	/#/  {next}
	     {for(I=Start;I<=NF;I++) {
			(Data[I,0]++); Data[I,Data[I,0]]=$I }
		 }
	END{ #printf("#---")
	     #for(I=Start;I<=NF;I++) 
		 #   printf(",-----")
		 #print ""
		 printf("##");
		 printf $1
		 for(I=2;I<Start;I++) 
			 printf ","$I
		 for(I=Start;I<=NF;I++) {
			    Max=Data[I,0];
			    delete Val
			    N=0;
			    for(J=1;J<=Max;J++) 
				     Val[J]  = Data[I,J]
				asort(Val);
				if(Max % 2 ) { printf(",%s",Val[int(Max/2)]) }
			    else        { below=Val[int(Max/2)];
					          above=Val[int(Max/2) + 1];
					          printf(",%s",(below+above)/2)
						    }
			}
		   print ""
		}' Start=$start -
}
quartile() {
        gawk '
BEGIN { FS = OFS = ","; # #
        Shrink = 2; #
        Left   = -100;
        Right  = 100; #
        Off    = " "; #
        Max = "]"; #
        Min = "["; #
        Median = "|"; #
                Low ="-";
                High = "+";
        F      = "5.1f" #
                #Header = "min,q1,median,q3,max,"
}
        {  S[++N]=$1 }
END {asort(S); if(Header) print Header;report(S,N)}
function round(x)      { return int(x<0 ? x-0.5 : x+0.5) }
function report(s,n,     min,q1,median,q3,max,kludge) {
  min   = s[1];
  q1    = s[int(n/4)];
  median= s[int(2*n/4)];
  q3    = s[int(3*n/4)];
  max   = s[n];
  printf("%"F",%"F",%"F",%"F",%"F",%s\n",
         min,q1,median,q3,max,
         quart(min,q1,median,q3,max,Right,Shrink)) | "sort -t, -r -n -k 2,2"
}
function quart(min,q1,median,q3,max,width, scale,  i,l,str) {
        width  /= scale
        min    /= scale
        q1     /= scale
        median /= scale
        q3     /= scale
        max    /= scale
        for(i=  1; i<=width; i++) l[int(i)]= Off;
        for(i=min;    i<=q1; i++) l[int(i)]= Low;
        for(i= q3;   i<=max; i++) l[int(i)]= High;
        l[int(median)] = Median
        for(i= 1; i<=width; i++) str = str l[int(i)];
        return Min str Max
}

' -
}

docsToSparff(){

    local docdir=$1
    local sparff=$2.arff
    local out=$Tmp/tmpdoc
    
    echo "@relation ${sparff}" > $sparff

    #produce doc file
    clean $docdir $out

    #computations for sparff
    cat $out |
    awk '{
for(i=1;i<=NF;i++) freq[$i]++;
for(i=1;i<=NR;i++) doc[$0]=i}
END{OFS=","; 
for(term in freq) print "@attribute "  term  " numeric";

print "@data"
for(d in doc) {
   printf "{" ;
   termnum=0;
   first=1;
   for(term in freq) {
      if(match(d,term)) {
        if(first) printf "%d %d.0", termnum, freq[term];
        else printf ",%d %d.0", termnum , freq[term];
        first=0;
       }
       termnum++;
   }
       printf "}\n";
       termnum=0;
}
}' >> $sparff

    rm -rf $out
}

docsToTfidfSparff(){
    
    local docdir=$1
    local attrs=$2
    local sparff=$3.arff
    local out=$Tmp/tmpdoc1
    local tfidfout=$Tmp/tmpdoc2
    
    echo "@relation ${sparff}" > $sparff

    #produce doc file
    clean $docdir $out 

    #product a list of our top tf-idf words
    tfidf $out | sort -t, -k2,2 -r -g | cut -d, -f1 | head -$attrs > $tfidfout

    #computations for sparff
    cat $out |
    gawk -f $Awk/tfidf.awk --source '{
train(); 
for(i=1;i<=NF;i++) freq[$i]++;
for(i=1;i<=NR;i++) doc[$0]=i;
while(getline < "'$tfidfout'") tfout[$1]=$0}
END{
for(term in tfout) print "@attribute "  term  " numeric";
print "@data";
printDoc(doc,freq,tfout);}

function printDoc(doc,freq,tfout){
    for(d in doc) {
	    printf "{" ;
	    termnum=0;
	    first=1;
	    numterms=0;
        
	    for(term in tfout) {
		 if(match(d,term)){
		       df[term]=freq[term]; 
		       numterms++
		     }
	    }
	
	    for(term in tfout){
		if(df[term]){
		     if(first) 
			 printf "%d %f", termnum, df[term]/numterms*idf(term);
		     else 
			 printf ",%d %f", termnum , df[term]/numterms*idf(term);
		     first=0;
		}
		termnum++;
	    }
			
	   for(t in df) {delete df[t]}
	   printf "}\n";
	   termnum=0;}
	}' >> $sparff
    rm -rf $out $tfidfout
}

predictionToSparff() {
   local orig=$1
   local predfile=$2
   local out=$3

   cat $orig | grep @attribute > $Tmp/attrs
   cat $predfile | 
   awk '{for(i=1;i<=NR;i++) arr[$2]=$2}END{for(s in arr) if(s >= 0) printf "Cluster%s,",s}' |
   sed 's/^/@attribute Cluster {/g' | 
   sed 's/Cluster {,/Cluster {/g' |
   sed 's/,$/}/g' >> $Tmp/attrs
   
   cat $Tmp/attrs 
   echo "@data"

   cat $orig | grep "{" | 
   awk '{while(getline<"'$predfile'") cl[$1]=$2;
         gsub("}", ",Cluster" cl[cnt] "}")
         cnt++;
         print
       }'
}

