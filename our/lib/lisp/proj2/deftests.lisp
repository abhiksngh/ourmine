;; deftest log-N function
(deftest test-logn()
  (let* ((testdata (deftest_data)))
    (check
      (equal (table-egs-to-lists (log-data1 testdata))
             '((1.8388491 1.1139433 0.845098 0.90309 3.387687 -1.39794 1.4286207
                1.9589937 4.8163605 -0.09151498 3.5610883 1.8325089 1.5314789 -4.0
                1.3424227 1.819544 2.3364596 2.206826 1.39794 FALSE)
               (1.0791812 0.60206 -4.0 0.30103 2.4353347 -0.92081875 0.9196011 1.5160062
                3.3547037 -1.0457575 2.099439 1.0 -4.0 0.30103 1.1139433 1.2552725
                1.50515 1.3617278 0.845098 FALSE)
               (0.47712126 -4.0 -4.0 -4.0 1.2933626 -0.30102998 0.30103 0.99255353
                1.5943925 -2.0 0.33845648 0.30103 -4.0 -4.0 0.60206 0.47712126 0.60206
                0.47712126 -4.0 FALSE)
               (1.1139433 0.60206 -4.0 0.47712126 2.6579638 -1.39794 1.4361626 1.221675
                4.0941296 -0.82390875 2.8388553 1.1139433 -4.0 -4.0 1.3222193 1.1760913
                1.690196 1.5910646 0.845098 FALSE)
               (1.3424227 0.69897 0.69897 0.60206 2.7317739 -1.154902 1.1442627
                1.5874865 3.876038 -0.74472743 2.6207707 1.3424227 -4.0 -4.0 1.230449
                1.39794 1.770852 1.6127839 0.9542425 TRUE)
               (1.2787536 0.69897 -4.0 0.69897 2.506004 -1.0457575 1.0670708 1.4390167
                3.572947 -0.9586073 2.3176663 1.230449 0.69897 0.30103 1.146128
                1.1760913 1.6127839 1.39794 0.9542425 FALSE)
               (-4.0 -4.0 -4.0 -4.0 0.30103 -4.0 -4.0 -4.0 -4.0 -4.0 -4.0 -4.0 -4.0 -4.0
                0.30103 -4.0 0.30103 -4.0 -4.0 FALSE))))))


;; preprocessor that builds new data from n existing datasets (2 in this case)
(deftest test-make-new-data()
  (let* ((old-data (table-egs-to-lists (deftest_data))))
    (dolist (item (reverse old-data))
      (setf old-data (cons item old-data)))
    (check
      (equal old-data (table-egs-to-lists (new-data (deftest_data) (deftest_data)))))))
      

;; splits a dataset into a train set and test set
(deftest test-split-traintest()
  (let* ((bucket (split2bins (deftest_data))))
    (check
      (and (eq (length (table-egs-to-lists (car bucket))) 1)
           (eq (length (table-egs-to-lists (car (cdr bucket)))) 6)))))


;; k-nearest neighbor. Testing for the first nearest neighbor
(deftest test-k-nearest ()
  (check
    (equal (k-nearest (car (table-egs-to-lists (deftest_data))) (table-egs-to-lists (deftest_data)) 1)
           '((69 13 7 8 2441.67 0.04 26.83 90.99 65518.01 0.81 3639.89 68 34 1 22 66
              217 161 25 FALSE)))))


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
