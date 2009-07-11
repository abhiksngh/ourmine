
package analysis;

import Parse.ParseClassFile;
import java.io.FileReader;
import java.util.ArrayList;
import java.util.Collections;
import java.util.Enumeration;
import java.util.Hashtable;
import java.util.Scanner;

/**
 *
 * @author Adam Nelson
 */
public class Purity {

    private Hashtable _instancesAndClassesFromClassFile = new Hashtable();
    private Hashtable _instancesAndClassesFromArffFile = new Hashtable();

    public Purity(String arffFile, String classFile)
    {
        _instancesAndClassesFromClassFile=new ParseClassFile(classFile).getInstAndClass();
        _instancesAndClassesFromArffFile=parseSparseArffForPurities(arffFile);

        System.out.println(overallPurity());

    }


    private Hashtable parseSparseArffForPurities(String arffFile)
    {
        Hashtable tmpHash = new Hashtable();

        try
        {
            Scanner scanner = new Scanner(new FileReader(arffFile));

            while(scanner.hasNextLine())
            {
                String line=scanner.nextLine();

                if(line.startsWith("{"))
                {
                    //trim braces
                    line=line.substring(1,line.length()-1);

                    String[] splitLine = line.split(",");

                    //get instance numbers and cluster ids from the arff
                    String instNum = splitLine[0];
                    String clusterId = splitLine[splitLine.length-1];

                    //remove the word "Cluster" from the arff, and get just the id
                    clusterId=clusterId.substring(7,clusterId.length());

                    tmpHash.put(Integer.parseInt(instNum), Integer.parseInt(clusterId));

                    //System.out.println("instance number: " + instNum + " and cluster num: " + clusterId);
                }
            }

        }catch(Exception e)
        {
            System.out.println("File could not be found as " + arffFile);
        }

        return tmpHash;
    }
    
    private double overallPurity()
    {
        double purity=0;
        float dataSize=_instancesAndClassesFromClassFile.size();
        int currentCluster=0;
        int seenInstances=0;
        
        Enumeration enumArffFile;

        Hashtable tmpHashArff = new Hashtable();

        while(seenInstances<_instancesAndClassesFromArffFile.size() &&
                seenInstances<_instancesAndClassesFromClassFile.size())
        {
            enumArffFile = _instancesAndClassesFromArffFile.keys();

            //just organize the cluster here...
            //hashtable of this cluster (instance num=k, cluster=v)
            while(enumArffFile.hasMoreElements())
            {
                Object element = enumArffFile.nextElement();
                int cl=(Integer)_instancesAndClassesFromArffFile.get(element);
                if(cl==currentCluster)
                {
                    tmpHashArff.put(element,cl);
                    seenInstances++;
                }
            }

            ArrayList<Integer> classesInCluster = new ArrayList<Integer>();
            Enumeration enumCluster = tmpHashArff.keys();
            
            //make a list for this cluster which is the number of instances whose class is X in the cluster
            while(enumCluster.hasMoreElements())
            {
                Object instance = enumCluster.nextElement();
                classesInCluster.add((Integer)_instancesAndClassesFromClassFile.get(instance));
            }

            purity+=(((tmpHashArff.size()*1.0)/dataSize) * purity(classesInCluster)*1.0);
            tmpHashArff.clear();
            currentCluster++;
        }
        return purity;
    }
   
    private int purity(ArrayList<Integer> classesInCluster)
    {
        return findMostFrequentValCount(classesInCluster);
    }

    private int findMostFrequentValCount(ArrayList<Integer> list)
    {

        int currentVal=0;
        int lastVal=0;
        int currentCount=1;
        int maxCount=1;

        Collections.sort(list);

        if(list.size()==1){return 1;}

        for(int i=0;i<list.size();i++)
        {
            if(i==0)
            {
                currentVal=list.get(i);
                lastVal=currentVal;
            }else if(i==list.size()-1)
            {
                currentVal=list.get(i);
                if(currentVal==lastVal)
                {
                    currentCount++;
                }
                if(currentCount>maxCount){maxCount=currentCount;}
            }else
            {
                currentVal=list.get(i);
                if(currentVal==lastVal)
                {
                    currentCount++;
                }else
                {
                    if(currentCount>maxCount){maxCount=currentCount;}
                    currentCount=1;
                }
                lastVal=currentVal;
            }


        }
        return maxCount;
    }


}
