(defun make-data-Enjoy-Sports ()
  (data
   :name   'EnjoySports
   :columns '(Sky AirTemp Humidity Wind Water Forecast EnjoySports)
   :egs    '((Sunny Warm Normal Strong Warm Same Yes) 
             (Sunny Warm High Strong Warm Same Yes)
             (Rainy Cold High Strong Warm Change No)
             (Sunny Warm High Strong Cool Change Yes)
             )))

(defun make-data-Random-Enjoy-Sports ()
  (data
   :name   'EnjoySports
   :columns '(Sky AirTemp Humidity Wind Water Forecast EnjoySports)
   :egs    (generate-random '(sunny warm ? ? ? ?))))


(defun find-s (train)
  (let* ((inst (table-all train))
        (hypothesis '(0 0 0 0 0 0)))
    (dolist (obj inst)
      (if (equal (eg-class obj) 'Yes)
          (setf hypothesis (generalize hypothesis (eg-features obj)))))
    hypothesis))


(defun generalize (hypothesis instance)
  (if (null hypothesis)
      nil
      (cons (consistent (car hypothesis) (car instance))
              (generalize (cdr hypothesis) (cdr instance)))))

(defun consistent(hyp inst)
  (if (equal hyp inst) hyp
      (if (equal hyp 0) inst '?)))


(defun test-find-s ()
  (find-s (make-data-Enjoy-Sports)))

(defun generate-random (concept-target)
  (let* ((rand-examples nil))
    (dotimes (i 10 rand-examples)
      (push (gen-positive-instance concept-target) rand-examples)
      (push (gen-negative-instance concept-target) rand-examples))))

(defun gen-positive-instance (concept-target)
  (let* ((instance (append concept-target '(Yes))))
  (dotimes (i 6 instance)
    (if (equal (nth i concept-target) '?)
        (if (equal i 0) (setf (nth i instance) (random-choice 'Sunny 'Rainy 'Cloudy))
            (if (equal i 1) (setf (nth i instance) (random-choice 'Warm 'Cold))
                (if (equal i 2) (setf (nth i instance) (random-choice 'Normal 'High))
                    (if (equal i 3) (setf (nth i instance) (random-choice 'Strong 'Weak))
                        (if (equal i 4) (setf (nth i instance) (random-choice 'Warm 'Cool))
                            (if (equal i 5) (setf (nth i instance)(random-choice 'Same 'Change))))))))))))



(defun gen-negative-instance (concept-target)
  (let* ((instance (append concept-target '(No))))
    (dotimes (i 6 instance)
      (if (not (equal (nth i instance) '?))
          (if (equal i 0)
              (if (equal (nth i instance) 'Sunny)(setf (nth i instance) (random-choice 'Rainy 'Cloudy))
                  (if (equal (nth i instance) 'Rainy) (setf (nth i instance) (random-choice 'Sunny 'Cloudy))
                      (setf (nth i instance)(random-choice 'Sunny 'Rainy))))
              (if (equal i 1)
                  (if (equal (nth i instance) 'Warm) (setf (nth i instance) 'Cold)
                      (setf (nth i instance) 'Warm))
                  (if (equal i 2)
                      (if (equal (nth i instance) 'Normal) (setf (nth i instance) 'High)
                          (setf (nth i instance) 'Normal))
                      (if (equal i 3)
                          (if (equal (nth i instance) 'Strong) (setf (nth i instance) 'Weak)
                              (setf (nth i instance) 'Strong))
                          (if (equal i 4)
                              (if (equal (nth i instance) 'Warm) (setf (nth i instance) 'Cool)
                                  (setf (nth i instance) 'Warm))
                              (if (equal i 5)
                                  (if (equal (nth i instance) 'Same) (setf (nth i instance) 'Change)
                                      (setf (nth i instance) 'Same))))))))
          (if (equal i 0) (setf (nth 0 instance) (random-choice 'Sunny ' Rainy 'Cloudy))
              (if (equal i 1) (setf (nth 1 instance) (random-choice 'Warm 'Cold))
                  (if (equal i 2) (setf (nth 2 instance) (random-choice 'Normal 'Hight))
                      (if (equal i 3) (setf (nth 3 instance) (random-choice 'Strong 'Weak))
                          (if (equal i 4) (setf (nth 4 instance) (random-choice 'Warm 'Cool))
                              (if (equal i 5) (setf (nth 5 instance) (random-choice 'Same 'Change))))))))))))
                  
              

        
