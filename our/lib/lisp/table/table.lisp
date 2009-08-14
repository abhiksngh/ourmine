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

(defun table-copy (tbl &optional (new (copy-tree (table-all tbl))))
  (data :egs     new
        :name    (table-name tbl)
        :klass   (table-class tbl)
        :columns (columns-header (table-columns tbl))))

