nb() {
 	local learner=weka.classifiers.bayes.NaiveBayes
	$Weka $learner -p 0 -t $1 -T $2  
}
nb10() {
	local learner=weka.classifiers.bayes.NaiveBayes
	$Weka $learner -i -t $1   
}
j48() {
	local learner=weka.classifiers.trees.J48
	$Weka $learner -C 0.25 -M 2 -p 0 -t $1 -T $2
}
j4810() {
	local learner=weka.classifiers.trees.J48
	$Weka $learner	-C 0.25 -M 2 -i -t $1 
}
zeror() {
        local learner=weka.classifiers.rules.ZeroR
	$Weka $learner -p 0 -t $1 -T $2
}
zeror10() {
        local learner=weka.classifiers.rules.ZeroR
	$Weka $learner -i -t $1
}
oner() {
        local learner=weka.classifiers.rules.OneR
	$Weka $learner -p 0 -t $1 -T $2
}
oner10() {
        local learner=weka.classifiers.rules.OneR
	$Weka $learner -i -t $1
}
ridor() {
       local learner=weka.classifiers.rules.Ridor
	$Weka $learner -F 3 -S 1 -N 2.0 -p 0 -t $1 -T $2 
}
ridor10(){
       local learner=weka.classifiers.rules.Ridor
       $Weka $learner -F 3 -S 1 -N 2.0 -i -t $1
}
adtree() {
       local learner=weka.classifiers.trees.ADTree
       $Weka $learner -B 10 -E -3 -p 0 -t $1 -T $2
}
adtree10() {
       local learner=weka.classifiers.trees.ADTree
       $Weka $learner -B 10 -E -3 -i -t $1
}






