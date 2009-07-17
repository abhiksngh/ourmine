/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package parse;

import java.io.FileNotFoundException;
import java.io.FileReader;
import java.util.Hashtable;
import java.util.Scanner;

/**
 *
 * @author Adam Nelson
 */
public class ParseSparseArffToHashTable {

    private Hashtable _instances = new Hashtable();
    private Hashtable _attributes = new Hashtable();

    public ParseSparseArffToHashTable(String arffFile)
    {
        try
        {
            parse(arffFile);
        }catch(Exception e)
        {
            System.out.println("File could not be located as " + arffFile);
        }
    }

    private void parse(String arffFile) throws FileNotFoundException
    {
        Scanner scan = new Scanner(new FileReader(arffFile));

        Integer attrcount, instcount;
        attrcount=instcount=0;

        while(scan.hasNextLine())
        {
            String line = scan.nextLine();

            if(line.startsWith("@attribute"))
            {
                attrcount++;
                getAttributes().put(attrcount.toString(), line);
            }else if(line.startsWith("{"))
            {
                instcount++;
                
                Instance instObj = new Instance();

                //trim braces
                line=line.substring(1, line.length()-1);

                String[] inst = line.split(",");

                for(int i=0;i<inst.length;i++)
                {
                    String[] group=inst[i].split(" ");
                    String attrNum=group[0];
                    String freq=group[1];

                    instObj.getTerms().put(attrNum.toString(), freq);
                }

                instObj.setInstNum(instcount);
                getInstances().put(instcount.toString(), instObj);
            }else continue;
        }
    }

    /**
     * @return the _instances
     */
    public Hashtable getInstances() {
        return _instances;
    }

    /**
     * @return the _attributes
     */
    public Hashtable getAttributes() {
        return _attributes;
    }
}
