(defstruct chart-item name value)

(defun chart-sort (predicate)
  (lambda (item1 item2)
	(let ((x (chart-item-value item1))
		  (y (chart-item-value item2)))
	  (funcall predicate x y))))

(defun show-bar-graph-bar (item width &key (maxval nil maxval-p) (barchar #\x))
  (let ((maximumvalue (if maxval-p
						maxval
						(chart-item-value item))))
	(format t "~a: " (chart-item-name item))
	(dotimes (i (floor (* (chart-item-value item)
						  (/ width maximumvalue))))
	  (princ barchar))
	(format t " [~a]~%" (chart-item-value item))))

(defun show-bar-graph (itemlist &key (width 45) (barchar #\x) (predicate #'>))
  (let* ((sortedlist (sort (copy-list itemlist) (chart-sort #'>)))
		 (displaylist (sort (copy-list itemlist) (chart-sort predicate)))
		 (listmax (first sortedlist)))
	(dolist (eachitem displaylist)
	  (show-bar-graph-bar eachitem width :maxval (chart-item-value listmax) :barchar barchar))))

(defun test-show-bar-graph (&key (base 2) (width 45) (barchar #\x) (predicate #'>))
  (let ((mydata)
		(random-strings '("data0" "data1" "data2" "data3" "data4")))
	(dotimes (i 5)
	  (push (make-chart-item :name (nth i random-strings) :value (expt base i)) mydata))
	(show-bar-graph mydata :width width :barchar barchar :predicate predicate)))

;(defun run-times (board)
;	(let (times)
;		(dotimes (i 20 (sort times #'<)
;			(let ((before (get-internal-runtime))
;				(explore board #'what2do=best)
;			(push (- (get-internal-runtime) before) times)))))))

