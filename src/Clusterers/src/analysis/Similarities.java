
package analysis;

import Distances.Distances;
import Parse.ParseArff;
import Parse.ParseSparseArff;
import cluster.Cluster;
import java.io.FileNotFoundException;
import java.io.FileReader;
import java.util.ArrayList;
import java.util.Scanner;

/**
 *
 * @author Adam Nelson
 */
public class Similarities {

    private ArrayList<String[]> _instances = new ArrayList<String[]>();

    public Similarities(String arffFile) throws FileNotFoundException
    {
        ArrayList<Cluster> clusters = new ArrayList<Cluster>();

        //get ClusterIds
        FileReader reader = new FileReader(arffFile);
        Scanner scanner = new Scanner(reader);

        String clusterIds = "";
        while(scanner.hasNextLine())
        {
            clusterIds=scanner.nextLine();

            if(clusterIds.contains("@attribute cluster "))
            {
                clusterIds=clusterIds.substring(20, clusterIds.length()-1);
                break;
            }
        }

        parseSparseArffForSimilarities(arffFile);
       
        for(String clusterId :  clusterIds.split(","))
        for(String[] inst : _instances)
        {    
           if(clusterId.equals(inst[inst.length-1]))
           {
               Cluster cluster = new Cluster();
               cluster.getMembers().add(inst);
               clusters.add(cluster);
           }
             
        }

        //actually, dissimilarities.. make negative for a better estimation
       double interSim = computeInterClusterSimilarities(clusters);
       double intraSim = computeIntraClusterSimilarities(clusters);

       System.out.println("InterSim=" + interSim + ",IntraSim=" + intraSim);
         
    }

    public void parseSparseArffForSimilarities(String file) throws FileNotFoundException
    {
        Scanner instscan = new Scanner(new FileReader(file));
        Scanner attscan = new Scanner(new FileReader(file));

        int numAttrs = numAttrs(attscan);
        attscan.close();

        while(instscan.hasNextLine())
        {
            String line = instscan.nextLine();
            if(line.startsWith("{"))
            {
               //trim braces
                line=line.substring(1, line.length()-1);
                int lastindx = 0;
                String[] pair = line.split(",");
                String[] finalInst = new String[numAttrs];

                for(String s : pair)
                {
                    //we have an instance index marker
                    if(!s.contains(" ")){continue;}
                    String[] tmp = s.split(" ");
                    try
                    {
                        int indx = Integer.parseInt(tmp[0]);
                        finalInst[indx]=tmp[1];
                        lastindx=indx;
                    }catch(Exception e){finalInst[lastindx]="0.0";lastindx++;}
                }

                //get what's left over, setting them to 0
                for(int i=0;i<numAttrs;i++)
                    if (finalInst[i]==null)
                        finalInst[i]="0.0";

                //place the cluster id at the end
                finalInst[numAttrs-1]=pair[pair.length-1];

                _instances.add(finalInst);
            }
        }
    }

    public int numAttrs(Scanner scan)
    {
        int attrs = 0;

        while(scan.hasNextLine())
        {
            String line = scan.nextLine();
            if(line.contains("@attribute"))
            {
                attrs++;
            }else if(line.contains("{"))
                break;
        }
        return attrs;
    }

    public double computeIntraClusterSimilarities(ArrayList<Cluster> clusters)
    {
        double finalSim = 0.0;

        for(Cluster cluster : clusters)
        {
            finalSim+=(((cluster.getMembers().size()+1.0)*intraClusterSimilarity(cluster))/_instances.size());
        }

        return finalSim;
    }

    public double computeInterClusterSimilarities(ArrayList<Cluster> clusters)
    {
        double finalSim = 0.0;

        for(Cluster clusterA : clusters)
        {
            for(Cluster clusterB : clusters)
            {
                finalSim+=(((clusterA.getMembers().size()+1.0)*interClusterSimilarity(clusterA, clusterB))/_instances.size());
            }
        }
        return finalSim;
    }
    
    public double interClusterSimilarity(Cluster c1, Cluster c2)
    {
        Distances dist = new Distances();
        double similarity = 0.0;

        for(String[] c1Mem : c1.getMembers())
        {
            for(String[] c2Mem : c2.getMembers())
            {
                similarity+=(((dist.cosineSimilarity(c1Mem, c2Mem)+1.0)/2.0)/((c1.getMembers().size()+1.0) * (c2.getMembers().size()+1.0)));
            }
        }
        return similarity;
    }

    public double intraClusterSimilarity(Cluster cluster)
    {
        Distances dist = new Distances();
        double similarity = 0.0;

        for(String[] inst1 : cluster.getMembers())
        {
            for(String [] inst2 : cluster.getMembers())
            {
                similarity+=((((dist.cosineSimilarity(inst1, inst2)+1.0)/2.0))/(cluster.getMembers().size() * cluster.getMembers().size()));
            }
        }

        return similarity;
    }
}
