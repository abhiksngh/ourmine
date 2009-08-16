# n:     1 2 3 4   5   6 7 8 9 10 11  12   13
# data:  1 1 1 2   2   3 4 5 5 5  6   8    8
# ranks: 2 2 2 4.5 4.5 6 7 9 9 9  11  12.5 12.5
# takes about 1/8 th of a second to rank 10,000 numbers

# demos
# cat rank1.dat | gawk -f rank.awk   | sort -n
#  time gawk -f rank.awk --source 'BEGIN{_stress(); exit}'

#    { Data[++Data[0]]=$1}
#END { rank(Data,Ranks)
#      for(I in Ranks) print I, Ranks[I] 
#}
function _stress(     n,r,i,data,ranks) {
    n=10000
    r=0.05
    while(n--) data[++data[0]]=int(rand() / r) * r
    rank(data,ranks)
}
function rank(data,ranks,     starter,n,old,start,skipping,sum,i,r) {
	delete data[0]
	starter="x";
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
	        print "sum ",sum," i ",i," start ", start , " data[j] " data[j] " = " r
			start = i;
			sum   = i;
		}
		old=data[i]
	}
    if (skipping)
		ranks[data[n]] = sum/(i - start)
}

function mwu(pop1,labels1,pop2,labels2,win,loss,tie,up,critical,
		    i,data,n,n1,n2,ranks,ranks1,ranks2,\
			u1,u2,meanU,sdU,z,z1,z2) {
	for(i in pop1) data[++n]=pop1[i]
	for(i in pop2) data[++n]=pop2[i]
	rank(data,ranks)
	for(i in pop1) {n1++; sum1 += ranks1[i] = ranks[pop1[i]]}
	for(i in pop2) {n2++; sum2 += ranks2[i] = ranks[pop2[i]]}
	u1      = sum1 - n1*(n1 + 1)/2
	u2      = sum2 - n2*(n2 + 1)/2
	meanU   = n1*n2/2
	sdU     = (n1*n2*(n1+n2+1)/12)^0.5
	z1      = (u1 - meanU)/sdU
	z2      = (u2 - meanU)/sdU
	z       = z1 > z2 ? z1 : z2
	ztest(z,critical,labels1,labels2,win,loss,tie,ranks1,n1,ranks2,n2)
}
function ztest(z,critical,labels1,labels2,win,loss,tie,ranks1,n1,ranks2,n2,\
               median1,median2) {
	if (z >= 0 && z <= critical) 
		winLossTie(labels1,labels2,tie,tie)
	 else {
		median1 = median(ranks1,n1)
		median2 = median(ranks2,n2)
		if (up)	 {
			if (median1 > median2) 
				 winLossTie(labels1,labels2,win ,loss)
		    else winLossTie(labels1,labels2,loss,win )
		} else {
			if (median1 < median2) 
				 winLossTie(labels1,labels2,win ,loss)
		    else winLossTie(labels1,labels2,loss,win )
	   }
    }
}	
function criticalValue(conf) {
	conf     = conf     ? conf  : 95
	return conf==95 ? 1.960 : 2.576
}
function winLossTie(l1,l2,a1,a2,i) {
		for(i in l1) a1[i]++	
		for(i in l2) a2[i]++	
}
function oddp(n) { return n % 2 }

function median(a,n) {
	low = int(n/2) 
	return oddp(size) ?  a[low+1] : (a[low] + a[low+1])/2
}

function mwuTest() {
	split(" 1 4.6  	2 4.7 	3 4.9 "\
          " 4 5.1  	6 5.2 	7 5.5 "\
          " 7 5.8  	8 6.1 	9 6.5 "\
          "10 6.5 	11 7.2       ", pop1,/[ \t]+/)
	split(" 1 5.2  	2 5.3 	3 5.4 "\
          " 4 5.6 	5 6.2 	6 6.3 "\
		  " 7 6.8   8 7.7 	9 8.0 "\
          "10 8.1              ", pop2,/[ \t]+/)
	labels1["a"]
	labels2["b"]
	mwu(pop1,labels1,pop2,labels2,win,loss,time,1,criticalValue(95))
}

