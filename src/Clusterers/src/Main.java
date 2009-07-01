
import Parse.ParseSparseArff;
import analysis.Similarities;
import clusterers.Canopy;
import clusterers.GenIc;
import clusterers.Kmeans;
import java.io.FileNotFoundException;
import java.io.FileReader;
import java.util.ArrayList;
import java.util.Scanner;
import output.Output;

/**
 *
 * @author Adam Nelson
 */
public class Main {

    private ArrayList<String[]> _instances;
    private ArrayList<String> _attributes;

    public static void main(String[] args)
    {
        new Main().comParse(args);
    }

    public void comParse(String args[])
    {
        String clusterer = args[0];

        //kmeans
        if(clusterer.equalsIgnoreCase("-k"))
        {
            String k = args[1];
            String infile = args[2];
            String outfile = args[3];
            String kpp;
            try
            {
                kpp = args[4];
            }catch(Exception e)
            {
                kpp = " ";
            }


            if(isSparseArff(infile))
            {
                ParseSparseArff psa = new ParseSparseArff(infile);
                _instances=psa.getInstances();
                _attributes=psa.getAttributes();
            }
            
          
            if(kpp.equalsIgnoreCase("-kpp"))
            {
                //use k++ for selecting initial centroids
                Kmeans kmeans = new Kmeans(k, _instances, true);
                Output out = new Output();
                out.outToSparseArff(_attributes, kmeans.getClusters(), outfile);
            }else
            {
                  //run kmeans on parsed instances
                Kmeans kmeans = new Kmeans(k, _instances);
                Output out = new Output();
                out.outToSparseArff(_attributes, kmeans.getClusters(), outfile);
            }


        }else if(clusterer.equalsIgnoreCase("-c"))
        {
            String k = args[1];
            String infile = args[4];
            String outfile = args[5];
            String outerThresholdSimilarityPercentage = args[2];
            String innerThresholdSimilarityPercentage = args[3];

            if(isSparseArff(infile))
            {
                ParseSparseArff psa = new ParseSparseArff(infile);
                _instances=psa.getInstances();
                _attributes=psa.getAttributes();
            }

            //run canopy on parsed instances
            Canopy canopy = new Canopy(_instances, k, 
                    outerThresholdSimilarityPercentage,
                    innerThresholdSimilarityPercentage);

            Output out = new Output();
            out.outToSparseArff(_attributes, canopy.getClusters(), outfile);

            
        }else if(clusterer.equalsIgnoreCase("-g"))
        {
            String infile = args[3];
            String outfile = args[4];
            String m = args[1];
            String n = args[2];

            if(isSparseArff(infile))
            {
                ParseSparseArff psa = new ParseSparseArff(infile);
                _instances=psa.getInstances();
                _attributes=psa.getAttributes();
            }

            GenIc genic = new GenIc(_instances, m, n);
            Output out = new Output();
            out.outToSparseArff(_attributes,genic.getClusters(),outfile);

        }else if(clusterer.equalsIgnoreCase("-sim"))
        {
            String arffFile = args[1];

            try
            {
                new Similarities(arffFile);
            }catch(FileNotFoundException fnf){}
        }


    }

    public boolean isSparseArff(String file)
    {
        boolean sparse = false;

        try{
        Scanner scan = new Scanner(new FileReader(file));

        while(scan.hasNextLine())
        {
            if(scan.nextLine().startsWith("{")) sparse=true;
        }
        }catch(FileNotFoundException fnf)
        {
            System.out.println("Sparse Arff file " + file + " could not be located as: " + file);
        }
        return sparse;
    }
}
