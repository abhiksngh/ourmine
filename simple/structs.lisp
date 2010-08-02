;;;; macros

(defmacro !        (&rest l) `(funcall (wme-! *w*) ',l))
(defmacro theu       ()        `(wme-utility-function *w*))
(defmacro thefile    ()        `(wme-file *w*))
(defmacro thetable   ()        `(wme-table *w*))
(defmacro thecols    (&optional tbl) `(table-cols    (or ,tbl (wme-table *w*))))
(defmacro thename    (&optional tbl) `(table-name    (or ,tbl (wme-table *w*))))
(defmacro therows    (&optional tbl) `(table-rows    (or ,tbl (wme-table *w*))))
(defmacro theklasses (&optional tbl) `(table-klasses (or ,tbl (wme-table *w*))))

;;;; structs
(defstruct table name rows klasses cols)
(defstruct row   cells class utility sortkey)
(defstruct col   name goalp)
(defstruct klass name (n 0) (a 0) (b 0) (c 0) (d 0))
(defstruct (num  (:include col)) min max)
(defstruct (sym  (:include col)) (counts (make-hash-table)))
(defstruct wme 
  (goal             #\!) 
  (num              #\$)
  (unknown          #\?) 
  (file             "table.lisp") 
  (utility-function #'zero)
  (!                #'defrow)
  (ready            #'sort-rows)
  (run              #'noop)
  (report           #'noop)
  table            
)

;;;; globals
(defparameter *w* nil)
(defun w0 () (setf *w* (make-wme)))
