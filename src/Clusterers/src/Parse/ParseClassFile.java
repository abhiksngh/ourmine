
package Parse;

import java.io.FileNotFoundException;
import java.io.FileReader;
import java.util.Hashtable;
import java.util.Scanner;

/**
 *
 * @author Adam Nelson
 */
public class ParseClassFile {

    private Hashtable _instAndClass = new Hashtable();

    public ParseClassFile(String classFile)
    {
        try
        {
        FileReader reader = new FileReader(classFile);
        Scanner scanner = new Scanner(reader);
        parse(scanner);
        }catch(FileNotFoundException fnf)
        {
            System.out.println("File could not be found as " + classFile);
        }
    }

    private void parse(Scanner scan)
    {
        while(scan.hasNextLine())
        {
            String line=scan.nextLine();

            if(line.startsWith("%")) {continue;}

            String[] instAndClass = line.split(" ");
            getInstAndClass().put(Integer.parseInt(instAndClass[0]), Integer.parseInt(instAndClass[1]));
        }
    }

    /**
     * @return the _instAndClass
     */
    public Hashtable getInstAndClass() {
        return _instAndClass;
    }
}
