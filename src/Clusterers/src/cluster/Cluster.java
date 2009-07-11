
package cluster;

import java.util.ArrayList;

/**
 *
 * @author Adam Nelson
 */
 public class Cluster
    {
        private String[] _centroid;
        private ArrayList<String[]> _members = new ArrayList<String[]>();

        /**
         * @return the _centroid
         */
        public String[] getCentroid() {
            return _centroid;
        }

        /**
         * @param centroid the _centroid to set
         */
        public void setCentroid(String[] centroid) {
            this._centroid = centroid;
        }

        /**
         * @return the _members
         */
        public ArrayList<String[]> getMembers() {
            return _members;
        }

        /**
         * @param members the _members to set
         */
        public void setMembers(ArrayList<String[]> members) {
            this._members = members;
        }


    }

