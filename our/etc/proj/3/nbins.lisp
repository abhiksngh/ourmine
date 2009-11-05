;(defun transpose (x)
;   (apply #'mapcar (cons #'list x)))


(defstruct bin-member
  bin
  value)



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
                          ;(print sublist)
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
    ;(print "here?")
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


;; pre-bin
;; ((0 470 3.905) (0 610 2.835) (0 580 3.409) (0 720 3.72) (0 530 2.976)
;;  (1 610 3.362) (0 570 2.819) (1 570 3.005) (0 720 3.476) (0 550 3.381)
;;  (0 600 3.329) (1 640 3.338) (0 570 2.829) (0 570 3.905) (1 500 3.267)
;;  (0 530 3.148) (0 550 3.367) (0 670 3.776) (0 530 3.224) (0 620 3.393)
;;  (0 610 3.379) (0 520 3.376) (0 580 3.225) (0 570 3.225) (0 600 3.633)
;;  (0 490 3.235) (1 610 3.238) (1 590 3.1) (1 550 2.985) (0 590 3.557)
;;  (1 630 3.256) (0 580 3.535) (0 650 2.643) (1 480 2.755) (0 450 2.733)
;;  (0 710 3.613) (0 570 3.433) (0 540 3.586) (0 660 3.89) (0 530 3.457)
;;  (0 540 3.481) (0 640 3.757) (0 570 3.681) (0 590 3.324) (1 420 2.533)
;;  (0 600 2.968) (0 580 3.114) (0 620 2.957) (0 490 3.195) (0 610 3.667)
;;  (0 520 3.376) (0 680 3.876) (0 440 3.205) (1 600 3.09) (1 500 2.648)
;;  (0 540 3.505) (0 560 2.986) (0 520 3.133) (1 680 3.319) (0 550 3.329)
;;  (0 590 3.252))

;; post-bin
;; ((0 470 3.533) (0 610 2.533) (0 580 2.533) (0 720 3.533) (0 530 2.533)
;;  (1 610 2.533) (0 570 2.533) (1 570 2.533) (0 720 2.533) (0 550 2.533)
;;  (0 600 2.533) (1 640 2.533) (0 570 2.533) (0 570 3.533) (1 500 2.533)
;;  (0 530 2.533) (0 550 2.533) (0 670 3.533) (0 530 2.533) (0 620 2.533)
;;  (0 610 2.533) (0 520 2.533) (0 580 2.533) (0 570 2.533) (0 600 3.533)
;;  (0 490 2.533) (1 610 2.533) (1 590 2.533) (1 550 2.533) (0 590 3.533)
;;  (1 630 2.533) (0 580 3.533) (0 650 2.533) (1 480 2.533) (0 450 2.533)
;;  (0 710 3.533) (0 570 2.533) (0 540 3.533) (0 660 3.533) (0 530 2.533)
;;  (0 540 2.533) (0 640 3.533) (0 570 3.533) (0 590 2.533) (1 420 2.533)
;;  (0 600 2.533) (0 580 2.533) (0 620 2.533) (0 490 2.533) (0 610 3.533)
;;  (0 520 2.533) (0 680 3.533) (0 440 2.533) (1 600 2.533) (1 500 2.533)
;;  (0 540 2.533) (0 560 2.533) (0 520 2.533) (1 680 2.533) (0 550 2.533)
;;  (0 590 2.533))

(defun test-bin()
  (let (
        (thisbin )
        (bin-count 1)
        (bin-lst)
        )
    (dotimes (current 10) 
      (setq thisbin (make-bin-item))
      (print thisbin)
      (print (bin-item-bin thisbin))
      (setf (bin-item-bin thisbin) (+ 1 current))
      (print (bin-item-bin thisbin))
      (setf bin-lst (append bin-lst (list thisbin))))
    (print (mapcar #'binmember-bin bin-lst))
    )
  )


;;rewrite
;; (defun nbins2 (n source-table)
;;   (let ((new-data (transpose (get-data source-table)))
;;         (label-lst)
;;         (lable-count 1)
;;         (new-table)
;;         (interval)
;;         (bin-index) ;so it works for n still
;;         (bin-lst)   ;list of bins
        
;for each column
;generate bins
;find min and max for each bin
;determine which bin it belongs in
;append bin-lst (make-bin-item :bin whatever :value item)
;append bin-lst to new-data
