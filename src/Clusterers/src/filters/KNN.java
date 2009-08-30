package filters;

import Distances.Distances;
import cluster.Cluster;
import java.util.ArrayList;
import java.util.Collections;
import java.util.Hashtable;

/**
 *
 * @author Adam Nelson
 */
public class KNN {

    private Hashtable _testChain = new Hashtable();
    private ArrayList<String[]> _testInstances = new ArrayList<String[]>();
    private ArrayList<String[]> _trainInstances = new ArrayList<String[]>();
    private ArrayList<String> _attributes = new ArrayList<String>();
    private ArrayList<Cluster> _clusters = new ArrayList<Cluster>();
    private Hashtable _testTrainPair = new Hashtable();
    private ArrayList<String[]> _finalInstances = new ArrayList<String[]>();
    private ArrayList<Cluster> _finalClusters = new ArrayList<Cluster>();
    private Hashtable _clustersByCentroids = new Hashtable();
    private int _k;


    public KNN(ArrayList<String[]> testInstances,
            ArrayList<String[]> trainInstances,
            ArrayList<String> attributes,
            String outFile,
            String k)
    {
        this._testInstances=testInstances;
        this._trainInstances=trainInstances;
        this._attributes=attributes;
        this._k=Integer.parseInt(k);

        makeClusters();
        findClosestTestPoints();
        assignMembers();
        sortClustersBasedOnDistances();
        start();
        removeDuplicates();
    }

    private void makeClusters()
    {
        for(String[] inst : _testInstances)
        {
            Cluster cluster = new Cluster();
            cluster.setCentroid(inst);
            _clusters.add(cluster);
            _clustersByCentroids.put(inst,cluster);
        }
    }

    private void findClosestTestPoints()
    {
        //this function is optimized, reusing distances between pairs
        Distances dist = new Distances();

        double closestDist = 0.0;
        int closestInstanceIndx = 0;
        boolean first=true;

        for(int testIndxA=0;testIndxA<_testInstances.size();testIndxA++)
        {
            for(int testIndxB=0;testIndxB<_testInstances.size();testIndxB++)
            {
                //don't compare an instance with itself
                if(testIndxA != testIndxB)
                {
                    double currentDist = dist.euclidean(_testInstances.get(testIndxA), _testInstances.get(testIndxB));
                    if(first){closestDist=currentDist; closestInstanceIndx=testIndxB; first=false;}
                    else{
                        if(currentDist < closestDist)
                        {
                            closestInstanceIndx=testIndxB;
                            closestDist=currentDist;
                        }
                    }
                }
            }
            //add to our chain list the closest test instance from test instance A, and reset as first
            _testChain.put(_testInstances.get(testIndxA), _testInstances.get(closestInstanceIndx));
            first=true;
        }
    }


    private void assignMembers()
    {
       Distances distance = new Distances();

       double newDist = 0;
       double oldDist = 0;
       int indx = 0;
       boolean firstCluster;

       for(int trainindx=0; trainindx<_trainInstances.size();trainindx++)
       {
           firstCluster = true;
           String[] instance = _trainInstances.get(trainindx);

           for(int clindx=0;clindx<_clusters.size();clindx++)
           {
                String[] centroid = _clusters.get(clindx).getCentroid();

                if(firstCluster)
                {
                    oldDist=distance.euclidean(instance, centroid);
                    indx=clindx;
                    firstCluster=false;
                }else
                {
                    newDist=distance.euclidean(instance, centroid);
                    if(newDist < oldDist){indx=clindx;oldDist=newDist;}
                }

           }

            //finished checking against all centroids
            _clusters.get(indx).getMembers().add(instance);

            //cache this distance for later use
            TestTrainPair ttp = new TestTrainPair(indx,trainindx,oldDist);
            _testTrainPair.put(new Integer(trainindx),ttp);

       }
    }

    private void sortClustersBasedOnDistances()
    {
        ArrayList<Double> tmpDists = new ArrayList<Double>();
        ArrayList<TestTrainPair> tmpTtp = new ArrayList<TestTrainPair>();
        ArrayList<Integer> trainingIndices = new ArrayList<Integer>();
        Hashtable tmpPair = new Hashtable();

        for(int clindx=0;clindx<_clusters.size();clindx++)
        {
            if(_clusters.get(clindx).getMembers().size() < 1) {continue;}
            
            for(int member=0;member<_clusters.get(clindx).getMembers().size();member++)
            {
                TestTrainPair ttp = (TestTrainPair)
                        _testTrainPair.get(_trainInstances.indexOf(_clusters.get(clindx).getMembers().get(member)));

                Double dist = new Double(ttp.dist);
                tmpDists.add(dist);
                tmpTtp.add(ttp);
                trainingIndices.add(ttp.trainIndx);
                tmpPair.put(dist, ttp.trainIndx);
            }

            //sort by distances
            Collections.sort(tmpDists);
            Cluster cluster = _clusters.get(clindx);

            //get ready to rebuild the clusters
            cluster.getMembers().clear();

            boolean found;

            //distances naturally go from small to large
            for(Double dist : tmpDists)
            {
                String[] tmpinst = _trainInstances.get((Integer)tmpPair.get(dist));
                cluster.getMembers().add(tmpinst);
            }

            _finalClusters.add(cluster);

            tmpDists.clear();
            tmpTtp.clear();
            trainingIndices.clear();
            tmpPair.clear();
        }
    }

    private void start()
    {
        for(Cluster cluster : _finalClusters)
        {
            ArrayList<String[]> tmp = findKClosest(cluster);
            for(String[] inst : tmp)
            {
                getFinalInstances().add(inst);
            }
        }
    }

    private ArrayList<String[]> findKClosest(Cluster cluster)
    {
        ArrayList<String[]> tmpInsts = new ArrayList<String[]>();

        if(cluster.getMembers().size() == _k){tmpInsts=cluster.getMembers();}
        else if(cluster.getMembers().size() > _k)
        {
            for(int i=0;i<_k;i++)
            {
                tmpInsts.add(cluster.getMembers().get(i));
            }
        }else if(cluster.getMembers().size() < _k)
        {
            int count=0;

            for(int i=0;i<cluster.getMembers().size();i++)
            {
               tmpInsts.add(cluster.getMembers().get(i));
               count++;
            }

            while(count < _k)
            {
                //we're on a different cluster now, look to see the closest centroid
               String[] closest=(String[])_testChain.get(cluster.getCentroid());
              
               cluster=getClusterByCentroid(closest);

               for(int i=0;i<cluster.getMembers().size();i++)
               {                   
                   if(count < _k)
                   {
                       tmpInsts.add(cluster.getMembers().get(i));
                   }else break;

                   count++;
               }
            }
        }

        return tmpInsts;
    }

    private Cluster getClusterByCentroid(String[] centroid)
    {
        return (Cluster)_clustersByCentroids.get(centroid);
    }

    private void removeDuplicates()
    {
        ArrayList<String[]> seen = new ArrayList<String[]>();

        for(String[] inst : getFinalInstances())
        {
            if(!seen.contains(inst))
            {
                seen.add(inst);
            }
        }

        //clear the final list, and add only unique ones
        getFinalInstances().clear();
        _finalInstances=seen;
    }

    /**
     * @return the _finalInstances
     */
    public ArrayList<String[]> getFinalInstances() {
        return _finalInstances;
    }

    class TestTrainPair
    {
        int testIndx;
        int trainIndx;
        double dist;

        TestTrainPair(int testIndx, int trainIndx, double dist)
        {
            this.testIndx=testIndx;
            this.trainIndx=trainIndx;
            this.dist=dist;
        }
    }

}