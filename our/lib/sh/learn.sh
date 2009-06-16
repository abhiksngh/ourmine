nb() {
	blab "n"
 	local learner=weka.classifiers.bayes.NaiveBayes
	$Weka $learner -p 0 -t $1 -T $2  
}
nb10() {
	blab "N"
	local learner=weka.classifiers.bayes.NaiveBayes
	$Weka $learner -i -t $1   
}
j48() {
  	blab "j"
	local learner=weka.classifiers.trees.J48
	$Weka $learner -C 0.25 -M 2 -p 0 -t $1 -T $2
}
j4810() {
  	blab "J"
	local learner=weka.classifiers.trees.J48
	$Weka $learner	-C 0.25 -M 2 -i -t $1 
}
