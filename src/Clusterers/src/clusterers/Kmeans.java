package clusterers;

import cluster.Cluster;
import Distances.Distances;
import java.util.ArrayList;
import java.util.Collections;
import java.util.Enumeration;
import java.util.Hashtable;
import java.util.Random;

/**
 *
 * @author Adam Nelson
 */
public class Kmeans {

    private ArrayList<Cluster> _clusters = new ArrayList<Cluster>();
    private ArrayList<String[]> _instances = new ArrayList<String[]>();

    private int _k;

    public Kmeans(String k, ArrayList<String[]> instances)
    {

        this._k=Integer.parseInt(k);
        this._instances=instances;

        if(selectInitialCentroids())
        {
            assignMembers();
            cluster();
        }else
        {
            //the instances size are too small
            Cluster cluster = new Cluster();
            cluster.setCentroid(_instances.get(0));

            _clusters.add(cluster);
        }
    }

    public Kmeans(String k, ArrayList<String[]> instances, boolean kpp)
    {
        this._k=Integer.parseInt(k);
        this._instances=instances;

        if(kpp && selectInitialCentroidsViaKmeanspp())
        {
            assignMembers();
            cluster();
        }else
        {
            //the instances size are too small
            Cluster cluster = new Cluster();
            cluster.setCentroid(_instances.get(0));
            _clusters.add(cluster);
        }
    }

    public String[] computeNewCentroid(Cluster cluster)
    {

        //get instance length
        int instLength = getInstances().get(0).length;
        double tmpVal = 0.0;
        double[] tmpMean = new double[instLength];
        String[] centroid = new String[instLength];

        if(cluster.getMembers().size() == 1)
        {
            return cluster.getMembers().get(0);
        }else if(cluster.getMembers().size() == 0)
        {
            return cluster.getCentroid();
        }

            //for each member in the cluster...
            for(int i=0;i<instLength;i++)
            {
                for(String[] instance : cluster.getMembers())
                {
                    try
                    {
                        tmpVal+=Double.parseDouble(instance[i]);
                    }catch(Exception e)
                    {
                        //nominal attribute
                        tmpVal+=instance[i].length();
                    }
                }
                tmpMean[i]=tmpVal;
                tmpVal=0.0;
            }

            double numMembers = (double)cluster.getMembers().size();

            for(int j=0;j<tmpMean.length;j++)
            {
                tmpMean[j]=tmpMean[j]/numMembers;
            }

        //finish with an array of strings
        for(int y=0;y<instLength;y++)
        {
              centroid[y]=tmpMean[y]+"";
        }
        return centroid;
    }

    public boolean converged(ArrayList<String[]> oldCentroids, ArrayList<String[]> newCentroids)
    {

        //for each cluster
        for(int i=0;i<newCentroids.size();i++)
        {
            String[] newCentroid = newCentroids.get(i);
            String[] oldCentroid = oldCentroids.get(i);

            for(int j=0;j<newCentroid.length;j++)
            {   
                if(!(newCentroid[j].equals(oldCentroid[j])))
                {
                    return false;
                }
            }
        }

        return true;
    }

    public ArrayList<String[]> copyCentroids(ArrayList<Cluster> src)
    {
        ArrayList<String[]> dest = new ArrayList<String[]>();

        for(Cluster cluster : src)
        {
            dest.add(cluster.getCentroid());
        }

        return dest;
    }

    public void cluster()
    {

      boolean converged = false;
      int iterations = 0;
      
      ArrayList<String[]> oldCentroids = new ArrayList<String[]>();
      ArrayList<String[]> newCentroids = new ArrayList<String[]>();

      while(!converged)
      {
          oldCentroids.clear();
          newCentroids.clear();

          oldCentroids=copyCentroids(getClusters());

          for(Cluster cluster : getClusters())
          {
            newCentroids.add(computeNewCentroid(cluster));
          }
          
            getClusters().clear();

          for(String[] centroid : newCentroids)
          {
              Cluster cluster = new Cluster();
              cluster.setCentroid(centroid);

              getClusters().add(cluster);
          }

          assignMembers();
          converged=converged(oldCentroids, newCentroids);
          iterations++;

          //if(iterations > 100){converged=true;}
      }

      //System.out.println("ITERATIONS: " + iterations);
      //for(Cluster c : _clusters){System.out.println(c.getMembers().size());}
    }

    public void assignMembers()
    {
       Distances distance = new Distances();
       
       double newDist = 0;
       double oldDist = 0;
       int indx = 0;
       boolean firstCluster;

       for(String[] instance : getInstances())
       {
           firstCluster = true;

           for(int i=0;i<getClusters().size();i++)
           {
                String[] centroid = getClusters().get(i).getCentroid();

                if(firstCluster)
                {
                    oldDist=distance.euclidean(instance, centroid);
                    indx=i;
                    firstCluster=false;
                }else
                {
                    newDist=distance.euclidean(instance, centroid);
                    if(newDist < oldDist){indx=i;oldDist=newDist;}
                }
                
           }
           
           //finished checking against all centroids
            getClusters().get(indx).getMembers().add(instance);
       }
    }

    public boolean selectInitialCentroids()
    {
        if(_k >getInstances().size())
        {
            if(getInstances().size() <= 1){return false;}
            _k=getInstances().size()/2;
            System.out.println("WARNING: The given value for k is greater than the number of instances.");
            System.out.println("Instances=" + getInstances().size() + ". Setting k to a smaller value (k="+_k+")");
        }


        Random rand = new Random();

        //keep a list of the indices we've already selected for our initial centroids
        ArrayList<Integer> selected = new ArrayList<Integer>();

        for(int i=0;i<_k;i++)
        {
            Cluster c = new Cluster();
            int indx = rand.nextInt(getInstances().size());

            //forces us to select a different centroid each time. egs, we don't want to select
            //index value of 4, 20 times, and have 20 clusters whose centroid is the same
            while(selected.contains(indx))
            {
                indx=rand.nextInt(getInstances().size());
            }
            selected.add(indx);

            c.setCentroid(getInstances().get(indx));
            getClusters().add(c);
        }
        return true;
    }

    public boolean selectInitialCentroidsViaKmeanspp()
    {
        if(_k >getInstances().size())
        {
            if(getInstances().size() <= 1){return false;}
            _k=getInstances().size();
            System.out.println("WARNING: The given value for k is greater than the number of instances.");
            System.out.println("Setting k to a smaller value (k="+_k+")");
        }

        boolean firstRun=true;

        Random rand = new Random();
        ArrayList<String[]> chosenCenters = new ArrayList<String[]>();
        Distances dists = new Distances();

        //start with one here, because you select the first centroid in the loop
        for(int i=1;i<_k;i++)
        {
            if(firstRun)
            {
                //select a random point
                int currentCenterIndx=rand.nextInt(getInstances().size());
                chosenCenters.add(_instances.get(currentCenterIndx));
                firstRun=false;
            }

            //get most recent chosen center
            String[] currentCenter=chosenCenters.get(chosenCenters.size()-1);
            Hashtable distsFromCenter = new Hashtable();

            double distTotal = 0;

            for(String[] inst : getInstances())
            {
                if(!inst.equals(currentCenter))
                {
                    double currentDist = dists.euclidean(inst, currentCenter);
                    distTotal+=currentDist;
                    distsFromCenter.put(inst, currentDist);
                }
            }

            double bestProb = 0;
            String[] bestInst = new String[getInstances().get(0).length];

            Enumeration e = distsFromCenter.keys();
            ArrayList<Double> probList = new ArrayList<Double>();
            Hashtable indxAndProb = new Hashtable();

            //select new center
            while(e.hasMoreElements())
            {
                Object element = e.nextElement();
                double d = (Double)distsFromCenter.get(element);
                double prob = (d*d)/(distTotal*distTotal);
                probList.add(prob);
                indxAndProb.put(prob, element);
            }

            //sort and select a random one to be the next center
            Collections.sort(probList);

            //step
            double prob = probList.get(rand.nextInt(probList.size()-1)+1);
            Object ob = (Integer)indxAndProb.get(prob);
            bestInst=(String[])distsFromCenter.get(ob);

            //add the next best center
            chosenCenters.add(bestInst);
        }

        //now make these centers centroids
        for(String[] inst : chosenCenters)
        {
            Cluster cluster = new Cluster();
            cluster.setCentroid(inst);
            getClusters().add(cluster);
        }

        return true;
    }

    /**
     * @return the _clusters
     */
    public ArrayList<Cluster> getClusters() {
        return _clusters;
    }

    /**
     * @return the _instances
     */
    public ArrayList<String[]> getInstances() {
        return _instances;
    }

}
