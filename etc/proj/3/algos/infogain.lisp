;; Infogain
;; Implemented as Feature Subset Selection


;; Calculate the information of each column.
;; Drop a column if the information gain is less than "X%" of the maximum informaion gain.

(defmacro sum (l)
  `(apply '+ ,l))

(defun ent (x)
  (if
   (= 0 x)
   '0
   (* (- x) (log x 2))))

(defun entropy (l)
  "Calculate the entropy of the list l"
  (let
      ((sum (sum l)))
    (sum (mapcar 'ent (mapcar #'(lambda (x) (/ x sum)) l)))))

(defmacro table-info (tbl)
  `(entropy (mapcar 'second (count-classes ,tbl))))

(defmacro nth-feat (feat)
  `(nth n (eg-features ,feat)))

(defmacro nth-col-name (n tbl)
  `(header-name (nth ,n (table-columns ,tbl))))

(defmacro col-attr-answers (n c tbl)
  "Number of count of 'c' classes on the 'n'th column of tbl"
  `(count-uniques-by-class ,tbl #'(lambda (x) (nth ,n (eg-features x))) ,c))

(defun store-col-attr-answers (n classes tbl ht)
  (let ((cc '()))
    (dolist (c classes)
      (push (col-attr-answers n c tbl) cc))
    (setf (gethash (nth-col-name n tbl) ht) cc)))

(defun infogain (tbl)
  (let
      ((n -1)
       (infostore (make-hash-table))
       (classes (gimme-no-dupe-classes tbl))
       (instances (f tbl))
       (gainstore (make-hash-table))
       (cols (table-columns tbl)))
    (dolist (l cols infostore)
      (incf n)
      (unless (header-classp l)
	(store-col-attr-answers n classes tbl infostore)))
    (setf n -1)
    (dolist (l cols gainstore)
      (incf n)
      (unless (header-classp l)
	(let
	    ((store 0)
	     (tmphash (make-hash-table))
	     (col-name (header-name l)))
	   (dolist (thiscol (gethash col-name infostore))
	     (mapcar #'(lambda (x) (push (second x) (gethash (first x) tmphash '()))) thiscol))
	   (maphash #'(lambda (x y) (incf store (* (/ (sum y) instances) (entropy y)))) tmphash)
	   (setf (gethash col-name gainstore) (- (table-info tbl) store)))))))
