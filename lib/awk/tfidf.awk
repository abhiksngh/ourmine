#update counters for all words in the record 
function train() {
    Documents++; 
    for(I=1;I<=NF;I++) { 
	if( ++In[$I,Documents]==1) 
	    Document[$I]++    
	Word[$I]++ 
	Words++ 
    } 
} 
# compute tfidf for one word 
function tfidf(i) { 
    return Word[i]/Words*log(Documents/Document[i]);
} 

function idf(i) {
    return log(Documents/Document[i])
}

