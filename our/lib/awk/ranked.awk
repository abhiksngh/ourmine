# demos
# pgawk --dump-variables -f ranked.awk --source 'BEGIN {mwuTests()}'

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
# debugged using the example at
# http://faculty.vassar.edu/lowry/ch12a.html
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
	z = (w - 0.5) / sigma 
   if (z >= 0 && z <= critical) 
		return 0
    else  
		return up ? w : -1*w
}
# debugged using the example at
# http://faculty.vassar.edu/lowry/ch11a.html
function mwu(x,pop1,pop2,up,critical,
	     i,data,ranks,n,n1,sum1,ranks1,n2,sum2,ranks2,	\
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
function multiple(a,n,  i) { for (i in a) a[i] *= n }
function abs(x)            { return x < 0 ? -1*x : x }	
function oddp(n)           { return n % 2 }

#### testing
function wilcoxonTests() {
    print "1,  1"; wilcoxonTest(1,1)
    print "0.5,1"; wilcoxonTest(0.5,1)
    print "2,  1"; wilcoxonTest(2,1)
    print "1,  0"; wilcoxonTest(1,0)
    print "0.5,0"; wilcoxonTest(0.5,0)
    print "2,  0"; wilcoxonTest(2,0)
}
function wilcoxonTest(mult,up,       pop1,pop2,out) {
	mult= mult ? mult : 1
	s2a("1 78 2 24 3 64 "\
	"4 45 5 64 6 52 "\
	"7 30 8 50 9 64 "\
	"10 50 11 78 12 22 "\
	"13 84 14 40 15 90 "\
	"16 72" ,pop1)
	s2a("1 78 2 24 3 62 "\
	"4 48 5 68 6 56 "\
	"7 25 8 44 9 56 "\
	"10 40 11 68 12 36 "\
	"13 68 14 20 15 58 "\
	"16 32",pop2)
	multiple(pop1,mult)
	out = wilcoxon(pop1,pop2,up,criticalValue(95))
    if (out == 0)
		print "tie"
    else if (out > 0)
		print "win for a"
    else if (out < 0)
		print "loss for a"
}
function mwuTests() {
    print "1,  1"; mwuTest(1,1)
    print "0.5,1"; mwuTest(0.5,1)
    print "2,  1"; mwuTest(2,1)
    print "1,  0"; mwuTest(1,0)
    print "0.5,0"; mwuTest(0.5,0)
    print "2,  0"; mwuTest(2,0)
}
function mwuTest(mult,up,   pop1,pop2,out) {
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
    n=split(s,tmp,/ /)
    for(i=1;i<n;i+=2 )
		a[tmp[i]]=tmp[i+1]
}
function saya(a,str,pad,  i,com) {
    pad = pad ? pad : ""
    com="sort -n -k 2"
    for(i in a ) print pad str "[ " i " ] = " a[i] | com
    close(com)
}

