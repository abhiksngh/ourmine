analyzeClusterSimFile(){

	local kmeanssimfile=$1
	local genicsimfile=$2
	local canopysimfile=$3
	local outfile=$4
	
	echo "k,dataset,kmeans_intersim,kmeans_intrasim,genic_intersim,genic_intrasim,canopy_intersim,canopy_intrasim" > ~/tmp/tmpsim
 
	for kmeans_line in `cat $kmeanssimfile`; do		
		kmeans_intersim=`echo $kmeans_line | awk 'BEGIN{FS=",";}{print $4}'`	
		kmeans_intrasim=`echo $kmeans_line | awk 'BEGIN{FS=",";}{print $5}'`

		kmeans_k_and_dataset=`echo $kmeans_line | cut -f2,3 -d,`
		
		#get genic and canopy diffs too
		genic_intersim=`cat $genicsimfile | grep ,$kmeans_k_and_dataset | awk 'BEGIN{FS=",";}{print $4}'`
		genic_intrasim=`cat $genicsimfile | grep ,$kmeans_k_and_dataset | awk 'BEGIN{FS=",";}{print $5}'`
		canopy_intersim=`cat $canopysimfile | grep ,$kmeans_k_and_dataset | awk 'BEGIN{FS=",";}{print $4}'`
		canopy_intrasim=`cat $canopysimfile | grep ,$kmeans_k_and_dataset | awk 'BEGIN{FS=",";}{print $5}'`			

		#divided values
		genic_intersim_div=`div $genic_intersim $kmeans_intersim`
		genic_intrasim_div=`div $genic_intrasim $kmeans_intrasim`
		canopy_intersim_div=`div $canopy_intersim $kmeans_intersim`
		canopy_intrasim_div=`div $canopy_intrasim $kmeans_intrasim`

		genic_final_intersim=`sub $genic_intersim_div 1`
		canopy_final_intersim=`sub $canopy_intersim_div 1`
		genic_final_intrasim=`mult $genic_intrasim_div 100`
		canopy_final_intrasim=`mult $canopy_intrasim_div 100`				

		echo "$kmeans_k_and_dataset,0.0,100.0,$genic_final_intersim,$genic_final_intrasim,$canopy_final_intersim,$canopy_final_intrasim" >> ~/tmp/tmpsim		
		
	done

	cat ~/tmp/tmpsim | sort -t, -k1,1 -g | malign > $outfile
	rm -rf ~/tmp/tmpsim
}
