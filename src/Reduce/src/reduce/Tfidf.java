package reduce;

import java.util.ArrayList;
import java.util.Collections;
import java.util.Enumeration;
import java.util.Hashtable;
import parse.Instance;

/**
 *
 * @author Adam Nelson
 */
public class Tfidf
{
    private Hashtable _origInstances;
    private Hashtable _originalAttributes;
    private int _numDocs;
    private Hashtable _termsAndTfidfScores = new Hashtable();
    
    //key=instnum, val=inst
    private Hashtable _instancesWithTfidfScores = new Hashtable();

    private ArrayList<Integer> _attributesSortedByTfidf = new ArrayList<Integer>();
    private ArrayList<Integer> _finalAttributesIndices = new ArrayList<Integer>();
    private ArrayList<String> _finalAttributes = new ArrayList<String>();
    private ArrayList<String> _finalInstances = new ArrayList<String>();


    public Tfidf(Hashtable instances, Hashtable attrs, int numAttrs)
    {
        this._origInstances=instances;
        this._originalAttributes=attrs;
        this._numDocs=instances.size();

        begin();
        sortAttributesBasedOnTfidfScores();
        selectNAttributes(numAttrs);
        selectFinalAttrsAndInsts();

        /*
        for(String attr : _finalAttributes)
        {
            System.out.println(attr);
        }

        for(String inst : _finalInstances)
        {
            System.out.println(inst);
        }
         * */
    }

    private void selectFinalAttrsAndInsts()
    {
        Enumeration instWithTfidfScores = _instancesWithTfidfScores.keys();
        StringBuilder builder = new StringBuilder();

        //add instances
        while(instWithTfidfScores.hasMoreElements())
        {
            Instance instance = (Instance)_instancesWithTfidfScores.get(instWithTfidfScores.nextElement());

            double tfidfSum=0.0;

            for(int i=0;i<getFinalAttributesIndices().size();i++)
            {
                String index = getFinalAttributesIndices().get(i).toString();
                
                if(instance.getTerms().containsKey(index))
                {
                    Hashtable terms = instance.getTerms();

                    //find sum of tfidf scores in the current doc based on remaining attributes
                    Double tfidf = Double.parseDouble((String)terms.get(index));
                    tfidfSum+=tfidf;
                }             
            }

            if(tfidfSum==0.0){continue;}

            for(int i=0;i<getFinalAttributesIndices().size();i++)
            {
                String index = getFinalAttributesIndices().get(i).toString();

                if(instance.getTerms().containsKey(index))
                {
                    Hashtable terms = instance.getTerms();

                    Double tfidf = Double.parseDouble((String)terms.get(index));
                    Double normalizedTfidf = tfidf/tfidfSum;

                    builder.append(i + " " + normalizedTfidf.toString() + ",");
                }
            }

            if(builder.length() > 0)
            {
                getFinalInstances().add(builder.toString().substring(0, builder.toString().length()-1));
            }
            
            builder = new StringBuilder();
        }

        //add attributes
        for(Integer indx : getFinalAttributesIndices())
        {
            getFinalAttributes().add((String)_originalAttributes.get(indx.toString()));
        }
    }

    private void sortAttributesBasedOnTfidfScores()
    {

        ArrayList<Double> scores = new ArrayList<Double>();

        Enumeration e1 = _termsAndTfidfScores.keys();

        while(e1.hasMoreElements())
        {
             scores.add((Double)_termsAndTfidfScores.get(e1.nextElement()));
        }

        Collections.sort(scores);

        ArrayList<Object> seen = new ArrayList<Object>();
       
        for(Double d : scores)
        {
                Enumeration e2 = _termsAndTfidfScores.keys();
                
                while(e2.hasMoreElements())
                {
                    Object element = e2.nextElement();
                    Double freq = (Double)_termsAndTfidfScores.get(element);

                    if(freq==d && !seen.contains(element))
                    {
                        _attributesSortedByTfidf.add((Integer)element);
                        seen.add(element);
                        break;
                    }
                }
        }       
    }

    private void selectNAttributes(int n)
    {
        if(n <= _originalAttributes.size())
        {
            for(int i=_attributesSortedByTfidf.size()-1;i>=_attributesSortedByTfidf.size()-n;i--)
            {
                getFinalAttributesIndices().add(_attributesSortedByTfidf.get(i));
            }
        }else
        {
            System.out.println("Attempted to set n to a value larger than the number of attributes.+" +
                    "Resetting to a smaller value, " + n/2);
        }
    }

    private void begin()
    {
        Enumeration instNumEnum = _origInstances.keys();

        while(instNumEnum.hasMoreElements())
        {
            Instance inst = (Instance)_origInstances.get(instNumEnum.nextElement());

            Enumeration termNumEnum = inst.getTerms().keys();

            int wordsInDoc = inst.getTerms().size();

            Hashtable attrsByTfidf = new Hashtable();

            while(termNumEnum.hasMoreElements())
            {
                Object termNum = termNumEnum.nextElement();


                float freq = Float.parseFloat((String)inst.getTerms().get(termNum));
                float tf = freq/wordsInDoc;
                Double idf=Math.log10(_numDocs/frequencyOfTermInAllDocs(termNum));
                Double tfidf=tf*idf;

                attrsByTfidf.put((String)termNum, tfidf.toString());
                
                addTfidfScorePerTerm(Integer.parseInt((String)termNum), tfidf);
            }

            Instance instance = new Instance();
            instance.setInstNum(inst.getInstNum());
            instance.setTerms(attrsByTfidf);
            _instancesWithTfidfScores.put(new Integer(instance.getInstNum()).toString(), instance);
        }
    }

    private void addTfidfScorePerTerm(Integer termNum, Double tfidfScore)
    {
        if(_termsAndTfidfScores.containsKey(termNum))
        {
            double oldScore = (Double)_termsAndTfidfScores.get(termNum);
            Double newScore = oldScore + tfidfScore;

            _termsAndTfidfScores.remove(termNum);
            _termsAndTfidfScores.put(termNum, newScore);

        }else
        {
            _termsAndTfidfScores.put(termNum, tfidfScore);
        }
    }

    private double frequencyOfTermInAllDocs(Object termNum)
    {
        Enumeration e = _origInstances.keys();
        double totalFreq = 0;

        while(e.hasMoreElements())
        {
            Object key = e.nextElement();

            Instance inst = (Instance)_origInstances.get(key);
            Hashtable terms = inst.getTerms();

            if(terms.containsKey(termNum))
            {
                double freq= Double.parseDouble((String)terms.get(termNum));
                totalFreq+=freq;
            }
        }
        return totalFreq;
    }

    /**
     * @return the _finalAttributesIndices
     */
    public ArrayList<Integer> getFinalAttributesIndices() {
        return _finalAttributesIndices;
    }

    /**
     * @return the _finalAttributes
     */
    public ArrayList<String> getFinalAttributes() {
        return _finalAttributes;
    }

    /**
     * @return the _finalInstances
     */
    public ArrayList<String> getFinalInstances() {
        return _finalInstances;
    }
}