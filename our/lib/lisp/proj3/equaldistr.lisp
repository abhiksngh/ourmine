(defun equaldistr (train)
  (let* ((data (table-egs-to-lists train))
         (class-col (table-class train))
         (temp-inst)
         (count 0)
         (t-count (f (xindex train) 'true))
         (f-count (f (xindex train) 'false)))
    (if (> t-count f-count)
        (progn
          (loop do
               (loop do
                    (setf temp-inst (nth (random (length data)) data))
                  until (eql (nth class-col temp-inst) 'true))
               (setf data (remove temp-inst data :test #'equal))
               (incf count)
             until (= (length data) (* f-count 2))))
        (progn
          (loop do
               (loop do
                    (setf temp-inst (nth (random (length data)) data))
                  until (eql (nth class-col temp-inst) 'false))
               (setf data (remove temp-inst data :test #'equal))
               (incf count)
             until (= (length data) (* t-count 2)))))
    (make-simple-table (table-name train) (table-columns train) data)))
        

