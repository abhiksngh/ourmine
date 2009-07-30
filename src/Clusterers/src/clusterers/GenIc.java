
package clusterers;

import Distances.Distances;
import analysis.Similarities;
import cluster.Cluster;
import java.util.ArrayList;
import java.util.Random;

/**
 *
 * @author Adam Nelson
 */
public class GenIc {

    private ArrayList<String[]> _instances;
    private ArrayList<CandidateCenter> _centers = new ArrayList<CandidateCenter>();
    private int _m, _n;
    private ArrayList<Cluster> _clusters = new ArrayList<Cluster>();

    public GenIc(ArrayList<String[]> instances, String m, String n)
    {
        this._instances=instances;
        this._m=Integer.parseInt(m);
        this._n=Integer.parseInt(n);

        initialize();
        incrementalCluster();
        assignMembers();
    }

    public void initialize()
    {
        //select initial candidate centers randomly
        ArrayList<Integer> taken = new ArrayList<Integer>();
        Random rand = new Random();

        for(int c=0;c<_m;c++)
        {
            int centerIndx=rand.nextInt(_m);
            while(taken.contains(centerIndx))
            {
                centerIndx=rand.nextInt(_m);
            }

            CandidateCenter cc = new CandidateCenter();
            cc._weight=1;
            cc._center=getInstances().get(centerIndx);

            _centers.add(cc);
            
        }
    }

    public void incrementalCluster()
    {
       int count = 0;

       for(String[] inst : getInstances())
       {
           count++;
           CandidateCenter center = closestCenter(inst);

           for(int i=0;i<center._center.length;i++)
           {
               float w=center._weight;
               double ci = 0.0;
               double pi = 0.0;

               try
               {
                    ci=Double.parseDouble(center._center[i]);
               }catch(Exception ex)
               {
                    ci=1.0;
               }
               
               try
               {
                    pi=Double.parseDouble(inst[i]);
               }catch(Exception ex)
               {
                    pi=1.0;
               }

               center._center[i]=(w*ci+pi)/(w+1)+"";
           }

           center._weight++;
           
           if(count%_n<0.01)
           {
               updateCenters();
           }
       }
    }

    public void updateCenters()
    {
        Random random = new Random();

         double allCenterWeights = 0.0;
         for(CandidateCenter c : _centers){allCenterWeights+=c._weight;}

        for(int i=0;i<_centers.size();i++)
        {
            CandidateCenter center = _centers.get(i);

            double survivalProb = center._weight/allCenterWeights;
            double randomVal=random.nextDouble(); //select value from 0-1

            //if greater than, keep the center, else get rid of it and pick a new one
            if(survivalProb<randomVal)
            {
                int badCenterIndx = getInstances().indexOf(center);
                _centers.remove(center);

                int newCenterIndx = random.nextInt(getInstances().size());

                //don't pick the same center again!
                while(newCenterIndx==badCenterIndx)
                {
                    newCenterIndx = random.nextInt(getInstances().size());
                }

                CandidateCenter newCenter = new CandidateCenter();
                newCenter._center=_instances.get(newCenterIndx);
                newCenter._weight=1;
                _centers.add(newCenter);
            }
        }
    }

    public void assignMembers()
    {
        int closeClusterIndx=0;
        double closestDist=0.0;
        double newDist=0.0;
        boolean first=true;
        Distances dist = new Distances();

        for(CandidateCenter center : _centers)
        {
            Cluster cluster = new Cluster();
            cluster.setCentroid(center._center);
            getClusters().add(cluster);
        }

        for(String[] inst : getInstances())
        {
            first=true;
            
            for(int c=0;c<getClusters().size();c++)
            {
                if(first)
                {
                    closestDist=dist.euclidean(inst, getClusters().get(c).getCentroid());
                    closeClusterIndx=c;
                    first=false;
                }else
                {
                    newDist=dist.euclidean(inst, getClusters().get(c).getCentroid());
                    if(newDist<closestDist)
                    {
                        closestDist=newDist;
                        closeClusterIndx=c;
                    }
                }
            }

            //add the current instance to the best cluster
            getClusters().get(closeClusterIndx).getMembers().add(inst);
        }
    }

    public CandidateCenter closestCenter(String[] p)
    {
        int indx = 0;
        double shortestDist=0.0;
        double newDist=0.0;
        boolean first=true;

        Distances dists = new Distances();
        CandidateCenter closestCenter = new CandidateCenter();

        for(CandidateCenter center : _centers)
        {
            if(first)
            {
                shortestDist=dists.euclidean(center._center, p);
                closestCenter=center;
                first=false;
            }else
            {
                newDist=dists.euclidean(center._center, p);

                if(newDist<shortestDist)
                {
                    shortestDist=newDist;
                    closestCenter=center;
                }
            }
        }

        return closestCenter;
    }

    /**
     * @return the _instances
     */
    public ArrayList<String[]> getInstances() {
        return _instances;
    }

    /**
     * @return the _clusters
     */
    public ArrayList<Cluster> getClusters() {
        return _clusters;
    }


    class CandidateCenter
    {
        String[] _center;
        int _weight;
    }

}
