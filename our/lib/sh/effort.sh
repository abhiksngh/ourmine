exp1(){
	local d="$Data/effest/cocomonasaPrecise.arff"	#data set
	local bins=10				#Number of bins to divide data into, for cross-val or train/test splitting
	local repeats1=100			#Repeats for each learning cycle when determining weights
	local repeats2=10			#For 10x10 crossval
	local clusters=10			#Number of clusters to divide data into
	local atts="1-17"			#Setting for the clusterer, number of attributes in data set
	local weights="-1,-1,-1,-1,-1,-1,-1,-1,-1,-1"		#Initial weight vector, make sure it num weights = num clusters
	local mode=$1				#1=MMRE, 2=Pred(30), 3=MedMRE	
	local save="/home/greg/svns/wisp/var/greg/china/data/"				#Where to save reports

	echo "Generating clusters"
	cd $Tmp
	kmeansOut $d $clusters $atts > clusters.txt

	echo ""
	echo "Training weights"
	for((k=1;k<=$clusters;k++)); do
		[ -f weightdata.csv ] && rm weightdata.csv 
		for((r=1;r<=$repeats1;r++)); do
			buildOverSet $d clusters.txt $clusters $weights weightdata.csv > overset.arff
			rm test.lisp test.arff train.lisp train.arff
			makeTrainAndTest overset.arff $bins 10
			cat train.arff | logArff 0.00001 > trainL.arff
			cat test.arff | logArff 0.00001 > testL.arff
			linearRegression trainL.arff testL.arff 1.0E-8 | gotwant > results.csv
			calcScoresWeights results.csv $mode weightdata.csv $r > weightdatatemp.csv
			mv weightdatatemp.csv weightdata.csv
		done
		classifyForBORE weightdata.csv $clusters $weights $mode > weightdataClass.csv
		weights=`bore weightdataClass.csv "^best$" | tail -1 | getBest $weights $clusters`
		echo $weights
	done

	echo ""
	echo "10x10 cross-val: Oversampled"
	[ -f $save/oversampled_$mode.csv ] && mv oversampled_$mode.csv old_oversampled_$mode.csv
	buildOverSet $d clusters.txt $clusters $weights weightdata.csv > oversetFinal.arff
	for((run=1;run<=$repeats2;run++)); do
		for((bin=1;bin<=$bins;bin++)); do
			rm test.lisp test.arff train.lisp train.arff
			makeTrainAndTest oversetFinal.arff $bins $bin
			cat train.arff | logArff 0.00001 > trainL.arff
			cat test.arff | logArff 0.00001 > testL.arff
			linearRegression trainL.arff testL.arff 1.0E-8 | gotwant > results.csv		
			calcScores results.csv $mode >> $save/oversampled_$mode.csv
			calcScores results.csv 4 >> $save/oversampled_mres.csv
		done
	done
	echo "Median Score:"
	cat $save/oversampled_$mode.csv | median
	if [ $mode = 1 ] || [ $mode = 3 ]; then
		cat $save/oversampled_$mode.csv | normalize | awk 'BEGIN{} {print $1*100}' - | quartile
	else
		cat $save/oversampled_$mode.csv | awk 'BEGIN{} {print $1*100}' - | quartile
	fi

	echo ""
	echo "10x10 cross-val: Original"
	[ -f $save/original_$mode.csv ] && mv original_$mode.csv original_$mode_old.csv
	for((run=1;run<=$repeats2;run++)); do
		for((bin=1;bin<=$bins;bin++)); do
			rm test.lisp test.arff train.lisp train.arff
			makeTrainAndTest $d $bins $bin
			cat train.arff | logArff 0.00001 > trainL.arff
			cat test.arff | logArff 0.00001 > testL.arff
			linearRegression trainL.arff testL.arff 1.0E-8 | gotwant > results.csv		
			calcScores results.csv $mode >> $save/original_$mode.csv
			calcScores results.csv 4 >> $save/original_mres.csv

		done
	done
	echo "Median Score:"
	cat $save/original_$mode.csv | median
	if [ $mode = 1 ] || [ $mode = 3 ]; then
		cat $save/original_$mode.csv | normalize | awk 'BEGIN{} {print $1*100}' - | quartile
	else
		cat $save/original_$mode.csv | awk 'BEGIN{} {print $1*100}' - | quartile
	fi

	echo $d",oversampled,"`cat $save/oversampled_$mode.csv | median`
	echo $d",original,"`cat $save/original_$mode.csv | median`
}

exp2(){
	local mode=$1
	local repeats="1 2 3 4 5 6 7 8 9 10"
	
	for r in $repeats; do
		exp1 $mode
	done
}

#Generates new weight vector, fixing one additional weight
getBest(){
awk -v Weight=$1 -v K=$2 '
	BEGIN{OFS=" ";}
	{pos=$3;
	val=substr(pos,3,length(pos));
	if(substr(val,1,1) ~ "=")	val=substr(val,2,length(val));
	pos=substr(pos,1,2);
	if(substr(pos,2,2) ~ "=")	pos=substr(pos,1,1);
	split(Weight,weights,",");
	for(i=1;i<=K;i++){
		if(i==pos)	out=out val","
		else		out=out weights[i]","
	}
	out=substr(out,1,length(out)-1);
	print out;
	}' -
}

arffWithNums(){
	./cocNums --numbers $1.config $2;
}

#Replaces performance score (last category) with best or rest in preperation for bore learner
#Input is dataset,number of non-score attributes,vector of weights, and scoring mode (1=minimize, 2=maximize)

classifyForBORE(){
awk -v Data=$1 -v Atts=$2 -v Weight=$3 -v Mode=$4 'BEGIN{
	scores[0]=0;
	data[0]=0;

	split(Weight,weights,",");
	while(getline d < Data){
		line="";
		split(d,cols,",");
		for(i=1;i<=Atts;i++){
			if(weights[i]==-1)
				line=line cols[i] ",";
		}
		data[++data[0]]=line;
		scores[++scores[0]]=cols[Atts+1];
	}
	close(Data);

	best=.2*scores[0];
	for(i=1;i<=scores[0];i++)	classes[i]="rest";

	for(i=1;i<=best;i++){
		max=0;
		min=100;
		maxpos=0;
		for(j=1;j<=scores[0];j++){
			if(Mode==1||Mode==3){
				if((scores[j]<min)&&(classes[j]!~ "best")){
					min=scores[i];
					maxpos=j;
				}
			}else if(Mode==2){
				if((scores[j]>max)&&(classes[j]!~ "best")){
					max=scores[j];
					maxpos=j;
				}
			}
		}
		classes[maxpos]="best";
	}

	for(i=1;i<=Atts;i++){
		if(weights[i]==-1)
			header=header i",";
	}
	header=header"class";
	print header;

	for(i=1;i<=scores[0];i++){
		print data[i] classes[i];
	}
}'
}


#Calculates MMRE/Pred(30)/MedMRE
#Mode 4 just spits out a list of MREs
calcScores(){
awk -v Results=$1 -v Mode=$2 'BEGIN{
	pred[0]=0;
	act[0]=0;

	#Read in the data
	while(getline r < Results){
		split(r,nums,",");
		pred[++pred[0]]=nums[1];
		act[++act[0]]=nums[2];
	}
	close(Results);
	
	if(Mode==1){
		mre[0]=0;
		sum=0;
		for(i=1;i<=act[0];i++){
			top=act[i]-pred[i];
			bot=act[i];
			if(top < 0)	top=top*-1;
			if(bot < 0)	bot=bot*-1; 
			mre[++mre[0]]=top/bot;
			sum=sum+mre[mre[0]];
		}
		score=sum/(act[0]);
	} else if(Mode==2){
		within=0;
		for(i=1;i<=act[0];i++){
			threshold1=0.7*act[i];
			threshold2=1.3*act[i];
			if((pred[i]>=threshold1)&&(pred[i]<=threshold2)){
				within++;
			}
		}
		score=within/act[0];
	} else if(Mode==3){
		count=0;
		for(i=1;i<=act[0];i++){
			top=act[i]-pred[i];
			bot=act[i];
			if(top < 0)	top=top*-1;
			if(bot < 0)	bot=bot*-1; 
			mre[++count]=top/bot;
		}
	
		asort(mre);
		if(count%2)	
			score=mre[int(count/2)];
		else{
			low=mre[int(count/2)];
			high=mre[int(count/2)+1];
			score=(low+high)/2;
		}
	} else if(Mode==4){
		for(i=1;i<=act[0];i++){
			top=act[i]-pred[i];
			bot=act[i];
			if(top<0)	top=top*-1;
			if(bot<0)	bot=bot*-1;
			print (top/bot);
		}
	}
	
	if(Mode!=4)
		print score;
}'
}

#Calculates MMRE/Pred(30)/MedMRE
#Inputs are results file, scoring mode, output file name, which repeat this is

calcScoresWeights(){
awk -v Results=$1 -v Mode=$2 -v Outfile=$3 -v Run=$4 'BEGIN{
	pred[0]=0;
	act[0]=0;

	#Read in the data
	while(getline r < Results){
		split(r,nums,",");
		pred[++pred[0]]=nums[1];
		act[++act[0]]=nums[2];
	}
	close(Results);
	
	if(Mode==1){
		mre[0]=0;
		sum=0;
		for(i=1;i<=act[0];i++){
			top=act[i]-pred[i];
			bot=act[i];
			if(top < 0)	top=-top;
			if(bot < 0)	bot=-bot; 
			mre[++mre[0]]=top/bot;
			sum=sum+mre[mre[0]];
		}
		score=sum/(act[0]);
	} else if(Mode==2){
		within=0;
		for(i=1;i<=act[0];i++){
			threshold1=0.7*act[i];
			threshold2=1.3*act[i];
			if((pred[i]>=threshold1)&&(pred[i]<=threshold2)){
				within++;
			}
		}
		score=within/act[0];
	} else if(Mode==3){
		count=0;
		for(i=1;i<=act[0];i++){
			top=act[i]-pred[i];
			bot=act[i];
			if(top < 0)	top=top*-1;
			if(bot < 0)	bot=bot*-1; 
			mre[++count]=top/bot;
		}

		asort(mre);
		if(count%2)	
			score=mre[int(count/2)];
		else{
			low=mre[int(count/2)];
			high=mre[int(count/2)+1];
			score=(low+high)/2;
		}

	}

	line=0;
	while(getline o < Outfile){
		if(++line==Run){
			o=o","score;
			print o;
		} else
			print o;
	}
	close(Outfile);
}'
}

#Builds oversampled data set
#Inputs: Initial data et, cluster information file, number of clusters, weight vector, output file
 
buildOverSet(){
awk -v D=$1 -v C=$2 -v K=$3 -v W=$4 -v O=$5 -v seed=$RANDOM 'BEGIN{
	cluster[0]=0;
	data[0]=0;
	header[0]=0;
	srand(seed);
	found=0;

	#Read in data and cluster information
	while(getline d < D){
		if(found==0){
			header[++header[0]]=d;
			if(d ~ /@data/){
				found=1;
			}
		}
		else{
			if(d !~ /^$/)
				data[++data[0]]= d;
		}
	}
	close(D);

	while(getline c < C){
		split(c,infos," ");
		cluster[++cluster[0]]=(infos[2]+1);
	}
	close(C);

	#Assign weights to all non-fixed values
	split(W,weights,",");
	for(i=1;i<=K;i++){
		if(weights[i]==-1){
			weights[i]=round(rand()*10);
			if(weights[i]==0)
				weights[i]=1;
		}
	}

	#Print out new dataset
	for(i=1;i<=header[0];i++){
		print header[i];
	}

	current=data[0];
	for(i=1;i<=current;i++){
		for(j=1;j<weights[cluster[i]];j++){
			data[++data[0]]=data[i];
		}
	}

	#Randomize order and print data items
	
	nshuffle(data);
	for(i=1;i<=data[0];i++){
		print data[i];
	}

	#Print randomized weights to the weight data set
	out="";
	for(i=1;i<K;i++){
		out=out weights[i]",";
	}
	out=out weights[K];
	print out >> O
}

function nshuffle(a,  i,j,n,tmp) {
  n=a[0]; # a has items at 1...n
  for(i=1;i<=n;i++) {
    j=i+round(rand()*(n-i));
    tmp=a[j];
    a[j]=a[i];
    a[i]=tmp;
  };
  return n;
}
function round(x) { return int(x + 0.5) }'
}
