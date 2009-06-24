package Parse;

import java.io.FileNotFoundException;
import java.io.FileReader;
import java.util.ArrayList;
import java.util.Scanner;

/**
 *
 * @author Adam Nelson
 */
public class ParseSparseArff {

    private ArrayList<String[]> _instances;
    private ArrayList<String> _attributes = new ArrayList<String>();

    public ParseSparseArff(String file)
    {

        try{
        Scanner attrscan = new Scanner(new FileReader(file));
        Scanner instscan = new Scanner(new FileReader(file));
        _instances = parseSparff(attrscan, instscan);

        }catch(FileNotFoundException fnf)
        {
            System.out.println("Sparse Arff file " + file + " could not be located as: " + file);
        }
    }
    
    public ArrayList<String[]> parseSparff(Scanner attrscan, Scanner instscan)
    {
        ArrayList<String[]> instances = new ArrayList<String[]>();

        int attrs = numAttrs(attrscan);
        attrscan.close();


        while(instscan.hasNextLine())
        {
            String line = instscan.nextLine();
            
            if(line.startsWith("{"))
            {
                //trim braces
                line=line.substring(1, line.length()-1);

                String[] pair = line.split(",");
                String[] finalInst = new String[attrs];

                for(String s : pair)
                {
                    String[] tmp = s.split(" ");
                    int indx = Integer.parseInt(tmp[0]);
                    finalInst[indx]=tmp[1];
                }

                //get what's left over, setting them to 0
                for(int i=0;i<attrs;i++)
                    if (finalInst[i]==null)
                        finalInst[i]="0.0";
  
                instances.add(finalInst);
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
            }else if(line.contains("{"))
                break;
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
