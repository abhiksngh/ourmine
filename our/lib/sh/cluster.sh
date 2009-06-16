kmeansProb() {
    blab "k"
    local clusterer=weka.clusterers.SimpleKMeans
    $Weka $clusterer -t $1 -N $2 -S 100 -p 0
}

kmeans(){
    blab "k"
    local clusterer=weka.clusterers.SimpleKMeans
    $Weka $clusterer -t $1 -N $2 -S 100
}

em(){
    blab "E"
    local clusterer=weka.clusterers.EM
    $Weka $clusterer -t $1 -N $2
}
