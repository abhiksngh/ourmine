
package reduce;

import java.util.Enumeration;
import java.util.Hashtable;
import output.OutToSparseArff;
import parse.Instance;
import parse.ParseSparseArffToHashTable;

/**
 *
 * @author Adam Nelson
 */
public class Main {

    /**
     * @param args the command line arguments
     */
    public static void main(String[] args) {
        Main main = new Main();
        main.parseFlags(args);
    }
    
    private void parseFlags(String[] args)
    {
        String reducer = args[0];

        if(reducer.equalsIgnoreCase("-tfidf"))
        {
            String inarff = args[1];
            String numattrs = args[2];
            String outarff = args[3];

            ParseSparseArffToHashTable parse = new ParseSparseArffToHashTable(inarff);

            Hashtable instances = parse.getInstances();
            Hashtable attrs     = parse.getAttributes();

            int n = Integer.parseInt(numattrs);

            Tfidf tfidf = new Tfidf(instances, attrs, n);
            new OutToSparseArff(tfidf.getFinalInstances(), tfidf.getFinalAttributes(), outarff);
            
        }
    }





}
