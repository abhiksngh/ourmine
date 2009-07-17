package output;

import java.io.FileWriter;
import java.io.IOException;
import java.util.ArrayList;

/**
 *
 * @author Adam Nelson
 */
public class OutToSparseArff {

    public OutToSparseArff(ArrayList<String> instances, ArrayList<String> attributes, String outFileName)
    {
        try
        {
            writeToArff(instances, attributes, outFileName);
        }catch(Exception e)
        {
            System.out.println("The file could not be written as " + outFileName);
            System.out.println("Please be sure to check the name of the output file");
        }
    }

    private void writeToArff(ArrayList<String> instances,
            ArrayList<String> attributes,
            String outFileName) throws IOException
    {
        FileWriter outFile = new FileWriter(outFileName);
        StringBuilder builder = new StringBuilder();

        //get just the file name without the extension
        String[] path = outFileName.split("/");
        String tmpout = path[path.length-1];

        //split was not working here for some reason
        String relation="";
        for(int j=0;j<tmpout.length();j++)
        {
            if(tmpout.substring(j).contains("."))
            {
                continue;
            }else
            {
                relation=tmpout.substring(0,j-1);
                break;
            }
        }

        builder.append("@relation " + relation + "\n");

        //add attributes & instances
        for(String attr : attributes){builder.append(attr + "\n");}
        builder.append("@data\n");
        for(String inst : instances){builder.append("{" + inst + "}" + "\n");}

        outFile.write(builder.toString());
        outFile.flush();
        outFile.close();
    }

}
