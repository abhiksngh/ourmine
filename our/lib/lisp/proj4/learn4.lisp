
(defun remove-falses(train)
  (let* ((data (table-egs-to-lists train))
         (temp)
         (truths '())
         (class-col (table-class train)))
    (dotimes (n (length data) (make-simple-table (table-name train) (table-columns train) truths))
      (setf temp (nth n data))
      (if (eq (nth class-col temp) 'true)
          (setf truths (append (list temp) truths))))))

(defparameter shared-lst (list (xindex (shared_pc1)) (xindex (shared_kc1))
			       (xindex (shared_kc2)) (xindex (shared_kc3))
			       (xindex (shared_cm1)) (xindex (shared_mw1))
			       (xindex (shared_mc2))))

(defparameter prepared-data '())


(defun merge-data (&optional (nr-attributes 5))
  (let* ((sh_pc1 (xindex (shared_pc1)))
	 (sh_kc1 (xindex (shared_kc1)))
	 (sh_kc2 (xindex (shared_kc2)))
	 (sh_kc3 (xindex (shared_kc3)))
	 (sh_cm1 (xindex (shared_cm1)))
	 (sh_mw1 (xindex (shared_mw1)))
	 (sh_mc2 (xindex (shared_mc2)))
	 (lst (list sh_pc1 sh_kc1 sh_kc2 sh_kc3 sh_cm1 sh_mw1 sh_mc2))
	 (all-tbl (xindex (append-tables lst))))
   (score-tbl-bsquare all-tbl nr-attributes)))


(defun prepare-datasets-bsquare (&optional (num-attrs))
  (let* ((lst-out)
	 (indexes (merge-data num-attrs)))
  (dolist (l shared-lst lst-out)
    (setf lst-out (append lst-out (list (xindex  (make-bsquare-table l indexes))))))))

(defun make-bsquare-table (tbl indexes)
  (bsquare-table tbl indexes))

(defun randomize (lst &optional (b 5))
  (let* ((all-tbl))
    (dolist (l lst all-tbl)
      (setf all-tbl (append all-tbl (split2bin-tables l b))))))

(defun k-means-all-tables (lst &optional (k 2))
  (let ((all-tables))
    (dolist (tbl lst all-tables)
      (let ((lst-clusters (k-means tbl k))) 
       (setf all-tables  (append all-tables (list (car (sort lst-clusters #'> :key #'length)))))))
       (make-cluster-tables all-tables (car lst))))

(defun build-datas (&optional (ks) (bins 5) (num-attrs 5))
  (let* ((all-tables))
    (dolist (k ks all-tables)
      (setf all-tables (append all-tables 
			       (k-means-all-tables 
				(randomize 
				 (prepare-datasets-bsquare num-attrs) bins) k))))))

(defun set-data ()
  (setf prepared-data (build-datas '(5))))

(defun build-new-bp (bp atable current-rules test)
  ;(format t "car of bp is: ~a ~%" (car bp)) 
    (if (not (score-rules (car bp) current-rules test))
	(let* ((table-lst (list atable (cadr bp)))
	       (newtable (append-tables table-lst))
	       (newbp (list (make-rules-all-classes newtable) newtable)))
	  (if (not (score-rules (car newbp) current-rules test))
	      (return-from build-new-bp (list (make-rules-all-classes atable) atable)) 
	      (return-from build-new-bp newbp)))
	(return-from build-new-bp bp)))
	
	
	   
(defun score-rules (bpr r1 test)
  ;(format t "~A~%" bpr)
  (let* ((score-Bpr (evaluate-matrix test bpr 'pd))
	 (score-r1  (evaluate-matrix test r1 'pd)))
    ;(if (= score-Bpr score-r1) (format t "~a ~a ~%" "Equal scores" score-Bpr)
    ;	(if (< score-Bpr score-r1 ) (format t "~a ~a ~%" "R set is better" score-r1)
    ;	    (format t "~a ~a ~% " "Back pocket is better" score-Bpr)))
    (if (= score-Bpr score-r1)  
	 nil
      (if (< score-Bpr score-r1) 
	  nil
             t))))
	  
(defun run-all-exp (&optional (top-iterations 1) (bottom-iterations 1))
  (let ((bp))
    (dotimes (i top-iterations (car bp))
      (let* ((all (traintest-pdata))
	     (train (car (cdr all)))
	     (test (car all)))
	(setf bp (run-exp train test bottom-iterations bp))))))
    
(defun run-exp (train test iterations &optional (bp))
  (let ((acc 0))
    (dotimes (i iterations)
      (dolist (train-tbl train)
	;(format t "~a ~a ~a ~a ~a ~%" "Data set " acc ": Back pocket rules: Itr " i (car bp))
	(incf acc)
	(if (= (length bp) 0)
	    (setf bp (list (make-rules-all-classes train-tbl) train-tbl))	    
	    (setf bp (build-new-bp bp train-tbl (make-rules-all-classes train-tbl) test)))))
    bp))





;;;---------------------------------

(setf shared-rules '(
		     ((TRUE ((4 0)) ((1 0)))) 
		     ((TRUE ((4 0)) ((1 0)) ((1 1)))) 
		     ((TRUE ((4 0)) ((1 0)) ((1 2)) ((2 2)) ((0 9)) ((0 0)))) 
		     ((TRUE ((1 0)) ((0 0)) ((1 1)) ((0 4)) ((0 2)))) 
		     ((TRUE ((4 0)) ((1 0)))) 
		     ((TRUE ((0 7)) ((4 0)) ((0 4)) ((0 9)))) 
		     ((TRUE ((4 0)) ((4 8)) ((0 0)) ((0 4)) ((0 8)))) 
		     ((TRUE ((4 0)) ((0 0)))) 
		     ((TRUE ((4 0)) ((1 1)) ((1 0)))) 
		     ((TRUE ((4 0)) ((1 0)) ((1 1)))) 
		     ((TRUE ((4 0)) ((4 8)))) 
		     ((TRUE ((1 0)) ((4 0)))) 
		     ((TRUE ((4 0)) ((1 0)) ((0 1))))
		     ((TRUE ((4 0)) ((1 0)) ((0 0)))) 
		     ((TRUE ((4 0)) ((1 0)) ((1 1)))) 
		     ((TRUE ((2 0)) ((0 4)) ((0 6)) ((0 0)) ((0 8)) ((0 7))))
		     ((TRUE ((4 0)) ((0 1)) ((1 0)) ((0 0))))
		     ((TRUE ((4 0)) ((1 0)) ((1 2)) ((0 1)) ((0 8))))
		     ((TRUE ((1 0)) ((4 0)) ((0 4)))) 
		     ((TRUE ((4 0)) ((4 1)) ((0 8))))
		     ))

(setf real-rules '(((FALSE ((0 6)) ((2 0)) ((2 6)) ((1 5)) ((3 7)))
                    (TRUE ((0 8)) ((1 3)) ((1 2)) ((4 1) (0 1)) ((4 1) (1 1)) ((2 7) (0 2))
                     ((4 1) (2 5))))
                   ((FALSE ((2 5)) ((0 4)) ((1 7)) ((1 6)) ((0 2) (1 4)) ((0 2) (1 3)))
                    (TRUE ((0 5)) ((1 0)) ((1 2))))
                   ((FALSE ((2 8)) ((0 5)) ((0 6)) ((0 8)) ((3 3)))
                    (TRUE ((0 2)) ((1 5)) ((3 0)) ((0 1) (1 2))))
                   ((TRUE ((4 5)) ((4 8)) ((4 2)) ((1 1) (2 0)))
                    (FALSE ((4 3)) ((4 7)) ((4 0)) ((4 1) (1 0))))
                   ((TRUE ((1 3))) (FALSE ((0 2)) ((0 6)) ((2 1)) ((1 0))))
                   ))


(defun rank-rules-classes (rules)
  (let* ((true-seen)
         (false-seen)
         (true-ranks)
         (false-ranks)
         (current)
         (attr-rank))
    (dolist (ruleset rules)
      (dolist (a-rule ruleset)
        (setf current a-rule)
        (if (eql (car current) 'FALSE)
            (dolist (attr (cdr current))
              (if (null (position attr false-seen :test #'equal))
                  (progn
                    (setf false-seen (cons attr false-seen))
                    (setf attr-rank (count-occurrence attr rules 'FALSE))
                    (setf false-ranks (acons attr attr-rank false-ranks)))))
            (dolist (attr (cdr current))
              (if (null (position attr true-seen :test #'equal))
                  (progn
                    (setf true-seen (cons attr true-seen))
                    (setf attr-rank (count-occurrence attr rules 'TRUE))
                    (setf true-ranks (acons attr attr-rank true-ranks))))))))
    (setf false-ranks (sort false-ranks #'(lambda (x y) (> (cdr x) (cdr y)))))
    (setf true-ranks (sort true-ranks #'(lambda (x y) (> (cdr x) (cdr y)))))
    (format t "false ranks:~%~a ~%~%true ranks:~%~a~%" false-ranks true-ranks)))


   

(defun count-occurrence (elt all-rules class)
  (let* ((count 0)
         (current))
    (dolist (ruleset all-rules count)
      (dolist (rules ruleset)
        (setf current (car rules))
        (if (eql current class)
            (dolist (attr (cdr rules))
              (if (equal attr elt)
                  (progn
                    (incf count)))))))))



(defun rank-rules (rawrules)
  (let* ((extracted (extract-rule-vals rawrules))
	(uniques (get-uniques extracted)))
    (dolist (uniq uniques)
      (format t "Item: ~A, Rank: ~A~%" uniq (item-count extracted uniq)))))
    
    

  	   
(defun get-uniques (lst)
  (let ((uniques))
    (dolist (item lst)
      (if (not (contains uniques item))
	  (setf uniques (append uniques (list item)))))
    uniques))

(defun extract-rule-vals (rules)
  (let ((lst))
    (dolist (rule rules)
      (dotimes (i (- (length (car rule)) 1))
	(incf i)
	(setf lst (append lst (nth i (car rule))))))
    lst))
	   
(defun item-count (lst item)
  (let ((ndx 0)
	(found 0))
    (dolist (l lst)
      (if (equal l item)
	  (incf found))
      (incf ndx))
    found))

	  
