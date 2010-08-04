(defun results-report (results)
  (dohash (klass result results results)
    (result-report result)))
    
(defun result-report (result)
  (with-slots ( a b c d acc pf prec pd f) result
    (let ((zip (float (expt 10 -16))))
      (setf acc  (/ (+ a d) (+ zip a b c d))
            pf   (/ c       (+ zip a c    ))
            prec (/ d       (+ zip c d    ))
            pd   (/ d       (+ zip b d    ))
            f    (/ (* 2 prec pd) (+ zip prec pd)))
      result)))

(defun klasses->results (tbl)
  (let ((results (make-hash-table)))
    (dolist (klass (theklasses tbl) results)
      (let ((name (klass-name klass)))
	(setf (gethash name results)
	      (make-result :target name))))))
    
(defun results-add (klasses results got want)
  (dolist (goal1 klasses)
    (with-slot (a b c d) (gethash goal1 results)
      (dolist (goal2 klasses)
	(if (eql goal1 goal2) 
	  (if (eql want got)
	      (incf a)
	      
      (let ((it (if (eql klass2 klass1)   
	  

	  
	  (if (eql got want)
	      (incf (result-d (gethash klass2 results)))
	      (incf (result-b (gethash klass2 results))))
	  (if (eql got want)
	      (incf (result-c (gethash klass2 results)))
		(incf (result-a (gethash klass2 results))))))))