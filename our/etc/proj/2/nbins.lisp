(defun transpose (x)
   (apply #'mapcar (cons #'list x)))

(defun lowest (data)
  (let ((lowval (car data)))
    (dolist (current data lowval)
      (if (< current lowval)
          (setf lowval current)
          ()
     ))))

(defun highest (data)
  (let ((highval (car data)))
    (dolist (current data highval)
      (if (> current highval)
          (setf highval current)
          ()
     ))))

(defun nbins (n data)
(let ((newdata (transpose data)))                                 ;make data a list of columns instead of list of rows
   (dolist (sublist newdata newdata)                           ;traverse each column to ...
     (if (typep (car sublist) 'number);if1              ; ...see if it contains numeric or discrete data
         (let ((interval (+ 1 (floor(/ (- (highest sublist) (lowest sublist)) n)))));if numeric, generate bin size
               (dotimes (element (length sublist) sublist)                  ;then go through each element
                        (dotimes (x n)                          ;at each element, figure out what bin it goes in...
                        (let((thisBin (+ (* interval x) (lowest sublist))))       ;...by multiplying the bin size by which iteration we're on
                             (if (< (nth element sublist) (+ thisBin interval)); (lowest sublist)));if2            ;see if number fits the bin
                                  (if (>= (nth element sublist) thisBin);if3
                                     (setf (nth element sublist) thisBin) ; 
                                      ;else3                  
                                    );close if3
                                  ;else2
                              );close if
                         );close let, body of dotimes
                         );close dotimes, body of dolist
                );close dolist body
               );close let
        ;else1
       );close if body
     );close dolist
   (transpose newdata)
 ));close defun                                ;switch data back to a list of rows
