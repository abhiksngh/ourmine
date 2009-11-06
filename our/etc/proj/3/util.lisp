;;Filter function from ANSI Common Lisp.
(defun filter (fn lst)
  (let ((acc nil))
    (dolist (x lst)
      (let ((val (funcall fn x)))
        (if val (push val acc))))
    (nreverse acc)))

;;Returns the name of a function object.
(defun function-name (fobject)
  (do-all-symbols (fsymbol)
    (when (and (fboundp fsymbol)
               (eq (symbol-function fsymbol) fobject))
      (return fsymbol))))

;;Returns a complete copy of a discrete column header and all of its members
;;except f.
(defmethod header-deep-copy ((column discrete))
  (let ((new-column (make-discrete)))
    (setf (discrete-name new-column) (discrete-name column))
    (setf (discrete-classp new-column) (discrete-classp column))
    (setf (discrete-ignorep new-column) (discrete-ignorep column))
    (setf (discrete-orderp new-column) (discrete-orderp column))
    (setf (discrete-uniques new-column) (copy-list (discrete-uniques column)))
    new-column))

;;Returns a complete copy of a numeric column header and all of its members
;;except f.
(defmethod header-deep-copy ((column numeric))
  (let ((new-column (make-numeric)))
    (setf (numeric-name new-column) (numeric-name column))
    (setf (numeric-classp new-column) (numeric-classp column))
    (setf (numeric-ignorep new-column) (numeric-ignorep column))
    new-column))

;;Returns a complete copy of an eg structure and all of its members.
(defun eg-deep-copy (eg)
  (if (not eg)
    nil
    (let ((new-eg (make-eg)))
      (setf (eg-features new-eg) (copy-list (eg-features eg)))
      (setf (eg-class new-eg) (eg-class eg))
      new-eg)))

;;Returns a complete copy of a table structure and all of its members.
;;The copy will have updated metadata.
(defun table-deep-copy (tbl)
  (let ((new-tbl (make-table)))
    (setf (table-name new-tbl) (table-name tbl))
    (dolist (column (table-columns tbl))
      (push (header-deep-copy column) (table-columns new-tbl)))
    (setf (table-columns new-tbl) (nreverse (table-columns new-tbl)))
    (setf (table-class new-tbl) (table-class tbl))
    (dolist (eg (table-all tbl))
      (push (eg-deep-copy eg) (table-all new-tbl)))
    (setf (table-all new-tbl) (nreverse (table-all new-tbl)))
    (setf (table-centroid new-tbl) (eg-deep-copy (table-centroid tbl)))
    (setf (table-indexed new-tbl) nil)
    (table-update new-tbl)))

;;Returns a copy of tbl with no rows.
;;The copy will be unindexed.
(defun table-blank-copy (tbl)
  (let ((new-tbl (make-table)))
    (setf (table-name new-tbl) (table-name tbl))
    (dolist (column (table-columns tbl))
      (push (header-deep-copy column) (table-columns new-tbl)))
    (setf (table-columns new-tbl) (nreverse (table-columns new-tbl)))
    (setf (table-class new-tbl) (table-class tbl))
    (setf (table-all new-tbl) nil)
    (setf (table-centroid new-tbl) nil)
    (setf (table-indexed new-tbl) nil)
    new-tbl))

;;Returns a list of header structures in a table structure.
(defun get-table-column-headers (tbl)
  (table-columns tbl))

;;Returns the header structure for columni.
(defun get-table-column-header (tbl columni)
  (nth columni (get-table-column-headers tbl)))

;;Returns a list of symbols representing the header names for each column in
;;tbl.
(defun get-table-column-header-names (tbl)
  (mapcar #'header-name (get-table-columns tbl)))

;;Returns a list of the values stored in columni.
(defun get-table-column (tbl columni)
  (mapcar #'(lambda (row) (nth columni (eg-features row))) (get-table-rows tbl)))

;;Returns true if the column header for columni in tbl is of type numeric.
(defun table-column-numericp (tbl columni)
  (typep (get-table-column-header tbl columni) 'numeric))

;;Returns true if column-header is of type numeric.
(defun column-header-numericp (column-header)
  (typep column-header 'numeric))

;;Returns true if the column header for columni is a numeric column or an ordered
;;discrete column.
(defun table-column-orderedp (tbl columni)
  (or (table-column-numericp tbl columni)
      (and (typep (get-table-column-header tbl columni) 'discrete)
           (discrete-orderp (get-table-column-header tbl columni)))))

;;Returns true if column-header is a numeric column or an ordered discrete column.
(defun column-header-orderedp (column-header)
  (or (column-header-numericp column-header)
      (and (typep column-header 'discrete)
           (discrete-orderp column-header))))

;;Returns true if columni is the class column.
(defun table-column-classp (tbl columni)
  (header-classp (get-table-column-header tbl columni)))

;;Returns true if column-header is the class column.
(defun column-header-classp (column-header)
  (header-classp column-header))

;;Returns a list of eg structures representing the rows in the table structure.
(defun get-table-rows (tbl)
  (table-all tbl))

;;Returns a list of feature lists from the table structure.
(defun get-table-feature-lists (tbl)
  (mapcar #'eg-features (get-table-rows tbl)))

;;Returns the feature list in row.
(defun get-row-features (row)
  (eg-features row))

;;Returns a list containing all class symbols in tbl.
(defun get-table-classes (tbl)
  (discrete-uniques (nth (table-class tbl) (get-table-column-headers tbl))))

;;Returns a list of all rows in table with specified class.
(defun get-table-class-rows (tbl class)
  (filter #'(lambda (row) (and (equalp (eg-class row) class) row)) (get-table-rows tbl)))

;;Returns the number of rows in table with a specific class.
(defun get-table-class-frequency (tbl class)
  (length (get-table-class-rows tbl class)))

;;Removes all rows from tbl.
(defun delete-table-rows (tbl)
  (setf (table-all tbl) nil))

;;Updates the uniques property of columni in tbl.
(defun column-update-discrete-uniques (tbl columni)
  (if (not (table-column-numericp tbl columni))
    (setf (discrete-uniques (get-table-column-header tbl columni)) 
          (remove-duplicates (get-table-column tbl columni) :test #'equalp)))
  tbl)

;;Updates the uniques property of each discrete column in tbl.
(defun table-update-discrete-uniques (tbl)
  (doitems (column-header columni (get-table-column-headers tbl))
    (column-update-discrete-uniques tbl columni))
  tbl)

(defun table-update-index (tbl)
  (setf (table-indexed tbl) nil)
  (dolist (column-header (get-table-column-headers tbl))
    (setf (header-f column-header) (make-hash-table :test #'equal)))
  (xindex tbl)
  tbl)

;;Returns the centroid of tbl.
(defun get-table-centroid (tbl)
  (table-centroid tbl))

;;Recomputes the table's centroid and updates the centroid property.
(defun table-update-centroid (tbl)
  (let ((new-centroid (eg-deep-copy (car (table-all tbl)))))
    (mapcar #'(lambda (feature-list) 
                (doitems (column-header columni (get-table-column-headers tbl))
                  (if (column-header-orderedp column-header)
                    (incf (nth columni (eg-features new-centroid)) (nth columni feature-list)))))
            (get-table-feature-lists tbl))
    (doitems (column-header columni (get-table-column-headers tbl))
      (if (column-header-orderedp column-header)
        (setf (nth columni (eg-features new-centroid)) 
              (/ (nth columni (eg-features new-centroid)) (length (get-table-rows tbl))))))
    (setf (table-centroid tbl) new-centroid)))

(defun table-update (tbl)
  (table-update-discrete-uniques tbl)
  (table-update-index tbl)
  (table-update-centroid tbl)
  tbl)

(defun get-table-class-frequency (tbl class)
  (f tbl class))

(defun get-table-value-frequency (tbl columni value)
  (reduce #'+ (mapcar #'(lambda (class) (get-table-instance-frequency tbl class columni value)) (get-table-classes tbl))))

(defun get-table-instance-frequency (tbl class columni value)
  (f tbl class columni value))

(defun get-table-class-distribution (tbl class columni)
  (gethash class (header-f (nth columni (table-columns tbl)))))

(defun get-table-size (tbl)
  (length (get-table-rows tbl)))

;;Takes a table structure and returns the symbol representing the minority class and 
;;the number of instances of the minority class.
(defun get-defect-class (tbl)
  (let ((defect-class nil)
        (defect-class-count most-positive-fixnum))
    (dolist (class (get-table-classes tbl))
      (if (< (get-table-class-frequency tbl class)
             defect-class-count)
        (setf defect-class class
              defect-class-count (get-table-class-frequency tbl class))))
    defect-class))

;;Modifies tbl to convert the header structure for columni into a discrete
;;column header.
(defun numeric2discrete (tbl columni)
  (let ((column-header (get-table-column-header tbl columni)))
    (setf column-header (make-discrete :name (intern (subseq (symbol-name (header-name column-header)) 1)) 
                                                     :classp (header-classp column-header) 
                                                     :ignorep (header-ignorep column-header)
                                                     :orderp t
                                                     :uniques nil))
    (setf (nth columni (table-columns tbl)) column-header)
    (column-update-discrete-uniques tbl columni)))

(defun numeric-test-tbl ()
  (table-update (table-deep-copy (data :name 'test
                         :columns '($test1 $test2 class)
                         :egs '((1 20 true)
                                (2  19 true)
                                (3 18 true)
                                (4 17 true)
                                (5 16 true)
                                (6 15 true)
                                (7 14 true)
                                (8 13 true)
                                (9 12 true)
                                (10 11 true)
                                (11 10 false)
                                (12 9 false)
                                (13 8 false)
                                (14 7 false)
                                (15 6 false)
                                (16 5 false)
                                (17 4 false)
                                (18 3 false)
                                (19 2 false)
                                (20 1 false))))))

(defun eq-width-discretized-test-tbl ()
  (let ((tbl (table-update (table-deep-copy (data :name 'test
                                    :columns '(test1 test2 class)
                                    :egs '((0 9 true)
                                           (0 9 true)
                                           (1 8 true)
                                           (1 8 true)
                                           (2 7 true)
                                           (2 7 true)
                                           (3 6 true)
                                           (3 6 true)
                                           (4 5 true)
                                           (4 5 true)
                                           (5 4 false)
                                           (5 4 false)
                                           (6 3 false)
                                           (6 3 false)
                                           (7 2 false)
                                           (7 2 false)
                                           (8 1 false)
                                           (8 1 false)
                                           (9 0 false)
                                           (9 0 false)))))))
    (dolist (column-header (get-table-column-headers tbl))
      (if (and (typep column-header 'discrete) (not (column-header-classp column-header)))
        (setf (discrete-orderp column-header) t)))
    tbl))

