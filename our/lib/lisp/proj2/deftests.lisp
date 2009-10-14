(defun deftests()
  (test-logn)
  (test-make-new-data)
  (test-split-traintest)
  ;(test-k-nearest)
  (test-infogain))

;; deftest: log-N function
(deftest test-logn()
  (let* ((testdata (deftest_data)))
    (check
      (equal (car (table-egs-to-lists (log-data1 testdata)))
             '(1.8388491 1.1139433 0.845098 0.90309 3.387687 -1.39794 1.4286207
                1.9589937 4.8163605 -0.09151498 3.5610883 1.8325089 1.5314789 -4.0
                1.3424227 1.819544 2.3364596 2.206826 1.39794 FALSE)))))

;; deftest: Build new data from n existing datasets (2 in this case)
(deftest test-make-new-data()
  (let* ((old-data (table-egs-to-lists (deftest_data))))
    (dolist (item (reverse old-data))
      (setf old-data (cons item old-data)))
    (check
      (equal old-data (table-egs-to-lists (new-data (deftest_data) (deftest_data)))))))
      

;; deftest: Splits a dataset into a train set and test set
(deftest test-split-traintest()
  (let* ((bucket (split2bins (deftest_data))))
    (check
      (and (eq (length (table-egs-to-lists (car bucket))) 1)
           (eq (length (table-egs-to-lists (car (cdr bucket)))) 6)))))


;; deftest: k-nearest neighbor. Testing for the first nearest neighbor
(deftest test-k-nearest ()
  (check
    (equal (car (k-nearest (car (table-egs-to-lists (deftest_data))) (table-egs-to-lists (deftest_data)) 1))
           '(69 13 7 8 2441.67 0.04 26.83 90.99 65518.01 0.81 3639.89 68 34 1 22 66 217 161 25 FALSE))))


;; deftest: infogain. We want 2 columns
(deftest test-infogain ()
  (check
    (equal (car (table-egs-to-lists (infogain-table (make-data-k) 2)))
           '(45 20 YES))))



(defun deftest_data()
	(data
		:name 'deftest_data
		:columns '( $loc $v $ev $iv $v $l $d $i $e $b $t $lOCode $lOComment $locCodeAndComment $uniq_Op $uniq_Opnd $total_Op $total_Opnd $branchCount defects)
		:egs
		'(	( 69 13 7 8 2441.67 0.04 26.83 90.99 65518.01 0.81 3639.89 68 34 1 22 66 217 161 25 false )
			( 12 4 1 2 272.48 0.12 8.31 32.81 2263.1 0.09 125.73 10 1 2 13 18 32 23 7 false )
			( 3 1 1 1 19.65 0.5 2 9.83 39.3 0.01 2.18 2 0 1 4 3 4 3 1 false )
			( 13 4 1 3 454.95 0.04 27.3 16.66 12420.23 0.15 690.01 13 0 0 21 15 49 39 7 false )
			( 22 5 5 4 539.23 0.07 13.94 38.68 7516.89 0.18 417.61 22 0 0 17 25 59 41 9 true )
			( 19 5 1 5 320.63 0.09 11.67 27.48 3740.65 0.11 207.81 17 5 2 14 15 41 25 9 false )
			( 0 1 1 1 2 0 0 0 0 0 0 0 0 0 2 0 2 0 1 false ))))
