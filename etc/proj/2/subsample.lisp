;;; Subsample: Poll data for a tally on all the classes.  Find the smallest class, and randomly delete
;;;   lines until they are all equal in prevelence.  Once the classes are all the same size, the data
;;;   is now ready for the discretizer.

;;; Claimee: Drew
(print " - Loading Subsample") ;; Logging for a pretty run
(defun subsample (data)
   ;;; Poll for frequency of all class types.  Keep tally.
   ;;; Identify smallest class, hold this value.
   ;;; Begin to do multiple passes over the data.  If a class is encountered that is too large,
   ;;;   randomly decide to remove it or not, decrement tally.
   ;;; At the end of a pass, if all counts are not equal, pass again.  Else, return data subset.
)
