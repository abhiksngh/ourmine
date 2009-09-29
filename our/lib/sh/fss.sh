#rank attributes via infogain
rankViaInfoGain() {
    local numattrs=$2
    local out=$3
	$Weka  weka.filters.supervised.attribute.AttributeSelection \
     	-S  "weka.attributeSelection.Ranker -T -2.7976931348623157E308 -N "$numattrs""  \
     	-E  "weka.attributeSelection.InfoGainAttributeEval"                    \
     	-i  $1 -o $out.arff
} 

infogain() {
    rankViaInfoGain $1 $2 $3
}

#reduce attributes via PCA 
reduceViaPCA(){
    local numattrs=$2
    local out=$3
    $Weka  weka.filters.supervised.attribute.AttributeSelection \
     	-S  "weka.attributeSelection.Ranker -T -1.7976931348623157E308 -N "$numattrs""  \
     	-E  "weka.attributeSelection.PrincipalComponents -R 0.95 -O -A 4" \
        -i $1 -o $out.arff
}

pca() {
    rankViaPCA $1 $2 $3
}

#reduce attributes via chi-squared
reduceViaChiSquared(){
    local numattrs=$2
    local out=$3
    $Weka  weka.filters.supervised.attribute.AttributeSelection \
     	-S  "weka.attributeSelection.Ranker -T -1.7976931348623157E308 -N "$numattrs""  \
     	-E  "weka.attributeSelection.ChiSquaredAttributeEval" \
        -i $1 -o $out.arff
}

chisquared(){
    reduceViaChiSquared $1 $2 $3
}

#reduce attributes via OneR
reduceViaOneR(){
    local numattrs=$2
    local out=$3
    $Weka  weka.filters.supervised.attribute.AttributeSelection \
     	-S  "weka.attributeSelection.Ranker -T -1.7976931348623157E308 -N "$numattrs""  \
     	-E  "weka.attributeSelection.OneRAttributeEval -S 1 -F 10 -B 6" \
        -i $1 -o $out.arff
}

oneR(){
    reduceViaOneR $1 $2 $3
}

reduceViaRelief(){
    local numattrs=$2
    local out=$3
    $Weka  weka.filters.supervised.attribute.AttributeSelection \
	-S "weka.attributeSelection.Ranker -T -1.7976931348623157E308 -N "$numattrs"" \
	-E "weka.attributeSelection.ReliefFAttributeEval -M -1 -D 1 -K 10 -A 2" \
	-i $1 -o $out.arff
}

relief(){
    reduceViaRelief $1 $2 $3
}


