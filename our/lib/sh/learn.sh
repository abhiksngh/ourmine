bnet(){
        local learner=weka.classifiers.bayes.BayesNet
	$Weka $learner -p 0 -t $1 -T $2 -D \
	    -Q weka.classifiers.bayes.net.search.local.K2 -- -P 2 -S BAYES \
	    -E weka.classifiers.bayes.net.estimate.SimpleEstimator -- -A 0.5 
}
bnet10(){
        local learner=weka.classifiers.bayes.BayesNet
	$Weka $learner -i -t $1 -D \
	    -Q weka.classifiers.bayes.net.search.local.K2 -- -P 2 -S BAYES \
	    -E weka.classifiers.bayes.net.estimate.SimpleEstimator -- -A 0.5 
}
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
	$Weka $learner -p 0 -C 0.25 -M 2 -t $1 -T $2
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
rbfnet(){
        local learner=weka.classifiers.functions.RBFNetwork
	$Weka $learner -p 0 -t $1 -T $2 -B 2 -S 1 -R 1.0E-8 -M -1 -W 0.1
}
rbfnet10(){
        local learner=weka.classifiers.functions.RBFNetwork
	$Weka $learner -i -t $1 -B 2 -S 1 -R 1.0E-8 -M -1 -W 0.1
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
       $Weka $learner -B 10 -E -3 -p 0 -i -t $1
}






