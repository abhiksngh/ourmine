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

    public void outToSparseArff(ArrayList<String> attributes, ArrayList<Cluster> clusters, String outfile)
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
                    int attrindx = 0;
                    builder=new StringBuilder();
                    builder.append("{");

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
}
