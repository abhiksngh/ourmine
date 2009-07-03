kmeansProb() {
    local clusterer=weka.clusterers.SimpleKMeans
    $Weka $clusterer -t $1 -N $2 -S 100 -p 0
}

kmeans(){
    local clusterer=weka.clusterers.SimpleKMeans
    $Weka $clusterer -t $1 -N $2 -S 100
}

em(){
    local clusterer=weka.clusterers.EM
    $Weka $clusterer -t $1 -N $2
}
