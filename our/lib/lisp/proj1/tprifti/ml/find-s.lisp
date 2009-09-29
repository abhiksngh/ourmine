(defun make-data-Enjoy-Sports ()
  (data
   :name   'EnjoySports
   :columns '(Sky AirTemp Humidity Wind Water Forecast EnjoySports)
   :egs    '((Sunny Warm Normal Strong Warm Same Yes) 
             (Sunny Warm High Strong Warm Same Yes)
             (Rainy Cold High Strong Warm Change No)
             (Sunny Warm High Strong Cool Change Yes)
             )))

(defun make-data-Random-Enjoy-Sports (target-concept)
  (data
   :name   'EnjoySports
   :columns '(Sky AirTemp Humidity Wind Water Forecast EnjoySports)
   :egs    (generate-random target-concept)))


(defun find-s (train target-concept)
  (let* ((inst (table-all train))
         (count 0)
         (hypothesis '(0 0 0 0 0 0)))
    (dolist (obj inst)
      (if (equal target-concept hypothesis)
          (return-from find-s (values target-concept count)))
      (setf count (incf count))
      (if (equal (eg-class obj) 'Yes)
          (setf hypothesis (generalize hypothesis (eg-features obj)))))
    (values hypothesis count)))


(defun generalize (hypothesis instance)
  (if (null hypothesis)
      nil
      (cons (consistent (car hypothesis) (car instance))
              (generalize (cdr hypothesis) (cdr instance)))))

(defun consistent(hyp inst)
  (if (equal hyp inst) hyp
      (if (equal hyp 0) inst '?)))


(defun test-find-s ()
  (find-s (make-data-Enjoy-Sports) '(Sunny Warm ? ? ? ?)))


(defun stat-test-find-s()
  (let* ((sum 0)
         (hyp))
    (dotimes (i 20 (values hyp (float (/ sum 20))))
      (multiple-value-bind (hypothesis count)
          (find-s (make-data-random-Enjoy-Sports '(Sunny Warm ? ? ? ?)) '(Sunny Warm ? ? ? ?))
      (setf sum (incf sum count))
      (setf hyp hypothesis)))))


(defun generate-random (concept-target)
  (let* ((rand-examples nil)
         (rand-neg (random 7)))
    (dotimes (i (- 20 rand-neg))
      (push (gen-positive-instance concept-target) rand-examples))
    (dotimes (i rand-neg (shuffle rand-examples))
      (push (gen-negative-instance concept-target) rand-examples))))

(defun gen-positive-instance (concept-target)
  (let* ((instance (append concept-target '(Yes))))
  (dotimes (i 6 instance)
    (cond ((equal (nth i concept-target) '?)
           (cond ((equal i 0)(setf (nth i instance) (random-choice 'Sunny 'Rainy 'Cloudy)))
                 ((equal i 1)(setf (nth i instance) (random-choice 'Warm 'Cold)))
                 ((equal i 2)(setf (nth i instance) (random-choice 'Normal 'High)))
                 ((equal i 3)(setf (nth i instance) (random-choice 'Strong 'Weak)))
                 ((equal i 4)(setf (nth i instance) (random-choice 'Warm 'Cool)))
                 ((equal i 5) (setf (nth i instance)(random-choice 'Same 'Change)))))))))



(defun gen-negative-instance (concept-target)
  (let* ((instance (append concept-target '(No))))
    (dotimes (i 6 instance)
      (cond ((not (equal (nth i instance) '?))
             (cond ((equal i 0)
                    (cond ((equal (nth i instance) 'Sunny)(setf (nth i instance) (random-choice 'Rainy 'Cloudy)))
                          ((equal (nth i instance) 'Rainy) (setf (nth i instance) (random-choice 'Sunny 'Cloudy)))
                          (t (setf (nth i instance)(random-choice 'Sunny 'Rainy)))))
                   ((equal i 1)
                    (cond ((equal (nth i instance) 'Warm) (setf (nth i instance) 'Cold))
                          ( t (setf (nth i instance) 'Warm))))
                   ((equal i 2)
                    (cond ((equal (nth i instance) 'Normal) (setf (nth i instance) 'High))
                          ( t (setf (nth i instance) 'Normal))))
                   ((equal i 3)
                    (cond ((equal (nth i instance) 'Strong) (setf (nth i instance) 'Weak))
                          ( t (setf (nth i instance) 'Strong))))
                   ((equal i 4)
                    (cond ((equal (nth i instance) 'Warm) (setf (nth i instance) 'Cool))
                          (t(setf (nth i instance) 'Warm))))
                   ((equal i 5)
                    (cond ((equal (nth i instance) 'Same) (setf (nth i instance) 'Change))
                          (t (setf (nth i instance) 'Same))))))
             (t (cond ((equal i 0) (setf (nth 0 instance) (random-choice 'Sunny ' Rainy 'Cloudy)))
                      ((equal i 1) (setf (nth 1 instance) (random-choice 'Warm 'Cold)))
                      ((equal i 2) (setf (nth 2 instance) (random-choice 'Normal 'High)))
                      ((equal i 3) (setf (nth 3 instance) (random-choice 'Strong 'Weak)))
                      ((equal i 4) (setf (nth 4 instance) (random-choice 'Warm 'Cool)))
                      ((equal i 5) (setf (nth 5 instance) (random-choice 'Same 'Change)))))))))
                  
              

        
