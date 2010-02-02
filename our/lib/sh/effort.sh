exp1(){
	local d="$Data/effest/nasa93.arff"	#data set
	local bins=10				#Number of bins to divide data into, for cross-val or train/test splitting
	local repeats=20			#Repeats for each learning cycle when determining weights
	local clusters=10			#Number of clusters to divide data into
	local atts="1-24"			#Setting for the clusterer, number of attributes in data set
	local weights="-1,-1,-1,-1,-1,-1,-1,-1,-1,-1"		#Initial weight vector, make sure it num weights = num clusters
	local mode=2 				#1=MMRE, 2=Pred(30)	

	#Generate clusters
	cd $Tmp
	kmeansOut $d $clusters $atts > clusters.txt

	#Train weights

	[ -f weightdata.csv ] && rm weightdata.csv 
	for((r=1;r<=$repeats;r++)); do
		buildOverSet $d clusters.txt $clusters $weights weightdata.csv > overset.arff
		makeTrainAndTest overset.arff $bins 10
		cat train.arff | logArff 0.00001 > trainL.arff
		cat test.arff | logArff 0.00001 > testL.arff
		linearRegression trainL.arff testL.arff 1.0E-8 | gotwant > results.csv
		calcScores results.csv $mode weightdata.csv $r > weightdatatemp.csv
		mv weightdatatemp.csv weightdata.csv
	done
	classifyForBORE weightdata.csv $clusters $mode > weightdataClass.csv
	bore weightdataClass.csv "^best$" | tail -1 | getBest
	
}

#Replaces performance score (last category) with best or rest in preperation for bore learner
#Input is dataset,number of non-score attributes,scoring mode (1=minimize, 2=maximize)

classifyForBORE(){
awk -v Data=$1 -v Atts=$2 -v Mode=$3 'BEGIN{
	scores[0]=0;
	data[0]=0;

	while(getline d < Data){
		line="";
		split(d,cols,",");
		for(i=1;i<=Atts;i++){
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
			if(Mode==1){
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
		header=header i",";
	}
	header=header"class";
	print header;

	for(i=1;i<=scores[0];i++){
		print data[i] classes[i];
	}
}'
}


#Calculates MMRE/Pred(30)
#Inputs are results file, scoring mode, output file name, which repeat this is

calcScores(){
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
		score=sum/act[0];
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
#Inputs: 
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
