;;;; a table stores headers and examples
(defstruct table 
  name                      ; symbol          : name of the table
  columns                   ; list of header  : one header to describe each column of data
  class                     ; number          : which column is the header column?
  (cautions (make-caution)) ; list of caution : any load-time errors?
  all                       ; list of eg      : all the examples
)

(defun isa (x tbl)  (nth (table-class tbl) x))

(defun table-width (tbl)
  (length (table-columns tbl)))

(defun table-copy (tbl &optional (new (copy-tree (table-egs tbl))))
  (data :egs     new
        :name    (table-name tbl)
        :klass   (table-class tbl)
        :columns (columns-header (table-columns tbl))))

;;;; columns isa list of header
(defstruct header name classp ignorep 
	   (f (make-hash-table :test #'equal)))
(defstruct (numeric  (:include header)))
(defstruct (discrete  (:include header)))

(defun columns-new (cols klass)
  (let (tmp)
    (doitems (col i cols)
      (let ((new  
	     (if (numericp col)
		 (make-numeric :name col :ignorep (ignorep col) :classp  (= i klass))
		 (make-discrete :name col :ignorep (ignorep col) :classp (= i klass)))))
	(push new tmp)))
    (reverse tmp)))

(defun columns-header (cols)
  (mapcar #'header-name cols))
   
(defun numericp (x)
  (equal (char (symbol-name x) 0) #\$))

(defun ignorep (x)
  (equal (char (symbol-name x) 0) #\?))

;; xindex runs over the data and populates the "counts" of each column header.
(defun xindex (tbl)
  (doitems (eg index (table-all tbl) tbl)
    (print (table-columns tbl))
    (print (eg-features eg))
    (mapc #'(lambda (header datum)
	       (xindex-datum header  (eg-class eg) index datum))
	  (table-columns tbl) 
	  (eg-features eg))))

(defmethod xindex-datum ((header discrete) class index datum)
  (let* ((key `(,class ,index ,datum))
	 (hash (header-f key)))
    (incf (gethash key hash 0))))

(defmethod xindex-datum ((header numeric) class index datum)
  (let* ((key      `(,class ,index))
	 (hash     (header-f header))
	 (counter  (gethash  key hash (make-normal))))
    (setf (gethas key hash) counter) ; make sure the hash has the counter
    (add counter datum)))

;;;; the data function returns a table containing some egs

(defstruct eg features class)

(defun data (&key name columns egs  (klass -1))
  (let* (tmp-egs
	 (tbl
          (make-table
           :name name
           :columns (columns-new
                     columns
                     (class-index klass (length columns))))))
    (setf (table-class tbl) 
	  (class-index klass (table-width tbl)))
    (dolist (eg egs)
      (if (setf eg (datums eg klass tbl))
	  (push eg tmp-egs)))
    tbl))

(defun datums (one klass tbl)
  (when
      (ok (= (table-width tbl) (length one))
          (table-cautions tbl) "~a wrong size" one)
    (mapc #'datum (table-columns tbl) one)
    (push (make-eg :class (isa one tbl) :features one)
	  (table-all tbl))))

(defmethod datum ((cell discrete) about-cell)
  "things to do when reading a descrete datum"
  (declare (ignore cell about-cell))
  t)

(defmethod datum ((cell numeric) about-cell)
  "things to do when reading a numeric datum"
  (declare (ignore cell about-cell))
  t)

(defun class-index (klass width)
  (if (< klass 0) (+ klass width) klass))

(defun make-data1 ()
  (data
   :name   'weather
   :columns '(forecast temp humidty $windy play)
   :egs    '((sunny    hot  high   FALSE no) 
             (sunny    hot  high   TRUE  yes)
             (sunny    hot  high         yes)
             )))

(deftest test-table ()
  (check 
    (samep 
     (make-data1)
  "#S(TABLE
   :NAME WEATHER
   :COLUMNS (#S(DISCRETE
                :NAME FORECAST
                :CLASSP NIL
                :IGNOREP NIL
                :F #<HASH-TABLE :TEST EQUAL :COUNT 0 {B044A29}>)
             #S(DISCRETE
                :NAME TEMP
                :CLASSP NIL
                :IGNOREP NIL
                :F #<HASH-TABLE :TEST EQUAL :COUNT 0 {B044C79}>)
             #S(DISCRETE
                :NAME HUMIDTY
                :CLASSP NIL
                :IGNOREP NIL
                :F #<HASH-TABLE :TEST EQUAL :COUNT 0 {B044EC9}>)
             #S(NUMERIC
                :NAME $WINDY
                :CLASSP NIL
                :IGNOREP NIL
                :F #<HASH-TABLE :TEST EQUAL :COUNT 0 {B04C141}>)
             #S(DISCRETE
                :NAME PLAY
                :CLASSP T
                :IGNOREP NIL
                :F #<HASH-TABLE :TEST EQUAL :COUNT 0 {B04C391}>))
   :CLASS 4
   :CAUTIONS #(CAUTION :ALL ((SUNNY HOT HIGH YES) wrong size) :PATIENCE 19)
   :ALL (#S(EG :FEATURES (SUNNY HOT HIGH TRUE YES) :CLASS YES)
         #S(EG :FEATURES (SUNNY HOT HIGH FALSE NO) :CLASS NO)))
")))

(deftest test-xindex ()
  (xindex (make-data1)))
