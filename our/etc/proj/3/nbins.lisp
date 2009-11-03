;(defun transpose (x)
;   (apply #'mapcar (cons #'list x)))

(defun lowest (data)
  (let ((lowval (car data)))
    (dolist (current data lowval)
      (if (< current lowval)
          (setf lowval current)
          ()
     ))))

;; (defun highest (data &key  (comp #'<) (key #'identity))
;;   (let ((highval (funcall key (car data))))
;;     (dolist (current data highval)
;;       (if (funcall comp (funcall key current) (funcall key highval))
;;           (setf highval current)))))

(defun highest (data)
  (let ((highval (car data)))
    (dolist (current data highval)
      (if (< current highval)
          (setf highval current)
          ()
     ))))

(defun nbins (n source-table)
(let ((newdata (transpose (get-data source-table)))
      (label-lst)
      (lable-count 1)
      (new-table));make data a list of columns instead of list of rows
  (dolist (sublist newdata newdata)              ;traverse each column to ...
    (if (typep (car sublist) 'number);if1              ; ...see if it contains numeric or discrete data
        (let ((interval (+ 1 (floor(/ (- (highest sublist) (lowest sublist)) n)))));if numeric, generate bin size
          (dotimes (element (length sublist) sublist)                  ;then go through each element
            (dotimes (x n)                          ;at each element, figure out what bin it goes in...
              (let((thisBin (+ (* interval x) (lowest sublist))))       ;...by multiplying the bin size by which iteration we're on
                (if (< (nth element sublist) (+ thisBin interval)); (lowest sublist)));if2            ;see if number fits the bin
                    (if (>= (nth element sublist) thisBin);if3
                        (progn
                          (setf (nth element sublist) thisBin)
                          (print sublist)
                          ) ; 
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
    (print "here?")
    );close dolist
  (setf new-table (data
                  :name (table-name source-table)
                  :columns (columns-header (table-columns source-table))
                  :klass (table-class source-table)
                  :egs
                  (reverse (transpose newdata))))
  new-table));close defun                                ;switch data back to a list of rows


(defun 10bins (source-table)
  (nbins 10 source-table))


;; :ALL (#S(EG :FEATURES (17 2 30 1.5 0 10 19.46 12.97) :CLASS 12.97)
;;          #S(EG :FEATURES (33 2 30 1.5 0 6 27.02 18.01) :CLASS 18.01)
;;          #S(EG :FEATURES (22 2 10 2.5 2 10 3.94 7.88) :CLASS 7.88)
;;          #S(EG :FEATURES (16 2 10 2.5 2 6 9.22 18.44) :CLASS 18.44)
;;          #S(EG :FEATURES (37 2 10 2.5 0 10 12.04 24.08) :CLASS 24.08)
;;          #S(EG :FEATURES (40 2 10 2.5 0 6 16.67 33.34) :CLASS 33.34)
;;          #S(EG :FEATURES (2 2 10 1.5 2 10 8.39 16.78) :CLASS 16.78)
;;          #S(EG :FEATURES (30 2 10 1.5 2 6 11.28 22.56) :CLASS 22.56)
;;          #S(EG :FEATURES (24 2 10 1.5 0 10 17.56 35.12) :CLASS 35.12)
;;          #S(EG :FEATURES (25 2 10 1.5 0 6 5.7 11.4) :CLASS 11.4))

;; pre-10bins
;; ((17 2 30 1.5 0 10 19.46 12.97) (33 2 30 1.5 0 6 27.02 18.01)
;;  (22 2 10 2.5 2 10 3.94 7.88) (16 2 10 2.5 2 6 9.22 18.44)
;;  (37 2 10 2.5 0 10 12.04 24.08) (40 2 10 2.5 0 6 16.67 33.34)
;;  (2 2 10 1.5 2 10 8.39 16.78) (30 2 10 1.5 2 6 11.28 22.56)
;;  (24 2 10 1.5 0 10 17.56 35.12) (25 2 10 1.5 0 6 5.7 11.4))

;; ((17 2 30 1.5 0 10 19.46 12.88) (33 2 30 1.5 0 6 27.02 18.01)
;;  (22 2 10 2.5 2 10 3.94 7.88) (16 2 10 2.5 2 6 8.940001 18.44)
;;  (37 2 10 2.5 0 10 11.940001 24.08) (40 2 10 2.5 0 6 16.67 33.34)
;;  (2 2 10 1.5 2 10 7.94 15.88) (30 2 10 1.5 2 6 10.940001 22.56)
;;  (24 2 10 1.5 0 10 17.56 35.12) (25 2 10 1.5 0 6 4.94 10.88))