;;;; a table stores headers and examples
(defstruct (table (:print-function table-print))  
  name                      ; symbol          : name of the table
  columns                   ; list of header  : one header to describe each column of data
  class                     ; number          : which column is the header column?
  (cautions (make-caution)) ; list of caution : any load-time errors?
  all                       ; list of eg      : all the examples
)

(defun isa (x tbl)  (nth (table-class tbl) x))

(defun table-width (tbl)
  (length (table-columns tbl)))

(defun table-print (tbl s depth)
  (declare (ignore depth))
  (format s
  "#(TABLE~%~T:NAME ~a~%~T:COLUMNS ~a~%~T :CLASS ~a~%~T :CAUTIONS ~a~%~T :ALL ~a~T)"
          (table-name     tbl)
          (table-columns  tbl)
          (table-class    tbl)
          (table-cautions tbl)
          (table-all      tbl)))

(defun table-copy (tbl &optional (new (copy-tree (table-egs tbl))))
  (data :egs     new
        :name    (table-name tbl)
        :klass   (table-class tbl)
        :columns (columns-header (table-columns tbl))))

;;;; columns isa list of header
(defstruct header name numericp classp ignorep)
(defstruct numeric-header

(defun columns-new (cols klass)
  (let (tmp)
    (doitems (col i cols)
      (push  (make-header :name col
                             :numericp (numericp col)
                             :ignorep (ignorep col)
                             :classp  (= i klass))
	     tmp))
    (reverse tmp)))

(defun columns-header (cols)
  (mapcar #'header-name cols))
   
(defun numericp (x)
  (equal (char (symbol-name x) 0) #\$))

(defun ignorep (x)
  (equal (char (symbol-name x) 0) #\?))

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
      (if (setf eg (data1 eg klass tbl))
	  (push eg tmp-egs)))
    tbl))

(defun data1 (one klass tbl)
  (when
      (ok (= (table-width tbl) (length one))
          (table-cautions tbl) "~a wrong size" one)
    (mapc #'meta-hook one (table-columns tbl))
    (push (make-eg :class (isa one tbl) :features one)
	  (table-all tbl))))

(defun meta-hook (cell about-cell)
  (format t "~a ~a~%" cell about-cell))

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
