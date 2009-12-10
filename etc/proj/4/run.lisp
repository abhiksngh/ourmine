(load "main")

(load "d-data/boston-housing")
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
      )
    )
    (float (/ passes (length output)))
  )
)

(defun 2b-performance (output)
  (nb-performance output)
)

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

          ;(push (naivebayes x x) output)	;;; A5
          (push (2b x x) output)		;;; B5
          ;(push (twor x x) output)		;;; C5
        )
      )
      (print (push (- (get-internal-real-time) start) alltimes))
    )
  )
)
