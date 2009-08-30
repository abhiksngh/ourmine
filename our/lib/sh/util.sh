reload()  { cd $Here; . $OurMine/lib/sh/minerc.sh; }
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

funs() {
    cat $Base/lib/sh/* $Base/workers/* | 
    awk '/\(\)[ \t\n]*{/' | 
    sed 's/[^A-Za-z|0-9]/ /g' | 
    cut -d" " -f 1 | 
    sort
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

gotwant()    {  gawk '
	BEGIN   {Unlog  = 0; 
			 OFS    = ","       
 			 Ee     = 848456353 / 312129649;
            }
    NF == 3 { if (UnLog) { print Ee^$2 , Ee^$3   
			  } else     { print $2,$3 }
           }
    NF == 4    { print $2 , $4 }
' -
}

abcd() {
	local goal="true|yes"
	local before=""
	local prefix=""
	local decimals=2
    while [ `echo $1 | grep "-"` ]; do
       case $1 in
		   	-d|--decimals) decimals=$2;;
		   	-b|--before) before=$2;;
		   	-p|--prefix) prefix=$2;;
		   	-g|--goal)   goal=$2;;
			*)           blabln "'"$1"' unknown\n usage abcd [options]"; 
				         return 1;;
       esac
       shift 2
    done
	[  -n "$before" ] && printf $before
	gawk '
	BEGIN { 
	     Decimals    = 3
	     Got         = 1
	     Want        = 2;
		 Prefix      = "";
	     True        = "true";  ## define symbol 1
         A=B=C=D=0 ; 
	     FS=OFS=","
		 GoalPd = 1;
		 GoalPf = 0;
       }
	function yes(s) {return s ~ True   }
	function no(s)  {return ( yes(s) ? 0 : 1 ) }
	           { sub(/#.*/,"") }
	/^[ \t]*$/ { next }
	NF==2      { N++;
	             Predicted=$Got;
	             Actual=$Want;
				 if (Predicted == Actual) Good++;
	             if (no( Actual) && no( Predicted)) A++;
	             if (yes(Actual) && no( Predicted)) B++;
	             if (no( Actual) && yes(Predicted)) C++;
	             if (yes(Actual) && yes(Predicted)) D++;
				#print N,$0,A,B,C,D
	           }
	END  { 
		OFMT        = "%." Decimals "f";
		Balance=Precision=Accuracy=Pf=NotPf=Pd=0;
		if (C+D > 0 )      Precision = D/(C+D);
		if ((A+B+C+D) > 0)  Accuracy  = (A+D)/(A+B+C+D);
		if (A+C > 0 )      Pf       = C/(A+C)
		if (B+D > 0 )      Pd        = D/(B+D);
		if (B+C+D > 0)     { # special case- everything misses
			 Balance = 1 - sqrt((GoalPd - Pd)^2 + (GoalPf - Pf)^2)/sqrt(2)
        }
		if(Prefix) printf Txt=Prefix OFS;
		print A,B,C,D,
		      sprintf(OFMT,100*Accuracy),
			  sprintf(OFMT,100*Pd),
			  sprintf(OFMT,100*Pf),
			  sprintf(OFMT,100*Precision),
			  sprintf(OFMT,100*Balance);
	}' Prefix="$prefix" Decimals="$decimals" True="$goal" -
}

getClasses() { 
	local brief=0
	while [ `echo $1 | grep "-"` ]; do
		case $1 in
			-b|--brief) brief=1;;
			*)   blabln "'"$1"' unknown\n usage cat file | getClasses [options]"
			     return 1;;
    	esac
		shift 1
	done
	gawk '
   BEGIN      { OFS=FS=","
                IGNORECASE=1 
		        Brief=0	}
              { gsub(/#.*/,"") } 
   /^[ \t]*$/ { next          } 
   Data  && NF > 1     { Freq[$NF]++ }
   /@data/    { Data=1 } 
   END        {
  				 for(N in Freq) 
					 if (Brief) { print N } else { print Freq[N],N }}
   ' Brief=$brief - 
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

winLossTie() {
	local fields=10
	local key=1
    local performance=$fields
    local high=1
    local confidence=95
	local input="-"	
	while [ `echo $1 | grep "-"` ]; do
		case $1 in
			-f|--fields)  fields=$2;      shift 2;;
			--99)         confidence=99;  shift 1;;
			--95)         confidence=95;  shift 1;;
			-k|--key)     key=$2;         shift 2;;
			-p|--perform) performance=$2; shift 2;;
			--high)       high=1;         shift 1;;
			--low)        high=0;         shift 1;;
			-i|--input)   input=$2;       shift 2;;
			*)   blabln "'"$1"' unknown\n. usage: winLossTie [options]"
			     return 1;;
    	esac
	done
	(echo "#key,ties,win,loss,win-loss"
	gawk -f mwu.awk Fields=$fields Key=$key Performance=$performance \
	                High=$high Confidence=$confidence $input |
	sort -t, -r -n -k 5,5
	) | malign

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

makeTrainAndTest(){
    local origArff=$1
    local bins=$2
    local bin=$3
    local seed=$RANDOM

    #to be used for the lisp function name
    local arffName=`basename $origArff`
    arffName=${arffName%.*}
    ignoreArffComments $origArff | 
    gawk '
	BEGIN  { 
        IGNORECASE=1;
      Trainf="train.arff"; Testf="test.arff";
      Trainfl="train.lisp"; Testfl="test.lisp";
      Bins=3; 
      Bin=2; 
      Seed=1;
      numattrs=0;
   } 
   /^[ \t]*$/             { next }
   /@attribute.*numeric$/ { numeric[numattrs]=1 }
   /@attribute.*real$/    { numeric[numattrs]=1 }
   /@attribute/           { Attrs[numattrs]=$2; numattrs++ }
   /@relation/            { Seed ? srand(Seed) : srand(1)      }
   /@relation/            { printf "">Trainf;  printf "">Testf }
   /@relation/,/@data/    { print $0 >> Trainf;  print $0 >> Testf; next }
                          { Line[rand()] = $0; Lines++ }
  END {
     ###print Seed 
    Bins="'$bins'"
    Bin="'$bin'"
    Start = Lines/Bins * (Bin - 1) ;
    Stop  = Lines/Bins * Bin;

    ###set up lisp file, uses ascii values
    attrstring="";
    defun="(defun '$arffName' ()\n\t(data\n\t\t:name \x27" "'$arffName'\n";
    cols="\t\t:columns \x27" "(";
    for(i=0;i<numattrs;i++) {
      if(numeric[i]) attrstring=attrstring " $" Attrs[i] "";
      else attrstring=attrstring " " Attrs[i] "";
    }
    egs=")\n\t\t:egs\n\t\t\x27(\t\t\t";
    setup=defun "" cols "" attrstring "" egs;

    print setup>>Trainfl;
    print setup>>Testfl;
    
    ###print to lisp file

    lispinst="";
   
    for(I in Line) {
       N++;
       What = (N>= Start && N < Stop) ? Testf : Trainf
       Lisp = (N>= Start && N < Stop) ? Testfl : Trainfl
       print Line[I]>>What;      
       split(Line[I],lispAttrs,",");

      lispinst="\t\t\t(";
      for(i=0;i<=numattrs;i++) lispinst=lispinst "" lispAttrs[i] " "
      lispinst=lispinst "" ")"
      print lispinst>>Lisp;
    }

   finish="\t\t\t)))";
   print finish>>Trainfl
   print finish>>Testfl

   }
   ' Seed=$seed -
}

ignoreArffComments(){
    cat $1 | awk '!/^%/ {print}'
}

help(){

    local function=$1
    local helpfile
    local tmphelpfile
    local code

    function=`echo $function | tr A-Z a-z`
    helpfile=$Help/$function
    tmphelpfile=~/tmp/helpfile

    [ -f $helpfile ] && cat $helpfile | parseHelpFile > $tmphelpfile
    
    code=`show $function`
    
    echo -e "\nFunction Code:\n==============\n $code" >> $tmphelpfile
    less $tmphelpfile
    rm -rf $tmphelpfile
}

parseHelpFile(){
    awk 'BEGIN{FS=":"}
         /name:/ {print "Function: " $2}
         /args:/ {print "Arguments: " $2}
         /eg:/   {print "Example(s): " $2}
         /desc:/ {print "Description: " $2}'
}

#some arithmetic operations functions
div() (IFS=/; echo "$*" | bc -l)
mult() (IFS=*; echo "$*" | bc -l)
sub() (IFS=-; echo "$*" | bc -l)
add() (IFS=+; echo "$*" | bc -l)
