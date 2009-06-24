/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package Distances;

import util.MathUtil;

/**
 *
 * @author Adam Nelson
 */
public class Distances {
    
    public double euclidean(String[] X,  String[] Y)
    {
        double distance = 0;

        for(int i=0;i<X.length;i++)
        {
            try
            {
                double x = Double.parseDouble(X[i]);
                double y = Double.parseDouble(Y[i]);

                distance+=((x-y)*(x-y));

            }catch(Exception e)
            {
                if(!X[i].equalsIgnoreCase(Y[i]))
                {
                    distance+=1.0;
                }
            }
        }

        return Math.sqrt(distance);
    }

    public double cosineSimilarity(String[] X, String[] Y)
    {
        MathUtil util = new MathUtil();

        double XMag = util.getVectorMag(X);
        double YMag = util.getVectorMag(Y);

        //XMag=(XMag==0.0 ? 0.00001 : XMag);
        //YMag=(YMag==0.0 ? 0.00001 : YMag);

        return util.dot(X,Y)/(XMag*YMag);
    }
     

}
