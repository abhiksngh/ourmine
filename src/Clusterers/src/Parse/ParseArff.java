package Parse;

import java.io.FileNotFoundException;
import java.io.FileReader;
import java.util.ArrayList;
import java.util.Scanner;

/**
 *
 * @author Adam Nelson
 */
public class ParseArff {

    private ArrayList<String[]> _instances;
    private ArrayList<String> _attributes = new ArrayList<String>();

    public ParseArff(String file)
    {

        try{
        Scanner attrscan = new Scanner(new FileReader(file));
        Scanner instscan = new Scanner(new FileReader(file));
        _instances = parseArff(attrscan, instscan);

        }catch(FileNotFoundException fnf)
        {
            System.out.println("Arff file " + file + " could not be located as: " + file);
        }
    }

    public ArrayList<String[]> parseArff(Scanner attrscan, Scanner instscan)
    {
        ArrayList<String[]> instances = new ArrayList<String[]>();

        int attrs = numAttrs(attrscan);
        attrscan.close();


        while(instscan.hasNextLine())
        {
            String line = instscan.nextLine();

            if(!line.startsWith("@") && !line.startsWith("%") && !line.equals(""))
            {
                if(line.startsWith("{"))
                {
                    //trim braces
                    line=line.substring(1, line.length()-1);
                }
                
               String[] inst = line.split(",");
               instances.add(inst);
            }
        }
        return instances;
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
                getAttributes().add(line);
            }
        }
        return attrs;
    }

    /**
     * @return the _attributes
     */
    public ArrayList<String> getAttributes() {
        return _attributes;
    }

    /**
     * @return the _instances
     */
    public ArrayList<String[]> getInstances() {
        return _instances;
    }

}

