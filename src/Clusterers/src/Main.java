
import Parse.ParseArff;
import Parse.ParseSparseArff;
import analysis.Purity;
import analysis.Similarities;
import clusterers.Canopy;
import clusterers.GenIc;
import clusterers.Kmeans;
import filters.KNN;
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

            parseFile(infile);

            if(kpp.equalsIgnoreCase("-kpp"))
            {
                //use k++ for selecting initial centroids
                Kmeans kmeans = new Kmeans(k, _instances, true);
                Output out = new Output();
                out.outToSparseArff(_instances,_attributes, kmeans.getClusters(), outfile);
            }else
            {
                  //run kmeans on parsed instances
                Kmeans kmeans = new Kmeans(k, _instances);
                Output out = new Output();
                out.outToSparseArff(_instances,_attributes, kmeans.getClusters(), outfile);
            }


        }else if(clusterer.equalsIgnoreCase("-c"))
        {
            String k = args[1];
            String infile = args[4];
            String outfile = args[5];
            String outerThresholdSimilarityPercentage = args[2];
            String innerThresholdSimilarityPercentage = args[3];

            parseFile(infile);

            //run canopy on parsed instances
            Canopy canopy = new Canopy(_instances, k, 
                    outerThresholdSimilarityPercentage,
                    innerThresholdSimilarityPercentage);

            Output out = new Output();
            out.outToSparseArff(_instances,_attributes, canopy.getClusters(), outfile);

            
        }else if(clusterer.equalsIgnoreCase("-g"))
        {
            String infile = args[3];
            String outfile = args[4];
            String m = args[1];
            String n = args[2];

            parseFile(infile);

            GenIc genic = new GenIc(_instances, m, n);
            Output out = new Output();
            out.outToSparseArff(_instances,_attributes,genic.getClusters(),outfile);

        }else if(clusterer.equalsIgnoreCase("-sim"))
        {
            String arffFile = args[1];

            try
            {
                new Similarities(arffFile);
            }catch(FileNotFoundException fnf){System.out.println("Could not find file "+arffFile);}

        }else if(clusterer.equalsIgnoreCase("-purity"))
        {
            String arffFile = args[1];
            String classFile = args[2];
            
            Purity pure = new Purity(arffFile,classFile);
        }

        else if(clusterer.equalsIgnoreCase("-knn"))
        {
            String k = args[1];
            String testFile = args[2];
            String trainFile = args[3];
            String outFile = args[4];

            ArrayList<String[]> testInstances = new ArrayList<String[]>();
            ArrayList<String[]> trainInstances = new ArrayList<String[]>();
            ArrayList<String> attributes = new ArrayList<String>();


            //handling the parsing differently here, as it's a special case
            if(isSparseArff(testFile))
            {
                ParseSparseArff psaTest = new ParseSparseArff(testFile);
                testInstances=psaTest.getInstances();
                attributes=psaTest.getAttributes();

                ParseSparseArff psaTrain = new ParseSparseArff(trainFile);
                trainInstances=psaTrain.getInstances();
            }else
            {
                ParseArff paTest = new ParseArff(testFile);
                testInstances=paTest.getInstances();
                attributes=paTest.getAttributes();

                ParseArff paTrain = new ParseArff(trainFile);
                trainInstances=paTrain.getInstances();
            }
                KNN knn = new KNN(testInstances, trainInstances,attributes, outFile, k);
                Output out = new Output();
                out.outToArffWithoutClusters(attributes,knn.getFinalInstances(),outFile);
        }


    }

    public void parseFile(String file)
    {
        if(isSparseArff(file))
        {
            ParseSparseArff psa = new ParseSparseArff(file);
            _instances=psa.getInstances();
            _attributes=psa.getAttributes();
        }else
        {
             ParseArff pa = new ParseArff(file);
            _instances=pa.getInstances();
            _attributes=pa.getAttributes();
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
            System.out.println("Arff file " + file + " could not be located as: " + file);
        }
        return sparse;
    }
}
