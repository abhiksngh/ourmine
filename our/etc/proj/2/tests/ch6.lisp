;; chapter 6.3
(defun philosoph (thing &optional (property 'good))
  (list thing 'is property))

(defun oracle (thing &rest args)
  (list 'first 'is thing 'rest 'is args))
                                                              
(deftest test-optional()
  (let ((n (philosoph 'life)))
    (let ((m (philosoph 'life 'opportunity)))
      (check
	(and
          (samep n "(life is good)")
          (samep m "(life is opportunity)"))))))


(deftest test-rest()
  (let ((n (oracle 'life 'chance 'ala 'bala)))
    (check
      (samep n "(first is life rest is (chance ala bala))"))))
    
;; chapter 6.5
(let ((counter 0))
  (defun reset10 ()
    (setf counter 0))
  (defun stamp10()
    (setf counter (+ counter 1))))

(deftest test-sharevar()
  (let ((n (list (stamp10) (stamp10) (reset10) (reset10) (stamp10))))
    (check
      (samep n '(1 2 0 0 1)))))


