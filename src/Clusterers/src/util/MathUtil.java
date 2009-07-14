package util;

/**
 *
 * @author Adam Nelson
 */
public class MathUtil {

   //based on Euclidean norm
    public double getVectorMag(String[] X)
    {
        double XMag = 0.0;

        for(int i=0;i<X.length;i++)
        {
            try
            {
                double val = Double.parseDouble(X[i]);
                XMag+=(val*val);

            }catch(Exception e)
            {
                //just in case we aren't always dealing with numeric attributes
                XMag+=1.0;
            }
        }

        return Math.sqrt(XMag);
    }

    //standard dot product
    public double dot(String[] X, String[] Y)
    {
        double result = 0.0;

        for(int i=0;i<X.length;i++)
        {
            try
            {
                double x = Double.parseDouble(X[i]);
                double y = Double.parseDouble(Y[i]);

                result+=(x*y);

            }catch(Exception e)
            {
                //just in case we aren't always dealing with numeric attributes
                if(!X[i].equalsIgnoreCase(Y[i]))
                {
                    result+=1.0;
                }
            }
        }

        return result;
    }
}
