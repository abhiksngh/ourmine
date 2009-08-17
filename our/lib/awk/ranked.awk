# n:     1 2 3 4   5   6 7 8 9 10 11  12   13
# data:  1 1 1 2   2   3 4 5 5 5  6   8    8
# ranks: 2 2 2 4.5 4.5 6 7 9 9 9  11  12.5 12.5
# takes about 1/8 th of a second to rank 10,000 numbers

# demos
# pgawk --dump-variables -f ranked.awk --source 'BEGIN {mwuTests()}'

function rank(data,ranks,     starter,n,old,start,skipping,sum,i,j,r) {
    starter="someCraZYsymBOL";
    n     = asort(data)    
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
	    ranks[data[n]] = r++
}

# debugged using the example at
# http://faculty.vassar.edu/lowry/ch11a.html
function mwu(x,pop1,pop2,up,critical,
	     i,data,ranks,n,n1,sum1,ranks1,n2,sum2,ranks2,	\
	     correction,meanU,sdU,z) {

    for(i in pop1) data[++n]=pop1[i]
    for(i in pop2) data[++n]=pop2[i]
    rank(data,ranks)
    for(i in pop1) {
	n1++; 
	sum1 += ranks1[i] = ranks[pop1[i]]
    }
    for(i in pop2) {
	n2++; 
	sum2 += ranks2[i] = ranks[pop2[i]]
    }
    meanU      = n1*(n1+n2+1)/2  # symmetric , so we just use pop1's z-value
    sdU        = (n1*n2*(n1+n2+1)/12)^0.5
    correction = sum1 > meanU ? -0.5 : 0.5  
    z          = abs((sum1 - meanU + correction )/sdU)

    if (z >= 0 && z <= critical) 
	return 0
    else if (up) 
	return median(ranks1,n1) - median(ranks2,n2)
    else 
	return median(ranks2,n2) - median(ranks1,n1)	
}

function multiple(a,n,  i) { for (i in a) a[i] *= n }
function abs(x)            { return x < 0 ? -1*x : x }	
function oddp(n)           { return n % 2 }

function criticalValue(conf) {
    conf = conf ? conf  : 95
    if (conf==99) return 2.326
    if (conf==95) return 1.960 
    if (conf==90) return 1.645
}
function median(a,n,   low) {
    low = int(n/2);
    return oddp(n) ?  a[low+1] : (a[low] + a[low+1])/2
}

#### testing
function mwuTests() {
    print "1,  1"; mwuTest(1,1)
    print "0.5,1"; mwuTest(0.5,1)
    print "2,  1"; mwuTest(2,1)
    print "1,  0"; mwuTest(1,0)
    print "0.5,0"; mwuTest(0.5,0)
    print "2,  0"; mwuTest(2,0)
}
function mwuTest(mult,up,   pop1,pop2,out) {
    up   = up   ? up   : 0
    mult = mult ? mult : 1
    s2a("1 4.6 2 4.7 3 4.9 "			\
	"4 5.1 5 5.2 6 5.5 "			\
	"7 5.8 8 6.1 9 6.5 "			\
	"10 6.5 11 7.2",pop1)
     
    s2a("1 5.2 2 5.3 3 5.4 "			\
	"4 5.6 5 6.2 6 6.3 "			\
	"7 6.8 8 7.7 9 8.0 "			\
	"10 8.1", pop2)
    multiple(pop1,mult)
    out = mwu("a",pop1,pop2,up,criticalValue(95))
    if (out == 0)
	print "tie"
    else if (out > 0)
	print "win for a"
    else if (out < 0)
	print "loss for a"
}
function s2a(s,a,    tmp,i,n) {
    n=split(s,tmp)
    for(i=1;i<n;i+=2 )
	a[tmp[i]]=tmp[i+1]
}
function saya(a,str,pad,  i,com) {
    pad = pad ? pad : ""
    com="sort -n -k 2"
    for(i in a ) print pad str "[ " i " ] = " a[i] | com
    close(com)
}

