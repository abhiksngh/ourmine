;;;; boot
(defun make () 
  (handler-bind 
      ((style-warning #'muffle-warning))
    (load "with.lisp")))

;;;; macros
(defmacro o (&rest l) 
  (let ((last (gensym))) 
    `(let (,last) 
       ,@(mapcar #'(lambda(x) `(setf ,last (oprim ,x))) l) 
       (terpri) 
       ,last))) 

(defmacro oprim (x)  
  `(progn (format t "[~a]=[~a] " (quote ,x) ,x) ,x)) 

(defmacro !        (&rest l) `(funcall (wme-! *w*) ',l))
(defmacro wu       ()        `(wme-utility-function *w*))
(defmacro wfile    ()        `(wme-file *w*))
(defmacro wtable   ()        `(wme-table *w*))
(defmacro wcols    ()        `(table-cols    (wme-table *w*)))
(defmacro wname    ()        `(table-name    (wme-table *w*)))
(defmacro wrows    ()        `(table-rows    (wme-table *w*)))
(defmacro wklasses ()        `(table-klasses (wme-table *w*)))

;;;; structs
(defstruct table name rows klasses cols)
(defstruct row   cells class utility sorter)
(defstruct col   name goalp)
(defstruct klass name (n 0) (a 0) (b 0) (c 0) (d 0))
(defstruct (num  (:include col)) min max)
(defstruct (sym  (:include col)) (counts (make-hash-table)))
(defstruct wme 
  (goal #\!) 
  (num  #\$)
  (unknown #\?) 
  (file "table.lisp") 
  (utility-function #'zero)
  (!                #'the-class)
  (ready            #'sort-rows)
  (run              #'noop)
  (report           #'noop)
  table            
)

;;;; globals
(defparameter *w* nil)
(defun w0 () (setf *w* (make-wme)))


;;;; main
;;; reader
(defun data (&optional f reader)
  (reset-seed)
  (w0) 
  (if reader 
      (setf (wme-! *w*) reader))
  (load (or f (wme-file))) 
;  (funcall (wme-ready *w*))
 ; (funcall (wme-report *w*))
)

(defmacro deftable (name &rest cols)
  `(setf (wme-table *w*)
	 (make-table :name ',name 
		     :cols (mapcar #'make-col ',cols))))

(defun make-col (col)
  (if (nump col)
      (make-num :name col :goalp (goalp col))
      (make-sym :name col :goalp (goalp col))))

(defun sort-rows () 
  (setf (wrows) (sort (wrows) #'< :key #'row-sorter)))

(defun the-class (l &aux (class (car (goals-in-list l))))
  (print l) 
  (unless (member class (wklasses) :key #'klass-name)
    (push (make-klass :name class) (wklasses)))
  (push (make-row :cells   l 
		  :class   class
		  :utility (funcall (wu) class)
		  :sorter  (+ (randf 0.5) 
			      (position class (wklasses) 
					:key #'klass-name)))
	(wrows)))

(defun goals-in-list (l)   (mapcan #'1goal-in-list l (wcols)))
(defun 1goal-in-list (x c) (and (col-goalp c) (knownp x) (list x)))   

;;;; utils
;;; about symbols
(defun thingp (x y) (and (symbolp x) (find y (symbol-name x))))
(defun goalp  (x)   (thingp x (wme-goal *w*)))
(defun nump   (x)   (thingp x (wme-num *w*)))
(defun knownp (x)   (not (eql x (wme-unknown *w*))))

;;; random stuff
(let* ((seed0      10013)
       (seed       seed0)
       (multiplier 16807.0d0)
       (modulus    2147483647.0d0))
  (defun reset-seed ()  (setf seed seed0))
  (defun randf      (n) (* n (- 1.0d0 (park-miller-randomizer))))
  (defun randi      (n) (floor (* n (/ (randf 1000.0) 1000))))
  (defun park-miller-randomizer ()
    (setf seed (mod (* multiplier seed) modulus))
    (/ seed modulus))
)

;;; test engine
(defparameter *tests* nil)
(defmacro deftest (name params  &body body)
  `(progn (unless (member ',name *tests*) (push ',name *tests*))
	  (defun ,name ,params ,@body)))

(let ((pass 0) 
      (fail 0))
  (defun test (want got)
    (labels  
	((white    (c)   (member c '(#\Space #\Tab #\Newline) :test #'char=))
	 (whiteout (s)   (remove-if #'white s))
	 (samep    (x y) (string= (whiteout (format nil "~(~a~)" x))
				  (whiteout (format nil "~(~a~)" y)))))
      (cond ((samep want got) (incf pass))
	    (t                (incf fail)
			      (format t "~&; fail : expected ~a~%" want)))
      got))
  (defun tests ()
    (labels ((run (x) (format t "~&; ~a~%" x) (funcall x)))
      (when *tests*
	(setf fail 0 pass 0)
	(mapcar #'run (reverse *tests*))
	(format t "~&; pass : ~a = ~5,1f% ~%; fail : ~a = ~5,1f% ~%"
		pass (* 100 (/ pass (+ pass fail)))
		fail (* 100 (/ fail (+ pass fail)))))))
)

;;; misc
(defun zero (l)       (declare (ignore l)) 0)
(defun noop (&rest l) (declare (ignore l)) t)

;;;; testss
(deftest !deftest1 ()
  (let ((a 1))
    (test
     (+ a 1) 2)))

(deftest !deftest2 ()
  (let ((a 1))
    (test
     (+ a 1) 3)))

(deftest !data () 
  (data "weather.lisp") 
  (test (wclasses) 
	"(#S(KLASS :NAME YES :N 0 :A 0 :B 0 :C 0 :D 0)
          #S(KLASS :NAME NO :N 0 :A 0 :B 0 :C 0 :D 0))"))
