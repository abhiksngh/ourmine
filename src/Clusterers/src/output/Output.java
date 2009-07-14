/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package output;

import cluster.Cluster;
import java.io.File;
import java.io.FileWriter;
import java.io.IOException;
import java.util.ArrayList;

/**
 *
 * @author Adam Nelson
 */
public class Output {

    private ArrayList<Integer> _seenIndices = new ArrayList<Integer>();

    public void outToArff(ArrayList<String> attributes, ArrayList<Cluster> clusters, String outfile)
    {
        try
        {
           File file = new File(outfile);
           FileWriter writer = new FileWriter(file);
           StringBuilder builder = new StringBuilder();

           writer.write("@relation " + file.getCanonicalPath() + "\n");


           for(String attribute : attributes)
           {
                writer.write(attribute+"\n");
           }

           builder.append("@attribute cluster {");

           for(int i=0;i<clusters.size();i++)
           {
               if(i==clusters.size()-1)
               {
                  builder.append("Cluster"+i+"}\n\n");
               }else builder.append("Cluster"+i+",");
           }

           writer.write(builder.toString());
           writer.write("@data\n");

           int clusterid = 0;

           for(Cluster cluster : clusters)
           {
                for(String[] member : cluster.getMembers())
                {

                    for(String attr : member)
                    {
                         writer.write(attr + ",");
                    }
                    writer.write("Cluster"+clusterid+"\n");
                }

                clusterid++;
           }

           writer.flush();
           writer.close();

        }catch(IOException ioe)
        {
            System.out.println("Could not write to " + outfile + ".");
        }
    }

    public void outToArffWithoutClusters(ArrayList<String> attributes, ArrayList<String[]> instances, String outfile)
    {
          try
        {
           File file = new File(outfile);
           FileWriter writer = new FileWriter(file);
           StringBuilder builder = new StringBuilder();

           writer.write("@relation " + file.getCanonicalPath() + "\n");


           for(String attribute : attributes)
           {
                writer.write(attribute+"\n");
           }

           builder.append("@data\n");

           int clusterid = 0;

           for(String[] inst : instances)
           {
               for(int dim=0;dim<inst.length;dim++)
               {
                   if(dim<inst.length-1) builder.append(inst[dim] + ",");
                   else builder.append(inst[dim] + "\n");
               }
           }

           writer.write(builder.toString());
           writer.flush();
           writer.close();

        }catch(IOException ioe)
        {
            System.out.println("Could not write to " + outfile + ".");
        }
    }

    public void outToSparseArff(ArrayList<String[]> origInstances,
            ArrayList<String> attributes,
            ArrayList<Cluster> clusters,
            String outfile)
    {
        try
        {
           File file = new File(outfile);
           FileWriter writer = new FileWriter(file);
           StringBuilder builder = new StringBuilder();

           writer.write("@relation " + file.getCanonicalPath() + "\n");


           for(String attribute : attributes)
           {
                writer.write(attribute+"\n");
           }

           builder.append("@attribute cluster {");

           for(int i=0;i<clusters.size();i++)
           {
               if(i==clusters.size()-1)
               {
                  builder.append("Cluster"+i+"}\n\n");
               }else builder.append("Cluster"+i+",");
           }

           writer.write(builder.toString());
           writer.write("@data\n");

           int clusterid = 0;

           for(Cluster cluster : clusters)
           {
                for(String[] member : cluster.getMembers())
                {
                    //label the instances based on their original order
                    int origIndx = indexInOriginal(member, origInstances);
                    int attrindx = 0;
                    builder=new StringBuilder();
                    builder.append("{"+origIndx+",");

                    for(String attr : member)
                    {
                        if(attr.equals("0.0"))
                        {
                            attrindx++;
                            continue;
                        }else
                        {
                            builder.append(attrindx + " " + attr + ",");
                            attrindx++;
                        }
                    }

                    writer.write(builder.toString() + "Cluster"+clusterid+"}\n");
                }

                clusterid++;
           }

           writer.flush();
           writer.close();

        }catch(IOException ioe)
        {
            System.out.println("Could not write to " + outfile + ".");
        }
    }

    private int indexInOriginal(String[] A, ArrayList<String[]> instances)
    {
        int index=0;

        for(int i=0;i<instances.size();i++)
        {
            if(instancesEqual(A,instances.get(i)))
            {
                if(!_seenIndices.contains(i))
                {
                    _seenIndices.add(i);
                    index=i;
                    break;
                }
            }
        }

        return index;
    }

    private boolean instancesEqual(String[] A, String[] B)
    {
        for(int i=0;i<A.length;i++)
        {
            if(!A[i].equals(B[i])) return false;
        }
        return true;
    }
}
