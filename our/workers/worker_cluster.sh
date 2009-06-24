
#kmeans and genic, with varying dataset and k
worker001(){
 local numclusters="4 8 16 24 64 128"
 local datadir=$1

 for f in $datadir/*; do
     for k in $numclusters; do
	 out=`basename $f`
	 out=${out%.*}
	 echo "$out,$k"
	 $Clusterers -k $k $f $Tmp/"$out"_kmeans_k=$k.sparff
	 $Clusterers -g $k 15 $f $Tmp/"$out"_genic_k=$k.sparff
     done
 done
}

#kmeans and genic finding inter/intra cluster similarity
worker002(){
 local numclusters="4 8 16 24 64 128"
 local datadir=$1
 local outfile=$2

 for f in $datadir/*; do
     for k in $numclusters; do
	 out=`basename $f`
	 out=${out%.*}
	 echo -n "$out,$k,"
	 $Clusterers -k $k $f $Tmp/"$out"_kmeans_k=$k.sparff -sim
	 echo ""
	 echo -n "$out,$k,"
	 $Clusterers -g $k 15 $f $Tmp/"$out"_genic_k=$k.sparff -sim
	 echo ""
     done
 done
}