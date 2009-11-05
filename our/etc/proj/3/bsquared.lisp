;; # B-squared

;;     * Replace each class symbol with a utility score (lower score = higher utility).
;;     * Sort instances by that score and divide them using N=20%-chops.
;;     * Label all the rows in bin=1 "best" and the remaining "rest".
;;     * Pretend you are doing NaiveBayes and collect the frequencies of ranges in best/rest.
;;     * Sort each range (r) by b^^2/(b+r) where
;;           o b = freq(r in Best) / SizeOfBest
;;           o r = freq(r in Rest) / SizeOfRest
;;           o btw, if b < r, then b = 0.
;;	# Sort each attribute by the median score of b2/(b+r).
;;	# Reject attributes with les than X% of the max. median score.

(defun b-squared (src-table)
  (let* (
         (table (copy-table src-table))
         (transposed-data (transpose (get-data table)))
         (instances)
         (sorted-instances)
         (class-lst)
         (scored-lst)
         )

    ;;* Replace each class symbol with a utility score (lower score = higher utility).

    ;;for each class
    (dolist (this-class class-lst)
      ;;score each class
      (setf scored-lst (append scored-lst (score-class this-class class-lst)))
      )

    (setf (first (last transposed-data)) scored-lst)

    ;;restore rows or instances

    (setf instances (reverse (tranpose (transposed-data))))

    (setf instance-ndx (index-instances instances))

    ;;Sort instances by utility scores

    (setf sorted-instances (first instances))

    
    (dotimes (pos-in-lst instances)

      ;;this is going to be interesting
      ;;what I think I need for this
      ;;1.  original positions of instance(index)
      ;;2.  maybe a list with the scores and the index, regardless I need the index stored by the scores
      ;;3.  When I have the index sorted by the score, I can:

      )
    (dolist (cur-item sorted-ndx-lst)
      (setf sorted-instances (append sorted-instances (nth cur-item instances))))

    ;;divide sorted-instances using N=20%-chops.

    ;;n-chops (20 instances)  on instances (yay)

    ;;bin-lst = (nchops 20 instances)
    ;;best-bin = (first bin-lst)
    ;;rest-bin = (rest bin-lst)  might need to dolist to make on big bin


    ;;collect the frequencies of ranges in best/rest.
    ;;best-min best-max rest-min rest-max


;;     * Sort each range (r) by b^^2/(b+r) where
;;           o b = freq(r in Best) / SizeOfBest
;;           o r = freq(r in Rest) / SizeOfRest
;;           o btw, if b < r, then b = 0. 

;;	# Sort each attribute by the median score of b2/(b+r).
;;	# Reject attributes with les than X% of the max. median score.

    ;;retun table
    
    
    
      )
  )

;;scoring function
(defun score-class (this-class class-lst)
  )


;;I just want a list 1 through length
;;Might need to alter for score-index instead
(defun index-instances (instances)
  (let (
        (ret-ndx)
        )
    (dotimes (x (length instances))
      (setf ret-ndx (append ret-ndx (list (+ 1 x)))))
    ret-ndx
    )
  )
        
    

    