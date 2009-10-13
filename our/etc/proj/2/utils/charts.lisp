(defstruct chart-item name value)

(defun chart-sort (predicate)
  (lambda (item1 item2)
	(let ((x (chart-item-value item1))
		  (y (chart-item-value item2)))
	  (funcall predicate x y))))

(defun show-bar-graph-bar (item width &key (maxval nil maxval-p)
								           (barchar #\x)
										   (longest 0))
  (let ((maximumvalue (if maxval-p
						maxval
						(chart-item-value item)))
		(spacesneeded (- longest (length (chart-item-name item)))))
	(format t "~a: " (chart-item-name item))
	(when (> spacesneeded 0)
	  (dotimes (i spacesneeded)
		(princ #\ )))
	(dotimes (i (floor (* (chart-item-value item)
						  (/ width maximumvalue))))
	  (princ barchar))
	(format t " [~a]~%" (chart-item-value item))))

(defmethod longer ((item1 chart-item) (item2 chart-item) &key (test #'>))
  (funcall test (length (chart-item-name item1))
		        (length (chart-item-name item2))))

(defun show-bar-graph (itemlist &key (width 45) (barchar #\x) (predicate #'>))
  (let* ((sortedlist (sort (copy-list itemlist) (chart-sort #'>)))
		 (displaylist (sort (copy-list itemlist) (chart-sort predicate)))
		 (listmax (first sortedlist))
		 (longest (length (chart-item-name (first (sort itemlist #'longer))))))
	(dolist (eachitem displaylist)
	  (show-bar-graph-bar eachitem width
						  :maxval (chart-item-value listmax)
						  :barchar barchar
						  :longest longest))))

(defun build-test-data-for-bars (names &key (base 2))
  (let ((out))
	(dotimes (i 5 out)
	  (push (make-chart-item :name (nth i names) :value (expt base i)) out))))

(defun test-show-bar-graph (&key (base 2)
								 (width 45)
								 (barchar #\x)
								 (predicate #'>)
								 (random-strings
								   '("data0" "data1" "data2" "data3" "data4")))
  (let ((mydata (build-test-data-for-bars random-strings)))
	(show-bar-graph mydata :width width :barchar barchar :predicate predicate)))

;(defun run-times (board)
;	(let (times)
;		(dotimes (i 20 (sort times #'<)
;			(let ((before (get-internal-runtime))
;				(explore board #'what2do=best)
;			(push (- (get-internal-runtime) before) times)))))))

