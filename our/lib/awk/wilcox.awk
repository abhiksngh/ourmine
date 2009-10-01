#!/usr/bin/gawk -f

#This code represents a major overhaul by Adam Nelson from an original implementation by Omid Jalali (2007). This newly edited version contains new Mann-Whitney U Test and Wilcoxon Test code.


#Usage:		./wilcox Fields=10 Key=2,3,6 Performance=9 High=1 Confidence=95 filename

#Notes:		Fields is the total number of fields.
#			Key is the column number(s) of column(s) forming the key.
#			Performance is the column number of the value being measured as the performance measure. It should be a single column.
#			High determines whether a high performance measure is better (High=1) or a low performance measure is better (High=0).
#			Confidence determines the confidence interval. Possible values are 95 and 99 percent.
#			filename is the name of the input file

BEGIN {
	FS = OFS = ",";
	Fields = 2;
	Key = 1;
	Performance = 2;
	High = 0;
	Confidence = 95;
}

NR==1 {
	split(Key,KeyArray,FS);
}

/^$/ || /\#.*/ || NF != Fields {
	#skip blank lines, comments, or lines with wrong number of fields
	next;
}        

{
	#remove spaces and tabs
	gsub(/[ \t]/,"");
	#process the rest
	insertSorted(getKey(KeyArray),$(Performance));
}

function getKey(KeyArray, tempKey,separator)
{
	for(part in KeyArray) 
	{
		tempKey = tempKey separator $KeyArray[part];
		separator="|";
	}
	return tempKey;
}

function insertSorted(key,element)
{
	counter = N[key];
	while (counter >= 1 && PerformanceArray[key,counter] > element)
	{
		PerformanceArray[key,counter+1] = PerformanceArray[key,counter];
		counter--;
	}
		
	PerformanceArray[key,counter+1] = element;
	N[key]++;
}

END {

    #initialize all to 0
    for(key in N) {tie[key]=0; win[key]=0; loss[key]=0}

	for (firstKey in N)
	{
		for (secondKey in N)
		{
			if (firstKey != secondKey)
			{
				#this is to assure that two keys are not compared to each other twice
				newKey = firstKey FS secondKey;
				newKeyReverse = secondKey FS firstKey;
				if (!tempKeyArray[newKey] && !tempKeyArray[newKeyReverse])
				{
					keyCounter++;
					tempKeyArray[newKey] = 1;
				       	result=analyze(firstKey,secondKey);
					
					if(result == 0){
					    tie[firstKey]++;
					    tie[secondKey]++;
					}
					#a gain of firstKey represents a loss of secondKey, so we flip
					else if(result > 0){
					    win[firstKey]++;
					    loss[secondKey]++;
					}
					#same here
					else {loss[firstKey]++; win[secondKey]++}
				}
			}
		}
	}
	for(key in N) print key,tie[key],win[key],loss[key],win[key]-loss[key]; 
	
}

function analyze(firstKey, secondKey,   firststr,secondstr,pop1,pop2)
{
    firststr="";
    secondstr="";

    #merge 
    for (firstCounter = 1; firstCounter <= N[firstKey]; firstCounter++){
	firststr=firststr " " firstCounter " " PerformanceArray[firstKey,firstCounter];
    }

    for (secondCounter = 1; secondCounter <= N[secondKey]; secondCounter++){
	secondstr=secondstr " " secondCounter " " PerformanceArray[secondKey,secondCounter];
    }

    if(N[firstKey] != N[secondKey]){
	    print "The samples must be of equal size! Results will not be correct."; return; 
    }

    mult=0.5
    s2a(firststr,pop1);
    s2a(secondstr,pop2);

    multiple(pop1,mult);
    out=wilcoxon(pop1,pop2,mult,criticalValue(Confidence));
    return out;
}


### mwu and wilcoxon code
function mwu(pop1,pop2,up,critical,
             i,data,ranks,n,n1,sum1,ranks1,n2,sum2,ranks2,      \
             correction,meanU,sdU,z) {

    for(i in pop1) data[++n]=pop1[i]
    for(i in pop2) data[++n]=pop2[i]
    rank(data,ranks)
    for(i in pop1) { n1++; sum1 += ranks1[i] = ranks[pop1[i]] }
    for(i in pop2) { n2++; sum2 += ranks2[i] = ranks[pop2[i]] }

    meanU      = n1*(n1+n2+1)/2  # symmetric , so we just use pop1's z-value
    sdU        = (n1*n2*(n1+n2+1)/12)^0.5
    correction = sum1 > meanU ? -0.5 : 0.5  
    z          = abs((sum1 - meanU + correction )/sdU)

    if (z >= 0 && z <= critical) 
                return 0
        if (up) 
                return median(ranks1,n1) - median(ranks2,n2) # positive if ranks1 wins
        else
                return median(ranks2,n2) - median(ranks1,n1) # positive if ranks2 wins
}

function wilcoxon(pop1,pop2,up,critical,   \
				 ranks,w0,w,correction,z,sigma,i, delta, n,diff,absDiff) {
	for(i in pop1) {
	  delta = pop1[i] - pop2[i]
	  if (delta) { 
			n++
			diff[i]    = delta
			absDiff[i] = abs(delta) }}
	rank(absDiff,ranks)
	for(i in absDiff)  {
		w0 = ranks[absDiff[i]] 
		w += (diff[i] < 0)  ? -1*w0  :  w0
	}
	sigma = sqrt((n*(n+1)*(2*n+1))/6)
	z = (w - 0.5) / (sigma+0.0001) 
   if (z >= 0 && z <= critical) 
		return 0
    else  
		return up ? w : -1*w
}

function rank(data0,ranks,     data,starter,n,old,start,skipping,sum,i,j,r) {
    starter="someCraZYsymBOL";
    n     = asort(data0,data)    
    old   = starter
    start = 1;
    for(i=1;i<=n;i++) {
	skipping = (old == starter) || (data[i] == old);
	if (skipping) {
	    sum += i 
	} else {
	    r = sum/(i - start)
	    for(j=start;j<i;j++) 
		ranks[data[j]] = r;
	    start = i;
	    sum   = i;
	}
	old=data[i]
    }
    if (skipping)
	ranks[data[n]] = sum/(i - start)
    else 
	if (! (data[n] in ranks))
	    ranks[data[n]] = r+1
}

function s2a(s,a,    tmp,i,n) {
    n=split(s,tmp,/ /)
    for(i=1;i<n;i+=2 )
                a[tmp[i]]=tmp[i+1]
}

function criticalValue(conf) {
    conf = conf ? conf  : 95
    if (conf==99) return 2.326
    if (conf==95) return 1.960 
    if (conf==90) return 1.645
}

function multiple(a,n,  i) { for (i in a) a[i] *= n }
function oddp(n)           { return n % 2 }

function median(a,n,   low) {
    low = int(n/2);
    return oddp(n) ?  a[low+1] : (a[low] + a[low+1])/2
}

function abs(val){
    return val < 0 ? -1*val : val;
}

function correctionOfContinuity(val){
    return val > 0 ? -0.5 : 0.5; 
}