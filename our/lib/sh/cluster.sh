kmeansProb() {
    local clusterer=weka.clusterers.SimpleKMeans
    $Weka $clusterer -t $1 -N $2 -S 100 -p 0
}

kmeans(){
    local clusterer=weka.clusterers.SimpleKMeans
    $Weka $clusterer -t $1 -N $2 -S 100
}

kmeansOut(){
    local clusterer=weka.clusterers.SimpleKMeans
    $Weka $clusterer -t $1 -N $2 -p $3
}

em(){
    local clusterer=weka.clusterers.EM
    $Weka $clusterer -t $1 -N $2
}
