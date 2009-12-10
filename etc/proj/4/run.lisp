(load "main")

(load "d-data/boston-housing")
(defparameter output nil)

(let ((alltimes nil))
  (dotimes (i 10)
    (let ((start (get-internal-real-time)))
      (let ((table (copy-table (boston-housing))))

        ;(normalize table)			;;; A1
        (setf table (subsample table))		;;; B1

        ;(setf table (nbins table))		;;; A2
        ;(setf table (binlogging table))	;;; B2
        (setf table (n-chops table))		;;; C2

        (dolist (x (genic table))		;;; A3	

          (setf x (relief x)) 			;;; A4

          (push (naivebayes x x) output)	;;; A5
          ;(2b x x) 				;;; B5
          ;(push (twor x x) output)		;;; C5
        )
      )
      (print (push (- (get-internal-real-time) start) alltimes))
    )
  )
)
