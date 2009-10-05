(defparameter *seed0* 10013)
(defparameter *seed*  *seed0*)

(defun reset-seed () (setf *seed* *seed0*))

(defun park-miller-randomizer ()
  "The Park-Miller multiplicative congruential randomizer
  (CACM, October 88, Page 1195). Creates pseudo random floating
  point numbers in the range 0.0 < x <= 1.0."
  (let ((multiplier 
	  16807.0d0);16807 is (expt 7 5)
	(modulus 
	  2147483647.0d0)) ;2147483647 is (- (expt 2 31) 1)
    (let ((temp (* multiplier *seed*)))
      (setf *seed* (mod temp modulus))
      (/ *seed* modulus))))

(defun my-random (n)
  "Returns a pseudo random floating-point number
  in range 0.0 <= number < n"
  (let ((random-number (park-miller-randomizer)))
    ;; We subtract the randomly generated number from 1.0
    ;; before scaling so that we end up in the range
    ;; 0.0 <= x < 1.0, not 0.0 < x <= 1.0
    (* n (- 1.0d0 random-number))))

(defun my-random-int (n)
  "Returns a pseudo-random integer in the range 0 <= n-1."
  (let ((random-number (/ (my-random 1000.0) 1000)))
    (floor (* n random-number))))

(defun random-demo ()
  (let (counts out)
    (labels 
	((sorter (x y)  (< (car x) (car y)))
         (zap    ()     (setf out nil)
		        (reset-seed) 
		        (setf counts (make-hash-table)))
	  (cache  (k v) (push (list k v) out)))
      (zap)
      (dotimes (i 100) 
        (inch  (my-random-int 10) counts))
      (maphash #'cache counts)
      (sort out #'sorter))))

;; (deftest test-random ()
;;   (check
;;     (samep (random-demo) (random-demo))))
