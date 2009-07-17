/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package parse;

import java.util.Hashtable;

/**
 *
 * @author Adam Nelson
 */
    public class Instance
    {
        //terms are key=term num, v=frequency
        private int _instNum;
        private Hashtable _terms = new Hashtable();

        /**
         * @return the _instNum
         */
        public int getInstNum() {
            return _instNum;
        }

        /**
         * @param instNum the _instNum to set
         */
        public void setInstNum(int instNum) {
            this._instNum = instNum;
        }

        /**
         * @return the _terms
         */
        public Hashtable getTerms() {
            return _terms;
        }

        /**
         * @param terms the _terms to set
         */
        public void setTerms(Hashtable terms) {
            this._terms = terms;
        }


    }
