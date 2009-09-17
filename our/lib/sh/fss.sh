#rank attributes via infogain
rankViaInfoGain() {
    local numattrs=$2
    local out=$3
	$Weka  weka.filters.supervised.attribute.AttributeSelection \
     	-S  "weka.attributeSelection.Ranker -T -2.7976931348623157E308 -N "$numattrs""  \
     	-E  "weka.attributeSelection.InfoGainAttributeEval"                    \
     	-i  $1 -o $out.arff
} 

#reduce via PCA 
reduceViaPCA(){
    local numattrs=$2
    local out=$3
    $Weka  weka.filters.supervised.attribute.AttributeSelection \
     	-S  "weka.attributeSelection.Ranker -T -1.7976931348623157E308 -N "$numattrs""  \
     	-E  "weka.attributeSelection.PrincipalComponents -R 0.95 -O -A 4" \
        -i $1 -o $out.arff
}