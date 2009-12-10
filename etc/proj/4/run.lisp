(load "main")

(load "d-data/mushroom")
(load "d-data/boston-housing")
(load "d-data/weather")
(load "d-data/weathernumerics")
(load "d-data/additionalbolts")
(load "d-data/ionosphere")
(load "d-data/soybean")

(defparameter output nil)
(defparameter stack nil)

(defun print-hash-entry (key value)
  (push (list key value) stack)
)

(defun hash-all (hashtable)
  (maphash #'print-hash-entry hashtable)
)

(defun twor-performance (output)
  (let ((passes 0))
    (dolist (x output)
      (hash-all x)
    )
    (dolist (y stack)
      (if (not (null (first (second y))))
        (incf passes)
      )
    )
    (float (/ passes (length stack)))
  )
)

(defun nb-performance (output)
  (let ((passes 0))
    (dolist (x output)
      (if (not (null (third x)))
        (incf passes)
        (print 'FUCK)
      )
    )
    (print `AA)
    (float (/ (print passes) (length output)))
  )
)

(defun 2b-performance (output)
  (nb-performance output)
)

(defun generate-fifths (table)
  (let ((training (copy-table table)) (testing (copy-table table)))
    (setf (table-all training) nil)
    (dotimes (x (floor (/ (length (table-all table)) 5)))
      (let ((row (random (length (table-all testing)))))
        (push (nth row (table-all testing)) (table-all training))
        (setf (table-all testing) (remove (nth row (table-all testing)) (table-all testing)))
      )
    )
    ;;; Technically this is backwards.  Train on large, test on small.
    (list testing training)
  )
)

(defparameter datasets nil)
(push (mushroom) datasets)
(push (boston-housing) datasets)
(push (group1bolts) datasets)
(push (weather2) datasets)
(push (weather-numerics) datasets)
(push (ionosphere) datasets)
(push (soybean) datasets)

(defun run (datasets)
  (let ((stats nil) (per-table-stats nil) (single-pass nil))
    (dolist (x datasets)
      (print (list 'PRESENTLY-COMPUTING-OVER (table-name x)))
      (dotimes (i 1)
        (let ((train-test (generate-fifths x)))

          (normalize (first train-test)) (normalize (second train-test))	;;; A1
          ;(setf (first train-test) (subsample (first train-test)) 		;;; B1
          ;  (second train-test) (subsample (second train-test))		;;; B1

          (setf (first train-test) (nbins (first train-test)) 			;;; A2
            (second train-test) (nbins (second train-test)))			;;; A2
          ;(setf (first train-test) (binlogging (first train-test))      	;;; B2
          ;  (second train-test) (binlogging (second train-test)))	        ;;; B2
          ;(setf (first train-test) (n-chops (first train-test)) 		;;; C2
          ;  (second train-test) (n-chops (second train-test)))			;;; C2

          (dolist (y (genic (first train-test)))				;;; A3	

            (setf y (relief y))							;;; A4

            (push (naivebayes y (relief (copy-table (second train-test)))) single-pass)		;;; A5
            ;(push (2b y (relief (copy-table (second train-test)))) single-pass)		;;; B5
            ;(push (twor y (relief (copy-table (second train-test)))) single-pass)		;;; C5

            (push (nb-performance single-pass) per-table-stats)
            ;(push (twor-performance single-pass) per-table-stats)
            (print per-table-stats)
            ;(setf output nil)

          )

        )
      )
      (push (list (table-name x) (list per-table-stats)) stats)
      (setf per-table-stats nil)
    )
    stats
  )
)

(defun write-results (stats)
  
)


;(let ((alltimes nil))
;  (dotimes (i 10)
;    (let ((start (get-internal-real-time)))
;      (let ((table (copy-table (boston-housing))))
;
;        ;(normalize table)			;;; A1
;        (setf table (subsample table))		;;; B1
;
;        ;(setf table (nbins table))		;;; A2
;        ;(setf table (binlogging table))	;;; B2
;        (setf table (n-chops table))		;;; C2
;
;        (dolist (x (genic table))		;;; A3	
;
;          (setf x (relief x)) 			;;; A4
;
;          ;(push (naivebayes x x) output)	;;; A5
;          (push (2b x x) output)		;;; B5
;          ;(push (twor x x) output)		;;; C5
;        )
;      )
;      (print (push (- (get-internal-real-time) start) alltimes))
;    )
;  )
;)
