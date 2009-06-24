/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package canopies;

import java.util.ArrayList;

/**
 *
 * @author Adam Nelson
 */
public class CanopyStructure {

    private String[] _canopyCenter;
    private ArrayList<String[]> _outerThresholdMembers = new ArrayList<String[]>();
    private ArrayList<String[]> _innerThresholdMembers = new ArrayList<String[]>();

    /**
     * @return the _canopyCenter
     */
    public String[] getCanopyCenter() {
        return _canopyCenter;
    }

    /**
     * @param canopyCenter the _canopyCenter to set
     */
    public void setCanopyCenter(String[] canopyCenter) {
        this._canopyCenter = canopyCenter;
    }

    /**
     * @return the _canopyMembers
     */
    public ArrayList<String[]> getOuterThresholdMembers() {
        return _outerThresholdMembers;
    }

    /**
     * @param canopyMembers the _canopyMembers to set
     */
    public void setouterThresholdMembers(ArrayList<String[]> canopyMembers) {
        this._outerThresholdMembers = canopyMembers;
    }

    /**
     * @return the _innerThresholdMembers
     */
    public ArrayList<String[]> getInnerThresholdMembers() {
        return _innerThresholdMembers;
    }

    /**
     * @param innerThresholdMembers the _innerThresholdMembers to set
     */
    public void setInnerThresholdMembers(ArrayList<String[]> innerThresholdMembers) {
        this._innerThresholdMembers = innerThresholdMembers;
    }


}
