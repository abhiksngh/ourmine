
package analysis;

import Distances.Distances;
import cluster.Cluster;
import java.util.ArrayList;

/**
 *
 * @author Adam Nelson
 */
public class Similarities {

    public Similarities(String clusterer, ArrayList<Cluster> clusters)
    {
       double interSim = -Math.log(computeInterClusterSimilarities(clusters));
       double intraSim = -Math.log(computeIntraClusterSimilarities(clusters));

       System.out.println(clusterer + ":InterSim=" + interSim + ",IntraSim=" + intraSim);
    }

    public double computeIntraClusterSimilarities(ArrayList<Cluster> clusters)
    {
        double finalSim = 0.0;

        for(Cluster cluster : clusters)
        {
            finalSim+=intraClusterSimilarity(cluster);
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
                finalSim+=interClusterSimilarity(clusterA, clusterB);
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
                similarity+=(dist.cosineSimilarity(c1Mem, c2Mem)+1.0)/2.0;
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
                similarity+=(dist.cosineSimilarity(inst1, inst2)+1.0)/2.0;
            }
        }

        return similarity;
    }
}
