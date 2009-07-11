
package clusterers;

import canopies.CanopyStructure;
import cluster.Cluster;
import java.util.ArrayList;

/**
 *
 * @author Adam Nelson
 */
public class Canopy {
   
    private ArrayList<String[]> _instances = new ArrayList<String[]>();
    private ArrayList<String[]> _instancesWithoutACanopy = new ArrayList<String[]>();
    private ArrayList<CanopyStructure> _canopies = new ArrayList<CanopyStructure>();
    private ArrayList<Cluster> _clusters = new ArrayList<Cluster>();
   
    private boolean[][] _invertedIndex;
    private int _outerPercentage, _innerPercentage, _dimensions;

    private final double _T1 = 10;
    private final double _T2 = 5;

    public Canopy(ArrayList<String[]> instances, String k, String outerPercentage, String innerPercentage)
    {
        
        this._instances=instances;
        this._outerPercentage=Integer.parseInt(outerPercentage);
        this._innerPercentage=Integer.parseInt(innerPercentage);
        _dimensions=_instances.get(0).length;

        //copy this instances list
        for(String[] inst : instances)
        {
            _instancesWithoutACanopy.add(inst);
        }

       _invertedIndex = new boolean[_instances.size()][_instances.get(0).length];
       

        constructInvertedIndex();
        produceCanopies();
        clusterCanopiesViaKmeans(k);
        //printCanopies();

    }

    public void clusterCanopiesViaKmeans(String k)
    {
        ArrayList<String[]> tmplist = new ArrayList<String[]>();
        int currentClusterCount = 0;

        for(CanopyStructure canopy : _canopies)
        {
            tmplist.add(canopy.getCanopyCenter());

            for(String[] outer : canopy.getOuterThresholdMembers())
            {
                tmplist.add(outer);
            }

            Kmeans kmeans = new Kmeans(k, tmplist);

            for(Cluster cluster : kmeans.getClusters())
            {
                getClusters().add(cluster);
            }

            tmplist.clear();
        }
    }

    public void printCanopies()
    {
        int numinternal = 0;

        for(CanopyStructure cs : _canopies)
        {
            numinternal+=cs.getInnerThresholdMembers().size();
        }

        System.out.println(numinternal);
        /*
        for(CanopyStructure cs : _canopies)
        {
            System.out.println("CANOPY");

            for(String[] outer : cs.getOuterThresholdMembers())
            {
                System.out.println();

                for(String attr : outer)
                 System.out.print(attr + " , ");
            }

            System.out.println();

            for(String s : cs.getCanopyCenter())
                System.out.print(s + " , ");
            
            System.out.println();
        }
         * */
    }

    public void produceCanopies()
    {
        for(int i=0;i<_instances.size();i++)
        {
            if(_instancesWithoutACanopy.contains(_instances.get(i)))
            {
                recurseOnCanopies(createCanopy(i));
            }
        }
    }

    public void recurseOnCanopies(CanopyStructure canopy)
    {
        while(canopy.getInnerThresholdMembers().size() >= 1)
        {
            CanopyStructure newcan = new CanopyStructure();
            String[] center = selectNewCanopyCenter(_canopies.indexOf(canopy));

            //if the center is null, we must break out and go to another point in the dataset
            //since this ends the current 'chain' of canopies
            if(center==null){break;}

            newcan.setCanopyCenter(center);
            newcan=fillCanopy(newcan);
            _canopies.add(newcan);
            removeCanopyMembersFromList(newcan);
            canopy=newcan;
        }
    }

    public CanopyStructure createCanopy(int instanceIndx)
    {
        String[] canopyCenter = _instances.get(instanceIndx);
        CanopyStructure canopy = new CanopyStructure();

        canopy.setCanopyCenter(canopyCenter);
        CanopyStructure cans = new CanopyStructure();
        cans = fillCanopy(canopy);
        _canopies.add(cans);
        removeCanopyMembersFromList(cans);
        return canopy;
    }

    public String[] selectNewCanopyCenter(int canopyIndx)
    {
        CanopyStructure canopy = _canopies.get(canopyIndx);

        for(String[] member : canopy.getOuterThresholdMembers())
        {
            //select the first instance that isn't in the inner threshold
            if(!canopy.getInnerThresholdMembers().contains(member))
            {
                return member;
            }
        }

        //there are no members that aren't in the inner threshold
        return null;
    }

    public CanopyStructure fillCanopy(CanopyStructure canopy)
    {
        //add to outer threshold members
        for(int instB=0;instB<_instancesWithoutACanopy.size();instB++)
        {
            if(cheapDistanceViaInvertedIndex(_instances.indexOf(canopy.getCanopyCenter()), 
                    _instances.indexOf(_instancesWithoutACanopy.get(instB))) <= _T1)
            {
                canopy.getOuterThresholdMembers().add(_instances.get(instB));
            }
        }

        //add to inner threshold members
        for(String[] member : canopy.getOuterThresholdMembers())
        {
            //we can use 'instance' here as the canopy center (since it was assigned as such above)
            if(cheapDistanceViaInvertedIndex(_instances.indexOf(canopy.getCanopyCenter()),
                    _instances.indexOf(member)) <= _T2)
            {
                canopy.getInnerThresholdMembers().add(member);
            }
        }

        return canopy;
    }
    

    public void constructInvertedIndex()
    {
        for(int inst=0;inst<_instances.size();inst++)
        {
            for(int attr=0;attr<_dimensions;attr++)
            {
                if(_instances.get(inst)[attr].equals("0.0"))
                {
                    _invertedIndex[inst][attr]=false;
                }else
                {
                    _invertedIndex[inst][attr]=true;
                }
            }
        }
    }

    public double cheapDistanceViaInvertedIndex(int inst1Indx, int inst2Indx)
    {
        //note that 0 is exactly similar, and >= T1 is completely  disssimilar
        double dissimilarity = 0.0;

        for(int i=0;i<_dimensions;i++)
        {
            if(!(_invertedIndex[inst1Indx][i] && _invertedIndex[inst2Indx][i])){dissimilarity++;}
        }

        double val = 0.0;

        //step 'function' converts dissimilarity measures using percentage values

        //infinitely far away from the center
        if(dissimilarity > (100-_outerPercentage)*0.01*_dimensions)val=_T1+1;

        //fairly far away from the center
        if(dissimilarity <= (100-_outerPercentage)*0.01*_dimensions)val=_T1;

        //fairly close to the center
        if(dissimilarity <= (100-_innerPercentage)*0.01*_dimensions)val=_T2;
       
        return val;
        
    }

    public void removeCanopyMembersFromList(CanopyStructure canopy)
    {
        //can use outer threshold here, since it contains all members of a canopy,
        //including inner threshold members
        for(String[] inst : canopy.getOuterThresholdMembers())
        if(_instancesWithoutACanopy.contains(inst))
        {
             _instancesWithoutACanopy.remove(inst);
        }

        //remove center as well
        _instancesWithoutACanopy.remove(canopy.getCanopyCenter());
    }

    /**
     * @return the _clusters
     */
    public ArrayList<Cluster> getClusters() {
        return _clusters;
    }

   
}
