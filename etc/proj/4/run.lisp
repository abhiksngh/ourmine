(load "main")

(let ((alltimes nil))
  (dotimes (i 10)
    (let ((start (get-internal-real-time)))
      (let ((table (copy-table (mushroom))))
        ;(normalize table)			;;; A1
        (setf table (subsample table))		;;; B1
        ;(setf table (nbins table))		;;; A2
        ;(setf table (binlogging table))	;;; B2
        (setf table (n-chops table))		;;; C2
        (dolist (x (genic table))		;;; A3	
          (setf x (relief x)) 			;;; A4
          ;(naivebayes x x) 			;;; A5
          ;(2b x x) 				;;; B5
          (twor x) 				;;; C5
        )
      )
      (print (push (- (get-internal-real-time) start) alltimes))
    )
  )
)
