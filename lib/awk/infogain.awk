#obtain term frequencies in a document
function freqs(){
    for(i=1;i<=NF;i++) freq[$i]++;
}

#return term frequency (may be based off of tfidf terms)
function infogain(term){
    return freq[term];
}
